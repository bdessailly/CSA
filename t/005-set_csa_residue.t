#!/usr/bin/env perl

######################################################################
##
##    Testing methods of class CSA::Residue.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-17.
##    Updated, 2011-05-23.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Test::More tests => 52;
use Test::Warn;

use lib "${Bin}/../lib";

use CSA::Residue;


## Test directory t/.
my $t_dir = $Bin;

my $csares_oo = CSA::Residue->new();

## Check attribute methods return undef by default.
is(
    $csares_oo->residue_type(),
    undef,
    'residue_type set to empty space by default.', 
);
is(
    $csares_oo->chain_id(),
    undef,
    'chain_id set to empty space by default.', 
);
is(
    $csares_oo->residue_number(),
    undef,
    'residue_number set to empty space by default.', 
);
is(
    $csares_oo->chemical_function(),
    undef,
    'chemical_function set to empty space by default.', 
);

## Test residue_type attribute method.
my @res_types = ( 'RES', 'THR', 'ASP', 'PRO', 'A', 'ZN', '?', '' );
for my $res_type ( @res_types ) {
    set_res_type( $res_type );
}

## Test chain_id attribute method.
my @chain_ids = ( 'A', 'B', 'Z', '0', '1', 'POEKD', '?', '' );
for my $chid ( @chain_ids ) {
    set_chain_id( $chid );
}

## Test residue_number attribute method.
my @res_nums 
    = ( '1234', '34', '94', '0', '-63', '33-', 'POEKD', '?', '', '35A' );
for my $res_num ( @res_nums ) {
    set_res_num( $res_num );
}

## Test chemical_function attribute method.
my @chem_funs 
    = ( 'N', 'O', 'NO', 'S', 'SN', 'SNO', 'SO', 'X', '?', '35A', '23', 'S*' );
for my $chem_fun ( @chem_funs ) {
    set_chem_fun( $chem_fun );
}

exit;

######################################################################
## Test set-behaviour of CSA::Residue::residue_type.
sub set_res_type {
    my $res_type = shift;
 
    my $oo = CSA::Residue->new();

    if ( $res_type =~ /^\w+$/ ) {
        $oo->residue_type( $res_type );
        is(
            $oo->residue_type(),
            $res_type,
            'Residue type properly set.',
        );
    }
    else {
        warning_is 
            {
                $oo->residue_type( $res_type )
            }
            "Warning: residue_type not assigned due to wrong format ($res_type).",
            'Testing warning for residue_type with wrong format.'
        ;
        is(
            $oo->residue_type(),
            undef,
            'Wrong residue type not set.',
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Residue::chain_id.
sub set_chain_id {
    my $chid = shift;
 
    my $oo = CSA::Residue->new();

    if ( $chid =~ /^\w*$/ ) {
        $oo->chain_id( $chid );
        is(
            $oo->chain_id(),
            $chid,
            'Chain ID properly set.',
        );
    }
    else {
        warning_is 
            {
                $oo->chain_id( $chid )
            }
            "Warning: chain_id not assigned due to wrong format ($chid).",
            'Testing warning for chain_id with wrong format.'
        ;
        is(
            $oo->chain_id(),
            undef,
            'Wrong chain_id not set.',
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Residue::residue_number.
sub set_res_num {
    my $res_num = shift;
 
    my $oo = CSA::Residue->new();

    if ( $res_num =~ /^-*\d+$/ ) {
        $oo->residue_number( $res_num );
        is(
            $oo->residue_number(),
            $res_num,
            'Residue number properly set.',
        );
    }
    else {
        warning_is 
            {
                $oo->residue_number( $res_num )
            }
            "Warning: residue_number not assigned due to wrong format ($res_num).",
            'Testing warning for residue_number with wrong format.'
        ;
        is(
            $oo->residue_number(),
            undef,
            'Wrong residue_number not set.',
        );
    }
}

######################################################################
## Test set-behaviour of CSA::Residue::chemical_function.
sub set_chem_fun {
    my $chem_fun = shift;
 
    my $oo = CSA::Residue->new();

    if ( $chem_fun =~ /^\w+$/ ) {
        $oo->chemical_function( $chem_fun );
        is(
            $oo->chemical_function(),
            $chem_fun,
            'Chemical function properly set.',
        );
    }
    else {
        warning_is 
            {
                $oo->chemical_function( $chem_fun )
            }
            "Warning: chemical_function not assigned due to wrong format ($chem_fun).",
            'Testing warning for chemical_function with wrong format.'
        ;
        is(
            $oo->chemical_function(),
            undef,
            'Wrong chemical_function not set.',
        );
    }
}
