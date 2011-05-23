#!/usr/bin/env perl

######################################################################
##
##    Testing methods of class CSA::Site.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-16.
##    Updated, 2011-05-17.
##    Updated, 2011-05-23.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Scalar::Util qw( blessed );
use Test::Exception;
use Test::More tests => 51;
use Test::Warn;

use lib "${Bin}/../lib";

use CSA::Site;
use CSA::Residue;


## Test directory t/.
my $t_dir = $Bin;

my $csasite_oo = CSA::Site->new();

## Check attribute methods return empty string by default.
is(
    $csasite_oo->site_number(),
    undef,
    'site_number set to undef by default.', 
);
is(
    $csasite_oo->evidence(),
    undef,
    'evidence set to undef by default.', 
);
is(
    $csasite_oo->literature_entry(),
    undef,
    'literature_entry set to undef by default.', 
);

## Test site_number attribute method.
my @site_numbers = ( '0', '1', '2', '3', 'A', 'A902', '?' );
for my $site_number( @site_numbers ) {
    set_site_number( $site_number );
}

## Test evidence attribute method.
my @evidence_strings 
    = ( 'PSIBLAST', 'LIT', 'LITERATURE', 'RANDOM', '?EXDCE£$' );
for my $evidence ( @evidence_strings ) {
    set_evidence( $csasite_oo, $evidence );
}

## Test literature_entry attribute method.
my @lit_entries = ( '1ileA', '1f7uA', '?cdap', ' ed ', '3cka' );
for my $lit_entry ( @lit_entries ) {
    set_litentry( $lit_entry );
}

## Test residues method.
my $csa_res1 = CSA::Residue->new();
$csa_res1->residue_number( '217' );
$csa_res1->chain_id( 'A' );
my $csa_res2 = CSA::Residue->new();
$csa_res2->residue_number( '333' );
$csa_res2->chain_id( 'B' );
my $csa_res3 = CSA::Residue->new();
$csa_res3->residue_number( '1' );
$csa_res3->chain_id( 'A' );
my @csa_residues = ( $csa_res1, $csa_res2, $csa_res3 );
$csasite_oo = set_csa_residues( $csasite_oo, \@csa_residues );

## Test add_residue method.
my $csa_res4 = CSA::Residue->new();
$csa_res4->residue_number( '76' );
$csa_res4->chain_id( 'A' );
add_csa_residue( $csasite_oo, $csa_res4 );

## Test add_residues method with a residue whose residue_number 
## and chain_id features are not defined.
my $csa_res5 = CSA::Residue->new();
add_wrong_csa_residue( $csasite_oo, $csa_res5 );

## Test get_residue method.
test_get_residue( $csasite_oo );

exit;


