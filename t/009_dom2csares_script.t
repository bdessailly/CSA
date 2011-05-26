#!/usr/bin/env perl

######################################################################
##
##    Testing script dom_to_csares from module CSA.
##
##    Created by Benoit H Dessailly, 2011-05-25.
##    Updated, 2011-05-25.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use File::Spec;
use FindBin qw( $Bin );
use IO::File;
use Test::More tests => 49;

use lib "${Bin}/../lib";

## Test directory t/.
my $t_dir = $Bin;

## Script directory.
my $script_dir = File::Spec->catfile( $t_dir, '..', 'script' );
my $script = File::Spec->catfile( $script_dir, 'dom_to_csares' );

## CSA dataset file.
my $f_csa = File::Spec->catfile( $t_dir, 'data', 'csa_2_2_12_subset4.dat', );

## Tests.
test_dom_to_csares( $t_dir, $script, $f_csa );

exit;

######################################################################
## Test script dom_to_csares with test data.
sub test_dom_to_csares {
    my $t_dir  = shift;
    my $script = shift;
    my $f_csa  = shift;

    ## Input file with list of Domain IDs and their boundaries.
    my $f_domlist =
      File::Spec->catfile( $t_dir, 'data', 'dom_boundaries.dat', );

    ## Output file.
    my $f_domcsa = File::Spec->catfile( $t_dir, 'data', 'dom_csares.dat', );

    ## Run script.
    system $script, '-i', $f_domlist, '-d', $f_csa, '-o', $f_domcsa;

    ## Read output file.
    my %obs_dom_csares;
    my $fh_domcsa = IO::File->new( $f_domcsa, '<' );
    while ( my $line = $fh_domcsa->getline() ) {

        ## make sure line has expected format.
        ok(
            $line =~ /^(\S{7})\t(\S+)$/,
            'Line has correct format in output file.',
        );

        ## save data.
        chomp( my ( $domid, $csares ) = split /\t/, $line );
        $obs_dom_csares{$domid}{$csares}++;
    }
    $fh_domcsa->close();

    ## Set expected returned results.
    my %exp_dom_csares = (
        '1a8hA01' => {
            '16A'  => 1,
            '19A'  => 1,
            '22A'  => 1,
            '297A' => 1,
            '300A' => 1,
        },
        '1b6tA00' => {
            '129A' => 1,
            '18A'  => 1,
            '91A'  => 1,
        },
        '1b6tB00' => {
            '18B'  => 1,
            '91B'  => 1,
            '129B' => 1,
        },
        '1bs2A01' => {
            '156A' => 1,
            '159A' => 1,
            '162A' => 1,
        },
        '1ct9A02' => {
            '430A' => 1,
        },
        '1ct9B02' => {
            '430B' => 1,	
        },
        '1ct9C02' => {
            '430C' => 1,    
        },
        '1ct9D02' => {
            '430D' => 1,    
        },
        '1euqA05' => {
            '34A'  => 1,
        }
    );

    ## Check contents of output file.
    is(
        scalar keys %obs_dom_csares,
        9,
        'Correct number of domids in output file.',
    );
    
    my $obs_res_cnt_total = 0;
    while( my( $domid, $resid_href ) = each %exp_dom_csares ) {
        
        ## 9 expected domain IDs should be in output file.
        ok(
            exists $obs_dom_csares{ $domid },
            "Domain $domid found in output file.",
        );
        
        while( my( $resid, undef ) = each %{ $resid_href } ) {
            
            ## and all their residues should be in file too.
            ok(
                exists $obs_dom_csares{ $domid }{ $resid },
                "Residue $resid ($domid) is in output file.",
            );
            
            $obs_res_cnt_total++;
        }
    }
    
    ## Check total number of CSA residues in output file.
    is(
        $obs_res_cnt_total,
        19,
        'Found expected number of residues in output file.',
    );

    unlink $f_domcsa or die "Cannot unlink $f_domcsa: $!";
}
