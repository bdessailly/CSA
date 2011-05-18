#!/usr/bin/env perl

######################################################################
##
##    Testing methods of class CSA::Site.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-16.
##    Updated, 2011-05-17.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Test::More tests => 37;
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
    '',
    'site_number set to empty space by default.', 
);
is(
    $csasite_oo->evidence(),
    '',
    'evidence set to empty space by default.', 
);
is(
    $csasite_oo->literature_entry(),
    '',
    'literature_entry set to empty space by default.', 
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
my $csa_res2 = CSA::Residue->new();
my $csa_res3 = CSA::Residue->new();
my @csa_residues = ( $csa_res1, $csa_res2, $csa_res3 );
$csasite_oo = set_csa_residues( $csasite_oo, \@csa_residues );

## Test add_residue method.
my $csa_res4 = CSA::Residue->new();
add_csa_residue( $csasite_oo, $csa_res4 );

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
            '',
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
            '',
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