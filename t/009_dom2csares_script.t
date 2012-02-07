#!/usr/bin/env perl

######################################################################
##
##    Testing script dom_to_csares from module CSA.
##
##    Created by Benoit H Dessailly, 2011-05-25.
##    Updated, 2011-05-25.
##    Updated, 2012-02-07.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use File::Spec;
use FindBin qw( $Bin );
use IO::File;
use Test::More tests => 50;

use lib "${Bin}/../lib";

## Test directory t/.
my $t_dir = $Bin;

## Root test data directory t/data.
my $d_data = File::Spec->catfile( $t_dir, 'data' );

## Script directory.
my $script = File::Spec->catfile( 
    $t_dir, '..', 'script', 'dom_to_csares' 
);

## CSA dataset file.
my $f_csa = File::Spec->catfile( $d_data, 'csa_2_2_12_subset4.dat', );

## Tests.
test_dom_to_csares( $t_dir, $script, $f_csa );

## Test option to pass file with equivalent PDB chains (option -e).
test_equivalent_pdbchains( $script, $d_data );

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

#####################################################################
## Test option -e of script dom_to_csares. Option -e is used to pass 
## a file with a list of equivalent PDB chains for each query domain 
## in the input file. 
sub test_equivalent_pdbchains {
    my $script = shift;
    my $d_data = shift;
    
    ## Input file with list of domain IDs.
    my $f_domids = File::Spec->catfile( 
        $d_data, 'set2', 'domid_boundaries.dat',
    );
    
    ## Input file with equivalent PDB chains.
    my $f_equiv = File::Spec->catfile(
        $d_data, 'set2', 'domid_pdbchains.dat',
    );
    
    ## CSA dataset file.
    my $f_csa = File::Spec->catfile(
        $d_data, 'set2', 'csa_2_2_12_subset.dat',
    );
    
    ## Observed output file.
    my $f_out_obs = File::Spec->catfile(
        $d_data, 'set2', 'obs-dom_csares.dat',
    );
    
    ## Run script.
    system $script, '-i', $f_domids, '-d', $f_csa, 
                    '-e', $f_equiv,  '-o', $f_out_obs, 
                    '-l';
    
    ## Expected output file.
    my $f_out_exp = File::Spec->catfile(
        $d_data, 'set2', 'exp-dom_csares.dat',
    );
    
    ## Read contents of observed output file.
    my $obs_out_str = '';
    my $fh_out_obs = IO::File->new( $f_out_obs, '<' );
    while ( my $line = $fh_out_obs->getline ) {
        $obs_out_str .= $line;
    }
    $fh_out_obs->close;
    
    ## Read contents of expected output file.
    my $exp_out_str = '';
    my $fh_out_exp = IO::File->new( $f_out_exp, '<' );
    while ( my $line = $fh_out_exp->getline ) {
        $exp_out_str .= $line;
    }
    $fh_out_exp->close;
    
    ## Compare contents of observed and expected output files.
    is(
        $obs_out_str,
        $exp_out_str,
        'Output as expected with dom_to_csares and option -e.',
    );
    
    ## Delete observed output file.
    unlink $f_out_obs or die "Cannot unlink $f_out_obs: $!";
}