#!/usr/bin/env perl

######################################################################
##
##    Testing script pdb_to_csares from class CSA.
##
##    Created by Benoit H Dessailly, 2011-05-23.
##    Updated, 2011-05-23.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use IO::File;
use Test::More tests => 51;

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
        10, 
        '10 lines in output of pdb_to_csares (input file 2).', 
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
