#!/usr/bin/env perl

#####################################################################
##
##    Testing methods of class CSA.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-16.
##    Updated, 2011-05-20.
##    Updated, 2011-05-23.
##
#####################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Scalar::Util qw( blessed );
use Test::Exception;
use Test::More tests => 54;

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
$csa_entry1->pdb_id( '1ile' );
my $csa_entry2 = CSA::Entry->new();
$csa_entry2->pdb_id( '1cka' );
my $csa_entry3 = CSA::Entry->new();
$csa_entry3->pdb_id( '1val' );
my @csa_entries = ( $csa_entry1, $csa_entry2, $csa_entry3 );
$csa_oo = set_csa_entries( $csa_oo, \@csa_entries );

## Test add_entry method.
my $csa_entry4 = CSA::Entry->new();
$csa_entry4->pdb_id( '3cka' );
add_csa_entry( $csa_oo, $csa_entry4 );

## Test get_entry method.
test_get_entry( $csa_oo );

## Test add_entry method with CSA::Entry with no defined pdb id.
my $csa_entry5 = CSA::Entry->new();
add_wrong_csa_entry( $csa_oo, $csa_entry5 );

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
        ref($oo->entries()), 
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
        ref($oo->entries()),
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
## Test set-behaviour of CSA::add_entry method when added CSA::Entry
## does not have its pdb id defined.
sub add_wrong_csa_entry {
    my $oo        = shift;
    my $csa_entry = shift;
    
    dies_ok
        {
    	    $oo->add_entry( $csa_entry );
        }
        'Error when adding incomplete CSA::Entry to CSA.'
    ;
    
    ## Make sure entry was not added by checking CSA::entries.
    is( 
        ref($oo->entries()),
        'ARRAY',
        "CSA::entries still returns aref after adding entry.",
    );
    is(
        scalar @{ $oo->entries() },
        4,
        "CSA::entries contains 4 elements after not adding last.",
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
    	    defined $csa_entry,
    	    'Object in CSA::entries is defined.',
    	);
    	
    	is(
    	    blessed $csa_entry,
    	    'CSA::Entry',
    	    'Variable is a blessed reference from CSA::Entry',
    	);
    	
        ok(
            $csa_entry->isa( 'CSA::Entry' ), 
            "Objects in CSA::entries are CSA::Entry compliant.",
        );
    }
}

#####################################################################
## Test get_entry method with different pdb ids.
sub test_get_entry {
    my $oo = shift;
    
    ## Entry that was added to the dataset.
    my $entry1 = $oo->get_entry( '1ile' );
    ok( 
        defined $entry1,
        'Entry with PDB ID 1ile is in dataset.',
    );
    is(
        blessed $entry1,
        'CSA::Entry',
        'Entry 1ile is a blessed reference from CSA::Entry',
    );
    ok(
        $entry1->isa( 'CSA::Entry' ),
        'Entry 1ile is CSA::Entry compliant.',
    );
    
    ## Entry that was added to the dataset.
    my $entry2 = $oo->get_entry( '3cka' );
    ok( 
        defined $entry2,
        'Entry with PDB ID 3cka is in dataset.',
    );
    is(
        blessed $entry2,
        'CSA::Entry',
        'Entry 3cka is a blessed reference from CSA::Entry',
    );
    ok(
        $entry2->isa( 'CSA::Entry' ),
        'Entry 3cka is CSA::Entry compliant.',
    );
    
    ## Entry that was not added to the dataset.
    my $entry3 = $oo->get_entry( '1a2p' );
    ok(
        ! defined $entry3,
        'Entry 1a2p is not in dataset.',
    );
}
