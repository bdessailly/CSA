#!/usr/bin/env perl

######################################################################
##
##    Testing methods of class CSA::Entry.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Test::More tests => 22;
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

## Check pdb_id returns an empty string by default.
is( 
    $csaentry_oo->pdb_id, 
    '', 
    'PDB ID set to empty string by default.',
);

## Test sites method.
my $csa_site1 = CSA::Site->new();
my $csa_site2 = CSA::Site->new();
my $csa_site3 = CSA::Site->new();
my @csa_sites = ( $csa_site1, $csa_site2, $csa_site3 );
$csaentry_oo  = set_csa_sites( $csaentry_oo, \@csa_sites );

## Test add_site method.
my $csa_site4 = CSA::Site->new();
add_csa_site( $csaentry_oo, $csa_site4 );

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
            '', 
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