#!/usr/bin/env perl

######################################################################
##
##    Testing read method of class CSA::IO.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use File::Spec;
use FindBin qw( $Bin );
use Test::More tests => 1;

use lib "${Bin}/../lib";

use CSA;
use CSA::Entry;
use CSA::IO;


## Test directory t/.
my $t_dir = $Bin;
my $f_csa 
    = File::Spec->catfile( $t_dir, 'data', 'csa_2_2_12_subset.dat' );

my $csa_io = CSA::IO->new();
my $csa = $csa_io->read( csa_file => $f_csa );

## Check that CSA object properly created by CSA::IO->read.
ok(
    $csa->isa( 'CSA' ),
    'Object returned by CSA::IO->read is CSA compliant.',
);

## Check number of entries in dataset.
is(
    scalar @{ $csa->entries() },
    12,
    'Correct number of entries in dataset.',
);

## Check properties of entries in dataset.
my @pdb_ids;
for my $csa_entry ( @{ $csa->entries } ) {
    push( @pdb_ids, $csa_entry->pdb_id );
}
is( 
    join( ',', sort @pdb_ids ),
    '102l,103l,104l,107l,108l,109l,10gs,10mh,110l,11as,12as,1a20',
    'Correct list of pdb ids in dataset.',
);

## Check contents of CSA entries.
for my $csa_entry ( @{ $csa->entries } ) {
    if ( $csa_entry->pdb_id eq '102l' ) {
        is(
            scalar @{ $csa_entry->sites() },
            1,
            'Correct number of sites in entry 102l.',
        );
    }
    if ( $csa_entry->pdb_id eq '104l' ) {
        is(
            scalar @{ $csa_entry->sites() },
            2,
            'Correct number of sites in entry 104l.',
        );
        
        for my $csa_site ( @{ $csa_entry->sites } ) {
            if ( $csa_site eq '0' ) {
                is(
                    $csa_site->evidence,
                    'PSIBLAST',
                    'Correct evidence for site 0 of entry 104l.',
                );
                
                is(
                    scalar @{ $csa_site->residues },
                    2,
                    'Correct number of residues in site 0 of entry 104l.',
                );
            
                for my $csa_res ( @{ $csa_site->residues } ) {
                    if ( $csa_res->residue_number eq '11' ) {
                        is(
                            $csa_res->chemical_function,
                            'S',
                            'Correct chemical function for CSA residue.',
                        );
                        is(
                            $csa_res->chain_id,
                            'A',
                            'Correct chain ID for CSA residue.',
                        );
                        is(
                            $csa_res->residue_type,
                            'GLU',
                            'Correct residue type for CSA residue.',
                        );
                    }
                }
            }
        }
    }
}

exit;


######################################################################
## Subroutine xxx description...
sub xxx {
    my $arg = shift;
}
