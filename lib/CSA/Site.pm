package CSA::Site;

use warnings;
use strict;

use Carp;

=head1 NAME

CSA::Site - CSA site object representation. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use CSA::Site;

    ## Create a CSA site object.
    my $csa_site = CSA::Site->new();
    
    ## Store CSA site residues (only residues with defined position 
    ## and chain ID).
    $csa_site->residues( \@residues );

    ## Add CSA site residue (only residues with defined position and
    ## chain ID).
    $csa_site->add_residue( $csa_res );
    
    ## Set/Get CSA site attributes...
    $csa_site->site_number( '1' );
    $csa_site->evidence( 'PSIBLAST' );
    $csa_site->literature_entry( '1f7u' );
    
    ## Retrieve a specific residue by its position and chain ID).
    my $csa_residue = $csa_site->get_residue( '217A' );
    
=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_site = CSA::Site->new();
    
  CSA::Site::new creates a new empty object to represent a CSA site.

=cut
sub new {
    my $class = shift;
    
    my $self = {};
    
    $self->{RESIDUES}         = {};
    $self->{SITE_NUMBER}      = undef;
    $self->{EVIDENCE}         = undef;
    $self->{LITERATURE_ENTRY} = undef;
    
    bless( $self, $class );
    
    return $self;
}

=head2 site_number

    $csa_site->site_number( '1' );
    
  CSA::Site::site_number gets the site number string as argument for
  assignment. Always returns the site number string or undef. The 
  site number must be an integer. If that is not the case, a warning
  is issued and the site_number is not set.

=cut
sub site_number {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        if ( $val =~ /^\d+$/ ) {
            $self->{SITE_NUMBER} = $val;
        }
        else {
            carp 'Warning: site_number not assigned due to wrong ',
                 "format ($val).";
        }
    }
    
    return $self->{SITE_NUMBER};
}

=head2 evidence

    $csa_site->evidence( 'PSIBLAST' );
    
  CSA::Site::evidence gets the site evidence string as argument for
  assignment. Always returns the site evidence string or undef. No 
  verification is performed on the contents of the site evidence 
  string but standard values would be 'PSIBLAST' or 'LIT' (for 
  literature).

=cut
sub evidence {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        $self->{EVIDENCE} = $val;
    }
    
    return $self->{EVIDENCE};
}

=head2 literature_entry

    $csa_site->literature_entry( '1f7u' );
    
  CSA::Site::literature_entry gets the related literature entry 
  string as argument for assignment. Always returns the related 
  literature entry string or undef. The literature entry must be a 
  string consisting of 4 or 5 alphanumeric characters. If that is 
  not the case, a warning is issued and the literature_entry is not
  set. 

=cut
sub literature_entry {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {    
        
        ## Accepted formats are 4 or 5 alphanumeric characters.
        if ( $val =~ /^\w{4,5}?$/ ) {
            $self->{LITERATURE_ENTRY} = $val;
        }
        else {
            carp 'Warning: literature_entry not assigned due to ',
                 "wrong format ($val).";
        }
    }
    
    return $self->{LITERATURE_ENTRY};
}

=head2 residues

    my @residues = ( $csa_res1, $csa_res2 );
    $csa_site->residues( \@residues );

  CSA::Site::residues gets a list of L<CSA::Residue> compliant 
  objects as an array reference as argument for assignment. All 
  residues in the array reference should have a defined Residue 
  Number and a defined Chain ID. Residues are stored in a hash 
  where keys are 'Residue Number'+'Chain ID' of the residues and 
  the values are the residues themselves. Always returns the array 
  reference (empty array if no residues have been added yet).

=cut
sub residues {
    my $self          = shift;
    my $residues_aref = shift;

    if ( defined $residues_aref ) {

        for my $res_oo ( @{ $residues_aref } ) {
 
            ## make sure each residue is CSA::Residue compliant.
            if ( $res_oo->isa( 'CSA::Residue' ) != 1 ) {
                confess "Error: attempting to add non-CSA::Residue ",
                        "compliant object into CSA::Site->residues";
            }
            
            ## make sure the Residue Number and Chain ID are 
            ## defined.
            if ( defined $res_oo->residue_number 
              && defined $res_oo->chain_id ) {
              	my $res_id = $res_oo->residue_number 
              	           . $res_oo->chain_id;
                $self->{RESIDUES}{ $res_id } = $res_oo;
            }
            else {
                confess "Error: attempting to add CSA::Residue ",
                        "with no defined Residue Number and ",
                        "Chain ID into CSA::Site->residues";
            }
        }
    }
    
    my @residues = values %{ $self->{RESIDUES} };

    return \@residues;
}

=head2 add_residue

    my $csa_res = CSA::Residue->new();
    $csa_res->residue_number( '217' );
    $csa_res->chain_id( 'A' );
    $csa_site->add_residue( $csa_res );
    
  CSA::Site::add_residue gets a L<CSA::Residue> compliant object as 
  argument for assignment. The residue should have a defined Residue 
  Number and a defined Chain ID. The method will add the given CSA 
  residue to the current list of CSA residues in the CSA site. 
  Returns 1 upon success, 0 upon failure.

=cut
sub add_residue {
    my $self       = shift;
    my $residue_oo = shift;
    
    if ( ! defined $residue_oo ) {
        confess "Error: CSA::Site->add_residue expects an argument ",
                "for assignment.";
    }

    if ( $residue_oo->isa( 'CSA::Residue' ) != 1 ) {
        confess "Error: CSA::Site->add_residue only takes ",
                "CSA::Residue compliant objects for assignment.";
    }
    
    if ( ! defined $residue_oo->residue_number 
      || ! defined $residue_oo->chain_id ) {
        confess "Error: CSA::Site->add_residue only takes a ",
                "CSA::Residue with defined Residue Number and ",
                "Chain ID for assignment.";
    }

    my $before_add_count = scalar keys %{ $self->{RESIDUES} };
    my $res_uid = $residue_oo->residue_number . $residue_oo->chain_id;
    $self->{RESIDUES}{ $res_uid } = $residue_oo; 
    my $after_add_count  = scalar keys %{ $self->{RESIDUES} };
    
    if ( $after_add_count == $before_add_count + 1 ) {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 get_residue

    my $residue_id = '217A';
    my $residue    = $csa->get_residue( $residue_id );
    if ( defined $residue ) {
        print "CSA site contains an entry for residue $residue_id\n";
    }

  CSA::Site::get_residue gets a Residue ID (Residue Number + Chain ID) 
  string as argument and looks for a residue with that ID in the 
  site. Returns the L<CSA::Residue> compliant object if it finds it 
  or undef.

=cut
sub get_residue {
    my $self        = shift;
    my $res_uid = shift;

    my $residue = ( exists $self->{RESIDUES}{$res_uid} ) ? 
                  $self->{RESIDUES}{$res_uid} : undef;

    return $residue;
}

=head1 AUTHOR

Benoit H Dessailly, C<< <benoit at biochem.ucl.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-csa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CSA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CSA::Site


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

1; # End of CSA::Site
