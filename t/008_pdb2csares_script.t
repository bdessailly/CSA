#!/usr/bin/env perl

######################################################################
##
##    Testing script pdb_to_csares from class CSA.
##
##    Created by Benoit H Dessailly, 2011-05-23.
##    Updated, 2011-05-23.
##    Updated, 2011-05-24.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use IO::File;
use Test::More tests => 163;

use lib "${Bin}/../lib";

## Test directory t/.
my $t_dir = $Bin;

## Script directory.
my $script_dir = File::Spec->catfile( $t_dir, '..', 'script' );
my $script = File::Spec->catfile( $script_dir, 'pdb_to_csares' );

## CSA dataset file.
my $f_csa = File::Spec->catfile( $t_dir, 'data', 'csa_2_2_12_subset3.dat', );

## Tests.
test_pdblist1( $t_dir, $script_dir, $f_csa );
test_pdblist2( $t_dir, $script_dir, $f_csa );
test_pdblist3( $t_dir, $script_dir, $f_csa );
test_pdblist3_redundant( $t_dir, $script_dir, $f_csa );

exit;

######################################################################
## Test first list of PDB IDs that all have only standard residues.
sub test_pdblist1 {
    my $t_dir      = shift;
    my $script_dir = shift;
    my $f_csa      = shift;

    ## Input file with list of PDB IDs.
    my $f_pdblist = File::Spec->catfile( $t_dir, 'data', 'pdblist1.dat' );

    ## Output file name.
    my $f_out = File::Spec->catfile( $t_dir, 'data', 'pdb_to_csares1.dat', );

    ## Run script.
    system $script, '-i', $f_pdblist, '-d', $f_csa, '-o', $f_out;

    ## Check contents of output file.
    my $fh_check = IO::File->new( $f_out, '<' );
    my $cnt_lines = 0;
    my %pdb_csares;
    while ( my $line = $fh_check->getline ) {
        $cnt_lines++;
        chomp( my ( $pdbid, $res ) = split /\s+/, $line );

        $pdb_csares{$pdbid}{$res} = 1;
    }

    ## Declare expected contents of pdb_to_csares output file.
    my %data = (
        '1ile' => {
            'CSA'   => [ '51A',  '54A', '57A', '591A', '594A', ],
            'NOCSA' => [ '123B', '55A', '890A', ],
        },
        '1a2p' => {
            'CSA' => [
                '102A', '83A', '73A',
                '102B', '83B', '73B',
                '102C', '83C', '73C',

            ],
            'NOCSA' => [ '79A', '82A', '89B', '38B', 'B83', ],
        },
    );

    ## Check contents of pdb_to_csares output file.
    is( $cnt_lines, 14, '14 lines in output of pdb_to_csares.', );
    is(
        scalar keys %pdb_csares,
        scalar keys %data,
        ( scalar keys %data ) . ' pdb entries from input file have CSA res.',
    );

    for my $pdbid ( keys %data ) {
        ok( exists $pdb_csares{$pdbid}, "Entry $pdbid has CSA residues.", );
        is(
            scalar @{ $data{$pdbid}{'CSA'} },
            scalar keys %{ $pdb_csares{$pdbid} },
            "Entry $pdbid has correct number of CSA residues.",
        );
        for my $csares ( @{ $data{$pdbid}{'CSA'} } ) {
            ok(
                exists $pdb_csares{$pdbid}{$csares},
                "Entry $pdbid has CSA res $csares.",
            );
        }
        for my $nocsares ( @{ $data{$pdbid}{'NOCSA'} } ) {
            ok(
                !exists $pdb_csares{$pdbid}{$nocsares},
                "Entry $pdbid hasn't got res $nocsares.",
            );
        }
    }

    unlink $f_out or die "Cannot unlink $f_out: $!";
}


