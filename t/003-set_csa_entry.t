#!/usr/bin/env perl

######################################################################
##
##    Testing methods of class CSA::Entry.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-23.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Scalar::Util qw( blessed );
use Test::Exception;
use Test::More tests => 36;
use Test::Warn;

use lib "${Bin}/../lib";

use CSA::Entry;
use CSA::Site;


## Test directory t/.
my $t_dir = $Bin;

## Test pdb id attribute method.
my @pdb_ids = ( '1ile', '1zh0', '3cok', '1235k1kd', '?a2m', '' );
for my $pdb_id ( @pdb_ids ) {
    set_pdbid( $pdb_id );
}

my $csaentry_oo = CSA::Entry->new();

## Check pdb_id returns undef by default.
is( 
    $csaentry_oo->pdb_id, 
    undef, 
    'PDB ID set to undef by default.',
);

## Test sites method.
my $csa_site1 = CSA::Site->new();
$csa_site1->site_number( '0' );
my $csa_site2 = CSA::Site->new();
$csa_site2->site_number( '1' );
my $csa_site3 = CSA::Site->new();
$csa_site3->site_number( '2' );
my @csa_sites = ( $csa_site1, $csa_site2, $csa_site3 );
$csaentry_oo  = set_csa_sites( $csaentry_oo, \@csa_sites );

## Test add_site method.
my $csa_site4 = CSA::Site->new();
$csa_site4->site_number( '3' );
add_csa_site( $csaentry_oo, $csa_site4 );

## Test get_site method.
test_get_site( $csaentry_oo );

## Test add_site method with a site with no Site Number.
my $csa_site5 = CSA::Site->new();
add_wrong_csa_site( $csaentry_oo, $csa_site5 );


exit;


######################################################################
## Test set-behaviour of CSA::Entry::pdb_id.
sub set_pdbid {
    my $pdb_id = shift;

    my $oo = CSA::Entry->new();
    
    if ( $pdb_id =~ /^\w{4}$/ ) {
        $oo->pdb_id( $pdb_id );
        is( 
            $oo->pdb_id, 
            $pdb_id, 
            'PDB ID properly set.' 
        );
    }
    else {
        warning_is 
            {
                $oo->pdb_id( $pdb_id )
            }
            "Warning: pdb_id not assigned due to wrong format ($pdb_id).",
            'Testing warning for pdb_id with wrong format.'
        ;
        is( 
            $oo->pdb_id, 
            undef, 
            'Wrong PDB ID not set.' 
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Entry::sites.
sub set_csa_sites {
    my $oo             = shift;
    my $csa_sites_aref = shift;
    
    $oo->sites( $csa_sites_aref );
    
    ## Check what is stored in sites() is an array ref.
    is( 
        ref($oo->sites()),
        'ARRAY',
        'CSA::Entry::sites returns an array ref.',
    );
    
    ## Check there are three elements in sites() array ref.
    is(
        scalar @{ $oo->sites() },
        3,
        'CSA::Entry::sites contains 3 elements.',
    );
    
    ## Check elements stored in the array ref are CSA::Site 
    ## compliant.
    sites_elements( $oo );
    
    return $oo;
}

#####################################################################
## Test set-behaviour of CSA::Entry::add_site method.
sub add_csa_site {
    my $oo        = shift;
    my $csa_site = shift;
    
    my $is_added = $oo->add_site( $csa_site );
    
    ## Check CSA::Entry::add_site returns expected value.
    is( 
        $is_added, 
        1, 
        "CSA::Entry::add_site returns 1 on adding entry.", 
    );
    
    ## Check site was properly added by checking CSA::Entry::sites.
    is( 
        ref($oo->sites()),
        'ARRAY',
        "CSA::Entry::sites still returns aref after adding site.",
    );
    is(
        scalar @{ $oo->sites() },
        4,
        "CSA::Entry::sites contains 4 elements after adding one.",
    );
    
    ## Check elements stored in array ref in CSA::Entry::sites are 
    ## CSA::Site compliant objects.
    sites_elements( $oo );
}

#####################################################################
## Test set-behaviour of CSA::Entry::add_site method when added site
## has no defined Site Number.
sub add_wrong_csa_site {
    my $oo        = shift;
    my $csa_site = shift;
    
    dies_ok 
        { $oo->add_site( $csa_site ) } 
        'Dies when adding Site with no Site Number.'
    ;
    
    ## Check site was not added by checking CSA::Entry::sites.
    is( 
        ref($oo->sites()),
        'ARRAY',
        "CSA::Entry::sites still returns aref after adding site.",
    );
    is(
        scalar @{ $oo->sites() },
        4,
        "CSA::Entry::sites contains 4 elements after adding one.",
    );
    
    ## Check elements stored in array ref in CSA::Entry::sites are 
    ## CSA::Site compliant objects.
    sites_elements( $oo );
}

#####################################################################
## Check that elements stored in sites are CSA::Site compliant.
sub sites_elements {
    my $oo = shift;
    
    for my $site ( @{ $oo->sites() } ) {
        ok(
            $site->isa( 'CSA::Site' ),
            'Object in CSA::Entry->sites is CSA::Site compliant.',
        );
    }
}

#####################################################################
## Test get_site method with different site numbers.
sub test_get_site {
    my $oo = shift;

    ## Site that was added to the entry.
    my $site1 = $oo->get_site( '0' );
    ok( 
        defined $site1,
        'Site with Site Number 0 is in entry.',
    );
    is(
        blessed $site1,
        'CSA::Site',
        'Site 0 is a blessed reference from CSA::Site',
    );
    ok(
        $site1->isa( 'CSA::Site' ),
        'Site 0 is CSA::Site compliant.',
    );

    ## Site that was added to the entry.
    my $site2 = $oo->get_site( '1' );
    ok( 
        defined $site2,
        'Site with Site Number 1 is in entry.',
    );
    is(
        blessed $site2,
        'CSA::Site',
        'Site 1 is a blessed reference from CSA::Site',
    );
    ok(
        $site2->isa( 'CSA::Site' ),
        'Site 1 is CSA::Site compliant.',
    );

    ## Site that was not added to the entry.
    my $site3 = $oo->get_site( '5' );
    ok(
        ! defined $site3,
        'Site 5 is not in entry.',
    );
}
