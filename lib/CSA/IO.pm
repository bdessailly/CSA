package CSA::IO;

use warnings;
use strict;

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
    my $csa_dataset = $csa_io->read( csa_file => $f_csa );
    
    ## Read CSA subset.
    my %pdb_ids     = ( 1ile => '', 1zh0 => '', 1n3l => '' );
    my $csa_subset  = $csa_io->read( 
        csa_file => $f_csa, 
        pdb_ids => \%pdb_ids,
    );

=head1 SUBROUTINES/METHODS

=head2 new

    my $csa_io = CSA::IO->new();
    
  CSA::IO::new creates a new empty object to represent a CSA IO.

=cut
sub new {

}

=head2 read

    my $csa_dataset = $csa_io->read( csa_file => $f_csa );
    
  CSA::IO::read gets a file handle opened for reading as argument. 
  It extracts CSA data from the file. Returns a L<CSA> compliant
  object upon success, 0 upon failure. Option 'pdb_ids' allows to
  limit storage of data only to pdb entries in hash reference 
  passed as argument.

=cut
sub read {

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
