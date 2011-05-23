package CSA;

use warnings;
use strict;

use Carp;

=head1 NAME

CSA - Catalytic Site Atlas dataset object representation. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This module provides an object representation of a Catalytic Site Atlas 
dataset. The standard way to create a CSA dataset object is to read in 
a CSA-format dataset file using the read() method in CSA::IO.
See L<http://www.ebi.ac.uk/thornton-srv/databases/cgi-bin/CSA/CSA_Help.pl>
for more info on the format of CSA dataset files. 
Also, 'perldoc CSA::IO' for more details on how to use CSA::IO.

    use CSA;

    ## Create a CSA dataset object.
    my $csa = CSA->new();
    
    ## Store CSA version number.
    $csa->version_number( '2.2.12' );
    
    ## Store CSA entries (only entries with defined PDB IDs).
    my @csa_entries = ( $csa_entry1, $csa_entry2 );
    $csa->entries( \@csa_entries );
    
    ## Add CSA entry (only entries with defined PDB ID).
    $csa->add_entry( $csa_entry3 );
    
    ## Retrieve a CSA entry from its PDB ID.
    my $csa_entry = $csa->get_entry( '1ile' );

=head1 SUBROUTINES/METHODS

=head2 new

    my $csa = CSA->new();
    
  CSA::new creates a new empty object to represent a CSA dataset.

=cut
sub new {
    my $class = shift;
    
    my $self = {};
    
    $self->{ENTRIES}        = {};
    $self->{VERSION_NUMBER} = undef;
    
    bless( $self, $class );
    
    return $self;
}

=head2 version_number

    $csa->version_number( '2.2.12' );

  CSA::version_number gets the CSA version number string as argument
  for assignment. Always returns the version number string or undef.

=cut
sub version_number {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        $self->{VERSION_NUMBER} = $val;
    }
    
    return $self->{VERSION_NUMBER};
}

=head2 entries

    my $csa_entry1 = CSA::Entry->new();
    my $csa_entry2 = CSA::Entry->new();
    
    ## Add PDB IDs and other features to CSA entries.
    ...
    
    my @csa_entries = ( $csa_entry1, $csa_entry2 );
    
    $csa->entries( \@csa_entries );
    
  CSA::entries gets a list of L<CSA::Entry> compliant objects as an 
  array reference as argument for assignment. All entries in the 
  array reference should have defined PDB IDs. Entries are stored in 
  a hash where keys are the PDB IDs of the entries and the values 
  are the entries themselves. Always returns the array reference 
  (empty array if entries have not been added yet).

=cut
sub entries {
    my $self         = shift;
    my $entries_aref = shift;
    
    if ( defined $entries_aref ) {

        ## make sure all entries are CSA::Entry compliant and
        ## that they have defined PDB IDs.
        for my $entry_oo ( @{ $entries_aref } ) {
            if ( $entry_oo->isa( 'CSA::Entry' ) != 1 ) {
                confess "Error: attempting to add non-CSA::Entry ",
                        "compliant object into CSA->entries";
            }
            
            if ( defined $entry_oo->pdb_id() ) {
                $self->{ENTRIES}{ $entry_oo->pdb_id() } = $entry_oo;
            }
            else {
                confess "Error: attempting to add CSA::Entry with ",
                        "no defined PDB ID into CSA->entries";
            }
        }
    }

    my @entries = values %{ $self->{ENTRIES} };

    return \@entries;
}

=head2 add_entry

    my $csa_entry3 = CSA::Entry->new();
    
    ## Set PDB ID and other features of the CSA::Entry object.
    $csa_entry3->pdb_id( '1ile' );
    ...
    
    $csa->add_entry( $csa_entry3 );
    
  CSA::add_entry gets a L<CSA::Entry> compliant object as argument 
  for assignment. The entry should have its PDB ID defined. The 
  method will add the given CSA entry as part of the current list of 
  CSA entries in the CSA dataset. Returns 1 upon success, 0 upon 
  failure.

=cut
sub add_entry {
    my $self     = shift;
    my $entry_oo = shift;
    
    if ( ! defined $entry_oo ) {
        confess "Error: CSA->add_entry expects an argument for ",
             "assignment.";
    }
    
    if ( $entry_oo->isa( 'CSA::Entry' ) != 1 ) {
        confess "Error: CSA->add_entry only takes CSA::Entry ",
                "compliant objects for assignment.";
    }
    
    if ( ! defined $entry_oo->pdb_id() ) {
        confess "Error: CSA->add_entry only takes a CSA::Entry ",
                "with defined PDB ID for assignment.";
    }
    
    my $before_add_count = scalar keys %{ $self->{ENTRIES} };
    $self->{ENTRIES}{ $entry_oo->pdb_id() } = $entry_oo;
    my $after_add_count  = scalar keys %{ $self->{ENTRIES} };
    
    if ( $after_add_count == $before_add_count + 1 ) {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 get_entry 

    my $pdbid = '1ile';
    my $entry = $csa->get_entry( $pdbid );
    if ( defined $entry ) {
        print "CSA dataset contains an entry for $pdbid\n";
    }

  CSA::get_entry gets a PDB ID string as argument and looks for an
  entry with that PDB ID in the dataset. Returns the L<CSA::Entry> 
  compliant object if it finds it or undef.

=cut
sub get_entry {
    my $self   = shift;
    my $pdb_id = shift;
    
    my $entry = ( exists $self->{ENTRIES}{$pdb_id} ) 
              ? $self->{ENTRIES}{$pdb_id} : undef;
    
    return $entry;
}

=head1 AUTHOR

Benoit H Dessailly, C<< <benoit at biochem.ucl.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-csa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CSA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CSA


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

1; # End of CSA
