package CSA::Residue;

use warnings;
use strict;

=head1 NAME

CSA::Residue - CSA residue object representation. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use CSA::Residue;

    ## Create a CSA residue object.
    my $csa_res = CSA::Residue->new();
    
    ## Store CSA residue residue type.
    $csa_res->residue_type( 'HIS' );
    
    ## Store CSA residue chain ID.
    $csa_res->chain_id( 'A' );
    
    ## Store CSA residue residue number.
    $csa_res->residue_number( '54' );
    
    ## Store CSA residue chemical function.
    $csa_res->chemical_function( 'S' );
    
=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_res = CSA::Residue->new();
    
  CSA::Residue::new creates a new empty object to represent a CSA 
  residue.

=cut
sub new {

}

=head2 residue_type

    $csa_res->residue_type( 'HIS' );
    
  CSA::Residue::residue_type gets the residue type string as argument
  for assignment. Always returns the residue type string or undef.

=cut
sub residue_type {

}

=head2 chain_id

    $csa_res->chain_id( 'A' );
    
  CSA::Residue::chain_id gets the chain ID string as argument for 
  assignment. Always returns the chain ID string or undef.

=cut
sub chain_id {

}

=head2 residue_number

    $csa_res->residue_number( '54' );
    
  CSA::Residue::residue_number gets the residue number string as 
  argument for assignment. Always returns the residue number string 
  or undef.

=cut
sub residue_number {

}

=head2 chemical_function

    $csa_res->chemical_function( 'S' );
    
  CSA::Residue::chemical_function gets the chemical function string 
  as argument for assignment. Always returns the chemical function 
  string or undef.

=cut
sub chemical_function {

}

=head1 AUTHOR

Benoit H Dessailly, C<< <benoit at biochem.ucl.ac.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-csa at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CSA>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CSA::Residue


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

1; # End of CSA::Residue