######################################################################
## Test second list of PDB IDs with an entry that has non-standard
## CSA residues.
sub test_pdblist2 {
    my $t_dir      = shift;
    my $script_dir = shift;
    my $f_csa      = shift;

    ## Input file with list of PDB IDs.
    my $f_pdblist = File::Spec->catfile( $t_dir, 'data', 'pdblist2.dat' );

    ## Output file name.
    my $f_out = File::Spec->catfile( $t_dir, 'data', 'pdb_to_csares2.dat', );

    ## Run script.
    system $script, '-i', $f_pdblist, '-d', $f_csa, '-o', $f_out, '-p';

    ## Check contents of output file.
    my $fh_check = IO::File->new( $f_out, '<' );
    my $cnt_lines = 0;
    my %pdb_csares;
    while ( my $line = $fh_check->getline ) {
        $cnt_lines++;
        chomp( my ( $pdbid, $res ) = split /\s+/, $line );

        $pdb_csares{$pdbid}{$res} = 1;
    }

    ## Declare expected contents of pdb_to_csares output file.
    my %data = (
        '1ile' => {
            'CSA'   => [ '51A',  '54A', '57A', '591A', '594A', ],
            'NOCSA' => [ '123B', '55A', '890A', ],
        },
        '1aa6' => {
            'CSA' => [ '141A', '44A', '333A', '132A', ],
            'NOCSA' => [ '79A', '140A', '802', '333', '30A', ],
        },
    );

    ## Check contents of pdb_to_csares output file.
    is( 
        $cnt_lines, 
        9, 
        '9 lines in output of pdb_to_csares (input file 2).', 
    );
    is(
        scalar keys %pdb_csares,
        scalar keys %data,
        ( scalar keys %data ) 
        . ' pdb entries from input file have CSA res.',
    );

    for my $pdbid ( keys %data ) {
        ok( exists $pdb_csares{$pdbid}, "Entry $pdbid has CSA residues.", );
        is(
            scalar keys %{ $pdb_csares{$pdbid} },
            scalar @{ $data{$pdbid}{'CSA'} },
            "Entry $pdbid has correct number of CSA residues.",
        );
        for my $csares ( @{ $data{$pdbid}{'CSA'} } ) {
            ok(
                exists $pdb_csares{$pdbid}{$csares},
                "Entry $pdbid has CSA res $csares.",
            );
        }
        for my $nocsares ( @{ $data{$pdbid}{'NOCSA'} } ) {
            ok(
                !exists $pdb_csares{$pdbid}{$nocsares},
                "Entry $pdbid hasn't got res $nocsares.",
            );
        }
    }

    unlink $f_out or die "Cannot unlink $f_out: $!";
}

######################################################################
## Test third list of pdb ids that contains an entry with redundant 
## CSA residues.
sub test_pdblist3 {
    my $t_dir      = shift;
    my $script_dir = shift;
    my $f_csa      = shift;
    
    ## Input file with list of PDB IDs.
    my $f_pdblist = File::Spec->catfile( $t_dir, 'data', 'pdblist3.dat' );

    ## Output file name.
    my $f_out = File::Spec->catfile( $t_dir, 'data', 'pdb_to_csares3.dat', );

    ## Run script.
    system $script, '-i', $f_pdblist, '-d', $f_csa, '-o', $f_out, '-p';

    ## Check contents of output file.
    my $fh_check = IO::File->new( $f_out, '<' );
    my $cnt_lines = 0;
    my %pdb_csares;
    while ( my $line = $fh_check->getline ) {
        $cnt_lines++;
        chomp( my ( $pdbid, $res ) = split /\s+/, $line );

        $pdb_csares{$pdbid}{$res}++;
    }

    ## Declare expected contents of pdb_to_csares output file.
    my %data = (
        '4ts1' => {
            'CSA'   => [ 
                '82A', '86A', '230A', '233A', 
                '82B', '86B', '230B', '233B', 
            ],
            'NOCSA' => [ '83A', '85A', '86C', 'B86', '23A3', '' ],
        },
        '3fi0' => {
            'CSA' => [ 
                '195A', '195B', '195C', '195D', '195E', '195F', 
                '195G', '195H', '195I', '195J', '195K', '195L', 
                '195M', '195N', '195O', '195P', '195Q', '195R', 
             ],
            'NOCSA' => [ '79A', '140A', '802', '333', '30A', ],
        },
    );

    ## Check contents of pdb_to_csares output file.
    is( 
        $cnt_lines, 
        26, 
        '26 lines in output of pdb_to_csares (input file 3).', 
    );
    is(
        scalar keys %data,
        scalar keys %pdb_csares,
        ( scalar keys %data ) 
        . ' pdb entries from input file have CSA res.',
    );

    for my $pdbid ( keys %data ) {
        ok( exists $pdb_csares{$pdbid}, "Entry $pdbid has CSA residues.", );
        is(
            scalar keys %{ $pdb_csares{$pdbid} },
            scalar @{ $data{$pdbid}{'CSA'} },
            "Entry $pdbid has correct number of CSA residues.",
        );
        for my $csares ( @{ $data{$pdbid}{'CSA'} } ) {
            ok(
                exists $pdb_csares{$pdbid}{$csares},
                "Entry $pdbid has CSA res $csares.",
            );
        }
        for my $nocsares ( @{ $data{$pdbid}{'NOCSA'} } ) {
            ok(
                !exists $pdb_csares{$pdbid}{$nocsares},
                "Entry $pdbid hasn't got res $nocsares.",
            );
        }
    }

    unlink $f_out or die "Cannot unlink $f_out: $!";
}

