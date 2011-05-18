#!/usr/bin/env perl

######################################################################
##
##    Testing CSA::IO->read with restrictions on PDB IDs.
##
##    Created by Benoit H Dessailly, 2011-05-18.
##    Updated, 2011-05-18.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use FindBin qw( $Bin );
use Switch;
use Test::More tests => 9;

use lib "${Bin}/../lib";

use CSA::IO;

## Test directory t/.
my $t_dir = $Bin;

my $f_csa = File::Spec->catfile( $t_dir, 'data', 'csa_2_2_12_subset.dat' );
my $fh_csa = IO::File->new( $f_csa, '<' );

my %pdb_ids = ( '107l' => 1, '1a20' => 1 );

my $csa_io = CSA::IO->new();
my $csa = $csa_io->read( csa_filehandle => $fh_csa, pdb_ids => \%pdb_ids );

## Check contents of $csa object.
check_csa_contents($csa);

exit;

######################################################################
## Check contents of newly-created CSA dataset object.
sub check_csa_contents {
    my $csa = shift;

    ## count number of entries.
    is( 
        scalar @{ $csa->entries }, 2, 
        'Correct number of entries.', 
    );

    for my $csa_entry ( @{ $csa->entries } ) {
        switch ( $csa_entry->pdb_id ) {
            case '107l' {
                check_entry_107l($csa_entry);
            }
            case '1a20' {
                check_entry_1a20($csa_entry);
            }
        }
    }
}

######################################################################
## Check recorded contents of CSA entry 107l.
sub check_entry_107l {
    my $csa_entry = shift;

    ## count number of sites.
    is( 
        scalar @{ $csa_entry->sites }, 1, 
        'Correct number of sites in 107l.', 
    );
    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is( $csa_site->evidence, 'PSIBLAST', 'Correct evidence.', );
                is( $csa_site->literature_entry, '206lA',
                    'Correct literature entry.',
                );
                is(
                    scalar @{ $csa_site->residues },
                    2, 'Correct number of residues.',
                );
            }
        }
    }

}

######################################################################
## Check recorded contents of CSA entry 1a20.
sub check_entry_1a20 {
    my $csa_entry = shift;

    ## count number of sites.
    is( 
        scalar @{ $csa_entry->sites }, 1, 
        'Correct number of sites.', 
    );
    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is( $csa_site->evidence, 'PSIBLAST', 'Correct evidence.', );
                is( $csa_site->literature_entry, '1apxA',
                    'Correct literature entry.',
                );
                is(
                    scalar @{ $csa_site->residues },
                    3, 'Correct number of residues.',
                );
            }
        }
    }
}
