package CSA::Entry;

use warnings;
use strict;

use Carp;

=head1 NAME

CSA::Entry - CSA entry object representation. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use CSA::Entry;

    ## Create a CSA entry object.
    my $csa_entry = CSA::Entry->new();
    
    ## Store CSA entry sites (only sites with defined site number).
    $csa_entry->sites( \@sites );

    ## Add site to CSA entry (only sites with defined site number).
    $csa_entry->add_site( $csa_site );
    
    ## Set/Get CSA entry attributes...
    $csa_entry->pdb_id( '1ile' );
    
    ## Retrieve a specific site by its site number.
    my $csa_site = $csa_entry->get_site( '0' );
    
=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_entry = CSA::Entry->new();
    
  CSA::Entry::new creates a new empty object to represent a CSA 
  entry.

=cut
sub new {
    my $class = shift;
    
    my $self = {};
    
    $self->{SITES}  = {};
    $self->{PDB_ID} = undef;
    
    bless( $self, $class );
    
    return $self;
}

=head2 pdb_id

    $csa_entry->pdb_id( '1ile' );
    
  CSA::Entry::pdb_id gets the PDB ID string as argument for 
  assignment. Always returns the PDB ID string or undef. The pdb id 
  must be a 4-character alphanumeric string. If that is not the 
  case, a warning is issued and the pdb id is not set.

=cut
sub pdb_id {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        
        ## Accepted formats are 4-alphanumeric characters.
        if ( $val =~ /^\w{4}$/ ) {
            $self->{PDB_ID} = $val;
        }
        else {
            carp 'Warning: pdb_id not assigned due to wrong format ',
                 "($val).";
        }
    }
    
    return $self->{PDB_ID};
}

=head2 sites

    my $csa_site1 = CSA::Site->new();
    my $csa_site2 = CSA::Site->new();
    
    ## Add site number and other features to CSA site objects.
    $csa_site1->site_number( '0' );
    $csa_site2->site_number( '1' );
    
    my @sites = ( $csa_site1, $csa_site2 );
    
    $csa_entry->sites( \@sites );
    
  CSA::Entry::sites gets a list of L<CSA::Site> compliant objects as
  an array reference as argument for assignment. All sites in the 
  array reference should have defined Site Numbers. Sites are stored 
  in a hash where keys are the Site Numbers of the sites and the 
  values are the sites themselves. Always returns the array 
  reference (empty array if no sites have been added yet).

=cut
sub sites {
    my $self       = shift;
    my $sites_aref = shift;
    
    if ( defined $sites_aref ) {

        for my $site_oo ( @{ $sites_aref } ) {

            ## make sure all sites are CSA::Site compliant.
            if ( $site_oo->isa( 'CSA::Site' ) != 1 ) {
                confess "Error: attempting to add non-CSA::Site ",
                        "compliant object into CSA::Entry->sites";
            }

            ## make sure Site Number is defined.
            if ( defined $site_oo->site_number() ) {
                $self->{SITES}{ $site_oo->site_number() } = $site_oo;
            }
            else {
                confess "Error: attempting to add CSA::Site with ",
                        "no defined Site Number into ",
                        "CSA::Entry->sites";
            }
        }
    }

    my @sites = values %{ $self->{SITES} };

    return \@sites;
}

=head2 add_site

    my $csa_site = CSA::Site->new();
    $csa_site->site_number( '1' );
    $csa_entry->add_site( $csa_site );
    
  CSA::Entry::add_site gets a L<CSA::Site> compliant object as 
  argument for assignment. The site should have a defined Site 
  Number. The method will add the given CSA site to the current 
  list of CSA sites in the CSA entry. Returns 1 upon success, 0 
  upon failure.

=cut
sub add_site {
    my $self    = shift;
    my $site_oo = shift;
    
    if ( ! defined $site_oo ) {
        confess "Error: CSA::Entry->add_site expects an argument ",
                "for assignment.";
    }
    
    if ( $site_oo->isa( 'CSA::Site' ) != 1 ) {
        confess "Error: CSA::Entry->add_site only takes CSA::Site ",
                "compliant objects for assignment.";
    }
    
    if ( ! defined $site_oo->site_number() ) {
        confess "Error: CSA::Entry->add_site only takes a ",
                "CSA::Site with defined Site Number for assignment.";
    }
    
    my $before_add_count = scalar keys %{ $self->{SITES} };
    $self->{SITES}{ $site_oo->site_number() } = $site_oo;
    my $after_add_count  = scalar keys %{ $self->{SITES} };
    
    if ( $after_add_count == $before_add_count + 1 ) {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 get_site 

    my $pdbid = '1ile';
    my $entry = $csa->get_entry( $pdbid );
    if ( defined $entry ) {
        print "CSA dataset contains an entry for $pdbid\n";
    }

  CSA::Entry::get_site gets a Site Number string as argument and 
  looks for a site with that Site Number in the entry. Returns the 
  L<CSA::Site> compliant object if it finds it or undef.

=cut
sub get_site {
    my $self        = shift;
    my $site_number = shift;
    
    my $site = ( exists $self->{SITES}{$site_number} ) 
             ? $self->{SITES}{$site_number} : undef;
    
    return $site;
}

=head1 AUTHOR

Benoit H Dessailly, C<< <benoit at biochem.ucl.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-csa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CSA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CSA::Entry


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

1; # End of CSA::Entry