######################################################################
## Test third list of pdb ids that contains an entry with redundant 
## CSA residues and allow redundancy.
sub test_pdblist3_redundant {
    my $t_dir      = shift;
    my $script_dir = shift;
    my $f_csa      = shift;
    
    ## Input file with list of PDB IDs.
    my $f_pdblist = File::Spec->catfile( $t_dir, 'data', 'pdblist3.dat' );

    ## Output file name.
    my $f_out = File::Spec->catfile( $t_dir, 'data', 'pdb_to_csares3_red.dat', );

    ## Run script.
    system $script, '-i', $f_pdblist, '-d', $f_csa, '-o', $f_out, '-p', '-r';

    ## Check contents of output file.
    my $fh_check = IO::File->new( $f_out, '<' );
    my $cnt_lines = 0;
    my %pdb_csares;
    while ( my $line = $fh_check->getline ) {
        $cnt_lines++;
        chomp( my ( $pdbid, $res ) = split /\s+/, $line );

        $pdb_csares{$pdbid}{$res}++;
    }

    ## Declare expected contents of pdb_to_csares output file.
    my %data = (
        '4ts1' => {
            'CSA'   => { 
                '82A' => 1, '86A' => 1, '230A' => 2, '233A' => 2, 
                '82B' => 1, '86B' => 1, '230B' => 2, '233B' => 2, 
            },
            'NOCSA' => {
            	'83A' => 1, '85A'  => 1, '86C' => 1, 
            	'B86' => 1, '23A3' => 1, ''    => 1,
            },
        },
        '3fi0' => {
            'CSA' => { 
                '195A' => 1, '195B' => 1, '195C' => 1, '195D' => 1, 
                '195E' => 1, '195F' => 1, '195G' => 1, '195H' => 1, 
                '195I' => 1, '195J' => 1, '195K' => 1, '195L' => 1, 
                '195M' => 1, '195N' => 1, '195O' => 1, '195P' => 1, 
                '195Q' => 1, '195R' => 1, 
            },
            'NOCSA' => { 
            	'79A' => 1, '140A' => 1, '802' => 1, 
            	'333' => 1, '30A' => 1, 
            },
        },
    );

    ## Check contents of pdb_to_csares output file.
    is( 
        $cnt_lines, 
        30, 
        '30 lines in output of pdb_to_csares ' .
        '(input file 3, redundancy).', 
    );
    is(
        scalar keys %data,
        scalar keys %pdb_csares,
        ( scalar keys %data ) 
        . ' pdb entries from input file have CSA res.',
    );

    for my $pdbid ( keys %data ) {
        ok( exists $pdb_csares{$pdbid}, "Entry $pdbid has CSA residues.", );
        is(
            scalar keys %{ $pdb_csares{$pdbid} },
            scalar keys %{ $data{$pdbid}{'CSA'} },
            "Entry $pdbid has correct number of CSA residues.",
        );
        for my $csares ( keys %{ $data{$pdbid}{'CSA'} } ) {
            ok(
                exists $pdb_csares{$pdbid}{$csares},
                "Entry $pdbid has CSA res $csares.",
            );
            is(
                $pdb_csares{$pdbid}{$csares},
                $data{$pdbid}{'CSA'}{$csares},
                "Correct n-occ for $pdbid, $csares.",
            );
        }
        for my $nocsares ( keys %{ $data{$pdbid}{'NOCSA'} } ) {
            ok(
                !exists $pdb_csares{$pdbid}{$nocsares},
                "Entry $pdbid hasn't got res $nocsares.",
            );
        }
    }

    unlink $f_out or die "Cannot unlink $f_out: $!";
}