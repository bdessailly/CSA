package CSA::Site;

use warnings;
use strict;

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
    
    ## Store CSA site residues.
    $csa_site->residues( \@residues );

    ## Add CSA site residue.
    $csa_site->add_residue( $csa_res );
    
    ## Set/Get CSA site attributes...
    $csa_site->site_number( '1' );
    $csa_site->evidence( 'PSIBLAST' );
    $csa_site->literature_entry( '1f7u' );
    
=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_site = CSA::Site->new();
    
  CSA::Site::new creates a new empty object to represent a CSA site.

=cut
sub new {

}

=head2 residues

    my @residues = ( $csa_res1, $csa_res2 );
    $csa_site->residues( \@residues );
    
  CSA::Site::residues gets a list of L<CSA::Residue> compliant 
  objects as an array reference as argument for assignment. Always
  returns the array reference or undef.

=cut
sub residues {

}

=head2 add_residue

    my $csa_res = CSA::Residue->new();
    $csa_site->add_residue( $csa_res );
    
  CSA::Site::add_residue gets a L<CSA::Residue> compliant object as 
  argument for assignment. The method will add the given CSA residue
  to the current list of CSA residues in the CSA site. Returns 1 upon
  success, 0 upon failure.

=cut
sub add_residue {

}

=head2 site_number

    $csa_site->site_number( '1' );
    
  CSA::Site::site_number gets the site number string as argument for
  assignment. Always returns the site number string or undef. The 
  site number must be an integer. If that is not the case, a warning
  is issued and the site_number is not set.

=cut
sub site_number {

}

=head2 evidence

    $csa_site->evidence( 'PSIBLAST' );
    
  CSA::Site::evidence gets the site evidence string as argument for
  assignment. Always returns the site evidence string or undef. No 
  verification is performed on the contents of the site evidence 
  string but standard values would be 'PSIBLAST' or 'LITERATURE'.

=cut
sub evidence {

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
