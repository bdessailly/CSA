package CSA::Residue;

use warnings;
use strict;

use Carp;

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
    my $class = shift;
    
    my $self = {};
    
    $self->{CHAIN_ID}          = undef;
    $self->{CHEMICAL_FUNCTION} = undef;
    $self->{RESIDUE_NUMBER}    = undef;
    $self->{RESIDUE_TYPE}      = undef;
    
    bless( $self, $class );
    
    return $self;
}

=head2 residue_type

    $csa_res->residue_type( 'HIS' );
    
  CSA::Residue::residue_type gets the residue type string as argument
  for assignment. Always returns the residue type string or undef. 
  The residue type must be an alphanumeric string. If that is not the
  case, a warning is issued and the residue type is not set.

=cut
sub residue_type {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        
        ## Accepted formats are alphanumeric strings.
        if ( $val =~ /^\w+$/ ) {
            $self->{RESIDUE_TYPE} = $val;
        }
        else {
            carp "Warning: residue_type not assigned due to wrong ",
                 "format ($val).";
        }
    }
    
    return $self->{RESIDUE_TYPE};
}

=head2 chain_id

    $csa_res->chain_id( 'A' );
    
  CSA::Residue::chain_id gets the chain ID string as argument for 
  assignment. Always returns the chain ID string or undef. The 
  chain ID must be a single alphanumeric character or an empty 
  space. If that is not the case, a warning is issued and the chain 
  ID is not set.

=cut
sub chain_id {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {

        ## Accepted format is a single alphanumeric character.
        if ( $val =~ /^\w*$/ ) {
            $self->{CHAIN_ID} = $val;
        }
        else {
            carp "Warning: chain_id not assigned due to wrong ",
                 "format ($val).";
        }
    }
    
    return $self->{CHAIN_ID};
}

=head2 residue_number

    $csa_res->residue_number( '54' );
    
  CSA::Residue::residue_number gets the residue number string as 
  argument for assignment. Always returns the residue number string 
  or undef. The residue number must be an integer (positive or 
  negative). If that is not the case, a warning is issued and the 
  residue number is not set.

=cut
sub residue_number {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        
        ## accepted format are integers.
        if ( $val =~ /^-*\d+$/ ) {
            $self->{RESIDUE_NUMBER} = $val;
        }
        else {
            carp "Warning: residue_number not assigned due to ",
                 "wrong format ($val).";
        }
    }
    
    return $self->{RESIDUE_NUMBER};
}

=head2 chemical_function

    $csa_res->chemical_function( 'S' );
    
  CSA::Residue::chemical_function gets the chemical function string 
  as argument for assignment. Always returns the chemical function 
  string or undef. The chemical function must be a string of 
  alphanumeric characters. If that is not the case, a warning is 
  issued and the chemical function is not set.

=cut
sub chemical_function {
    my $self = shift;
    my $val  = shift;
    
    if ( defined $val ) {
        
        ## accepted formats are alphanumeric strings.
        if ( $val =~ /^\w+$/ ) {
            $self->{CHEMICAL_FUNCTION} = $val;
        }
        else {
            carp "Warning: chemical_function not assigned due to ",
                 "wrong format ($val).";
        }
    }
    
    return $self->{CHEMICAL_FUNCTION};
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
