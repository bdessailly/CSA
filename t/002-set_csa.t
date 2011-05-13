#!/usr/bin/env perl

#####################################################################
##
##    Testing methods of class CSA.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##
#####################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Test::More tests => 18;

use lib "${Bin}/../lib";

use CSA;
use CSA::Entry;


## Test directory t/.
my $t_dir = $Bin;

my $csa_oo = CSA->new();

## Test version number method.
my @vnumbers = qw( '2.2.12' '2.1' '1.1.3' 'A.1.A' '0.0.0' 'NA' );
for my $vnumber ( @vnumbers ) {
    set_csa_vnumber( $csa_oo, $vnumber );
}

## Test entries method.
my $csa_entry1 = CSA::Entry->new();
my $csa_entry2 = CSA::Entry->new();
my $csa_entry3 = CSA::Entry->new();
my @csa_entries = qw( $csa_entry1 $csa_entry2 $csa_entry3 );
$csa_oo = set_csa_entries( $csa_oo, \@csa_entries );

## Test add_entry method.
my $csa_entry4 = CSA::Entry->new();
add_csa_entry( $csa_oo, $csa_entry4 );


exit;


#####################################################################
## Test set-behaviour of CSA::version_number method.
sub set_csa_vnumber {
    my $oo      = shift;
    my $vnumber = shift;

    $oo->version_number( $vnumber );

    is( $oo->version_number, $vnumber, "CSA version number set." );
}

#####################################################################
## Test set-behaviour of CSA::entries method.
sub set_csa_entries {
    my $oo               = shift;
    my $csa_entries_aref = shift;
    
    $oo->entries( $csa_entries_aref );
    
    ## Check what is stored (and returned) by CSA::entries is an 
    ## array ref.
    is( 
        $oo->entries()->ref, 
        'ARRAY', 
        "CSA::entries returns an array ref.",
    );
    
    ## Check there are three elements in the stored array ref.
    is(
        scalar @{ $oo->entries() },
        3,
        "CSA::entries contains three elements.",
    );
    
    ## Check elements stored in array ref in CSA::entries are 
    ## CSA::Entry compliant objects.
    entries_elements( $oo );
    
    return $oo;
}

#####################################################################
## Test set-behaviour of CSA::add_entry method.
sub add_csa_entry {
    my $oo        = shift;
    my $csa_entry = shift;
    
    my $is_added = $oo->add_entry( $csa_entry );
    
    ## Check CSA::add_entry returns expected value.
    is( $is_added, 1, "CSA::add_entry returns 1 on adding entry." );
    
    ## Check entry was properly added by checking CSA::entries.
    is( 
        $oo->entries()->ref,
        'ARRAY',
        "CSA::entries still returns aref after adding entry.",
    );
    is(
        scalar @{ $oo->entries() },
        4,
        "CSA::entries contains 4 elements after adding one.",
    );
    
    ## Check elements stored in array ref in CSA::entries are 
    ## CSA::Entry compliant objects.
    entries_elements( $oo );
}

#####################################################################
## Check all entries stored in array ref in CSA::entries are 
## CSA::Entry compliant objects.
sub entries_elements {
    my $oo = shift;
    
    for my $csa_entry( @{ $oo->entries } ) {
        ok(
            $csa_entry->isa( 'CSA::Entry' ), 
            "Objects in CSA::entries are CSA::Entry compliant.",
        );
    }
}