######################################################################
## Test set-behaviour of CSA::Site::site_number.
sub set_site_number {
    my $site_number = shift;
 
    my $oo = CSA::Site->new();
    
    if ( $site_number =~ /^\d+$/ ) {
        $oo->site_number( $site_number );
        is(
            $oo->site_number(),
            $site_number,
            'Site number properly set.',
        );
    }
    else {
        warning_is 
            {
                $oo->site_number( $site_number )
            }
            "Warning: site_number not assigned due to wrong format ($site_number).",
            'Testing warning for site_number with wrong format.'
        ;
        is(
            $oo->site_number(),
            undef,
            'Wrong site number not set.',
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Site::evidence.
sub set_evidence {
    my $oo       = shift;
    my $evidence = shift;

    $oo->evidence( $evidence );
    
    is(
        $oo->evidence(),
        $evidence,
        'Evidence properly set.',
    );
}

######################################################################
## Test set-behaviour of CSA::Site::literature_entry.
sub set_litentry {
    my $lit_entry = shift;
    
    my $oo = CSA::Site->new();

    if ( $lit_entry =~ /^\w{4,5}?$/ ) {
        $oo->literature_entry( $lit_entry );
        is(
            $oo->literature_entry(),
            $lit_entry,
            'Literature entry properly set.',
        );
    }
    else {
        warning_is
            {
            	$oo->literature_entry( $lit_entry )
            }
            "Warning: literature_entry not assigned due to wrong format ($lit_entry).",
            'Testing warning for literature_entry with wrong format.'
        ;
        is(
            $oo->literature_entry(),
            undef,
            'Wrong literature_entry not set.',
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Site::residues.
sub set_csa_residues {
    my $oo                = shift;
    my $csa_residues_aref = shift;
    
    $oo->residues( $csa_residues_aref );
    
    ## Check what is stored in residues() is an array ref.
    is( 
        ref($oo->residues()),
        'ARRAY',
        'CSA::Site::residues returns an array ref.',
    );
    
    ## Check there are three elements in residues() array ref.
    is(
        scalar @{ $oo->residues() },
        3,
        'CSA::Site::residues contains 3 elements.',
    );
    
    ## Check elements stored in the array ref are CSA::Residue 
    ## compliant.
    residues_elements( $oo );
    
    return $oo;
}

#####################################################################
## Test set-behaviour of CSA::Site::add_residue method.
sub add_csa_residue {
    my $oo      = shift;
    my $csa_res = shift;
    
    my $is_added = $oo->add_residue( $csa_res );
    
    ## Check CSA::Site::add_residue returns expected value.
    is( 
        $is_added, 
        1, 
        "CSA::Site::add_residue returns 1 on adding residue.", 
    );
    
    ## Check residue was properly added by checking CSA::Site::residues.
    is( 
        ref($oo->residues()),
        'ARRAY',
        "CSA::Site::residues still returns aref after adding residue.",
    );
    is(
        scalar @{ $oo->residues() },
        4,
        "CSA::Site::residues contains 4 elements after adding one.",
    );
    
    ## Check elements stored in array ref in CSA::Site::residues are 
    ## CSA::Residue compliant objects.
    residues_elements( $oo );
}


#####################################################################
## Test set-behaviour of CSA::Site::add_residue method when added 
## residue has no defined Residue Number and/or Chain ID.
sub add_wrong_csa_residue {
    my $oo      = shift;
    my $csa_res = shift;
    
    dies_ok 
        { $oo->add_residue( $csa_res ) } 
        'Dies when adding Res with no Res Number and Chain ID.'
    ;
    
    ## Check residue was not added by checking CSA::Site::residues.
    is( 
        ref($oo->residues()),
        'ARRAY',
        'CSA::Site::residues still returns aref after not adding ' 
        . 'residue.',
    );
    is(
        scalar @{ $oo->residues() },
        4,
        "CSA::Site::residues contains 4 elements after adding one.",
    );
    
    ## Check elements stored in array ref in CSA::Site::residues are 
    ## CSA::Residue compliant objects.
    residues_elements( $oo );
}

#####################################################################
## Check that elements that are stored in CSA::Site->residues are 
## CSA::Residue compliant.
sub residues_elements {
    my $oo = shift;
    
    for my $residue ( @{ $oo->residues() } ) {
        ok(
            $residue->isa( 'CSA::Residue' ),
            'Object in CSA::Site->residues is CSA::Residue compliant.',
        );
    }
}

#####################################################################
## Test get_residue method with different residue IDs.
sub test_get_residue {
    my $oo = shift;

    ## Residue that was added to the site.
    my $res1 = $oo->get_residue( '217A' );
    ok( 
        defined $res1,
        'Residue with ID 217A is in site.',
    );
    is(
        blessed $res1,
        'CSA::Residue',
        'Residue 217A is a blessed reference from CSA::Residue',
    );
    ok(
        $res1->isa( 'CSA::Residue' ),
        'Residue 217A is CSA::Residue compliant.',
    );

    ## Residue that was added to the site.
    my $res2 = $oo->get_residue( '333B' );
    ok( 
        defined $res2,
        'Residue with ID 333B is in site.',
    );
    is(
        blessed $res2,
        'CSA::Residue',
        'Residue 333B is a blessed reference from CSA::Residue',
    );
    ok(
        $res2->isa( 'CSA::Residue' ),
        'Residue 333B is CSA::Residue compliant.',
    );

    ## Residue that was not added to the site.
    my $res3 = $oo->get_residue( '592C' );
    ok(
        ! defined $res3,
        'Residue 592C is not in site.',
    );
}
