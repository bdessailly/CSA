#!/usr/bin/env perl

######################################################################
##
##    Testing creation methods of class CSA.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Test::More tests => 10;

use lib "${Bin}/../lib";

use CSA;
use CSA::Entry;
use CSA::Site;
use CSA::Residue;
use CSA::IO;


## Test directory t/.
my $t_dir = $Bin;

## Check Class CSA.
my $csa_oo = CSA->new();
created_oo_test( $csa_oo, 'CSA' );

## Check Class CSA::Entry.
my $csaentry_oo = CSA::Entry->new();
created_oo_test( $csaentry_oo, 'CSA::Entry' );

## Check Class CSA::Site.
my $csasite_oo = CSA::Site->new();
created_oo_test( $csasite_oo, 'CSA::Site' );

## Check Class CSA::Residue.
my $csares_oo = CSA::Residue->new();
created_oo_test( $csares_oo, 'CSA::Residue' );

## Check Class CSA::IO.
my $csaio_oo = CSA::IO->new();
created_oo_test( $csaio_oo, 'CSA::IO' );


exit;


######################################################################
## Test creation of CSA::* objects.
sub created_oo_test {
    my $oo      = shift;
    my $oo_type = shift;
    
    ok( defined $oo, "Created $oo_type object is defined." );
    ok( $oo->isa($oo_type), "Created $oo_type object is compliant." );
}
