package CSA;

use warnings;
use strict;

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
    
    ## Store CSA entries.
    my @csa_entries = ( $csa_entry1, $csa_entry2 );
    $csa->entries( \@csa_entries );
    
    ## Add CSA entry.
    $csa->add_entry( $csa_entry3 );

=head1 SUBROUTINES/METHODS

=head2 new

    my $csa = CSA->new();
    
  CSA::new creates a new empty object to represent a CSA dataset.

=cut
sub new {

}

=head2 entries

    my $csa_entry1 = CSA::Entry->new();
    my $csa_entry2 = CSA::Entry->new();
    
    ## Add details to CSA entries.
    
    my @csa_entries = ( $csa_entry1, $csa_entry2 );
    
    $csa->entries( \@csa_entries );
    
  CSA::entries gets a list of L<CSA::Entry> compliant objects as an 
  array reference as argument for assignment. Always returns the 
  array reference or undef.

=cut
sub entries {

}

=head2 version_number

    $csa->version_number( '2.2.12' );

  CSA::version_number gets the CSA version number string as argument
  for assignment. Always returns the version number string or undef.

=cut
sub version_number {

}

=head2 add_entry

    my $csa_entry3 = CSA::Entry->new();
    
    ## Add CSA::Entry details
    ...
    
    $csa->add_entry( $csa_entry3 );
    
  CSA::add_entry gets a L<CSA::Entry> compliant object as argument 
  for assignment. The method will add the given CSA entry as part of
  the current list of CSA entries in the CSA dataset. Returns 1 upon
  success, 0 upon failure.

=cut
sub add_entry {

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
