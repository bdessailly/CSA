package CSA::IO;

use warnings;
use strict;

use Carp;
use Fcntl;
use IO::File;

use CSA;
use CSA::Entry;
use CSA::Site;
use CSA::Residue;

=head1 NAME

CSA::IO - Catalytic Site Atlas IO. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use CSA::IO;

    my $csa_io = CSA::IO->new();
    
    ## Read CSA dataset file.
    my $csa_dataset = $csa_io->read( csa_filehandle => $f_csa );
    
    ## Read CSA subset.
    my %pdb_ids     = ( 1ile => '', 1zh0 => '', 1n3l => '' );
    my $csa_subset  = $csa_io->read( 
        csa_filehandle => $fh_csa, 
        pdb_ids => \%pdb_ids,
    );

=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_io = CSA::IO->new();
    
  CSA::IO::new creates a new empty object to represent a CSA IO.

=cut
sub new {
    my $class = shift;
    
    my $self = {};
    
    bless( $self, $class );
    
    return $self;
}

=head2 read

    my $csa_dataset = $csa_io->read( csa_filehandle => $f_csa );
    
    ## Read CSA subset.
    my %pdb_ids     = ( 1ile => '', 1zh0 => '', 1n3l => '' );
    my $csa_subset  = $csa_io->read( 
        csa_filehandle => $fh_csa, 
        pdb_ids => \%pdb_ids,
    );
     
  CSA::IO::read gets a IO::File filehandle open for reading as 
  argument. It extracts CSA data from the file. Returns a L<CSA> 
  compliant object upon success, 0 upon failure. Option 'pdb_ids' 
  allows to limit storage of data only to pdb entries in hash 
  reference passed as argument.

=cut
sub read {
    my $self = shift;
    my %arg  = @_;

    my %pdb_ids = ();
    
    confess "No input CSA filehandle passed to read!\n" 
        unless ( defined $arg{'csa_filehandle'} );
    %pdb_ids = %{ $arg{'pdb_ids'} } if ( defined $arg{'pdb_ids'} );

    ## Create CSA dataset object.
    my $csa_oo = CSA->new();
    
    ## Skip CSA file header line and go back to file start
    ## if first line is not header.
    my $header_line = $arg{'csa_filehandle'}->getline;
    if ( substr($header_line,0,6) ne 'PDB ID' ) {
        $arg{'csa_filehandle'}->seek(0,SEEK_SET);
    }

    ## Initialise control variables for reading CSA file. 
    my $previous_pdb_id      = '';
    my $previous_site_number = '';
    my $previous_site_id     = '';
    
    ## Read CSA file.
    my $csa_site_oo;
    my $csa_entry_oo;
    while ( my $line = $arg{'csa_filehandle'}->getline ) {
        
        ## Save current line data.
        chomp(my @file_columns = split /,/, $line );
        my $pdb_id            = $file_columns[0];
        my $site_number       = $file_columns[1];
        my $residue_type      = $file_columns[2];
        my $chain_id          = $file_columns[3];
        my $residue_number    = $file_columns[4];
        my $chemical_function = $file_columns[5];
        my $evidence          = $file_columns[6];
        my $literature_entry  = $file_columns[7];
        my $site_id           = $pdb_id . $site_number;
        
        ## Skip unwanted PDB entries if required.
        next if ( scalar keys %pdb_ids != 0 && ! exists $pdb_ids{ $pdb_id } );

        ## If new CSA site.
        if ( $site_id ne $previous_site_id ) {
            
            ## add previous csa site to previous csa entry (skip 
            ## this for first line as no previous csa sites/entries
            ## exist yet).
            $csa_entry_oo->add_site( $csa_site_oo ) 
                unless ( $previous_site_id eq '' );
            
            ## create new csa site.
            $csa_site_oo = CSA::Site->new();
            $csa_site_oo->site_number(      $site_number      );
            $csa_site_oo->evidence(         $evidence         );
            $csa_site_oo->literature_entry( $literature_entry );
        }
        
        ## If new CSA entry.
        if ( $pdb_id ne $previous_pdb_id ) {
            
            ## add previous csa entry to csa dataset (skip this for
            ## first line as no previous csa entry exists yet).
            $csa_oo->add_entry( $csa_entry_oo )
                unless ( $previous_site_id eq '' );
            
            ## create new csa entry.
            $csa_entry_oo = CSA::Entry->new();
            $csa_entry_oo->pdb_id(   $pdb_id      );
        }

        ## Create new CSA::Residue object and always add it to 
        ## current site.
        my $csa_residue_oo = CSA::Residue->new();
        $csa_residue_oo->chain_id(          $chain_id          );
        $csa_residue_oo->chemical_function( $chemical_function );
        $csa_residue_oo->residue_number(    $residue_number    );
        $csa_residue_oo->residue_type(      $residue_type      );
        $csa_site_oo->add_residue(          $csa_residue_oo    );
        
        ## Save data from current line to avoid duplicating entry 
        ## and site objects.
        $previous_pdb_id      = $pdb_id;
        $previous_site_number = $site_number;
        $previous_site_id     = $pdb_id . $site_number;
    }
    
    ## add last csa site to csa entry.
    $csa_entry_oo->add_site( $csa_site_oo );
    
    ## add last csa entry to csa dataset.
    $csa_oo->add_entry( $csa_entry_oo ); 
    
    return $csa_oo;
}

=head1 AUTHOR

Benoit H Dessailly, C<< <benoit at biochem.ucl.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-csa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CSA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CSA::IO


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CSA>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CSA>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CSA>

=item * Search CPAN

L<http://search.cpan.org/dist/CSA/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Benoit H Dessailly.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of CSA::IO
