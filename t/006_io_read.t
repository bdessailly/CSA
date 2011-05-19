#!/usr/bin/env perl

######################################################################
##
##    Testing read method of class CSA::IO.
##
##    Created by Benoit H Dessailly, 2011-05-13.
##    Updated, 2011-05-13.
##    Updated, 2011-05-17.
##    Updated, 2011-05-18.
##    Updated, 2011-05-19.
##
######################################################################

use strict;
use warnings;

use File::Basename;
use File::Spec;
use FindBin qw( $Bin );
use IO::File;
use Test::More tests => 43;

use Switch;

use lib "${Bin}/../lib";

use CSA::IO;

## Test directory t/.
my $t_dir = $Bin;

check_first_dataset( 'csa_2_2_12_subset.dat' );

check_second_dataset( 'csa_2_2_12_subset2.dat' );

exit;


######################################################################
## Check results for first dataset file.
sub check_first_dataset {
    my $f_csa_basename = shift;

    my $f_csa = File::Spec->catfile( $t_dir, 'data', $f_csa_basename );
    my $fh_csa = IO::File->new( $f_csa, '<' );

    my $csa_io = CSA::IO->new();
    my $csa = $csa_io->read( csa_filehandle => $fh_csa );

    my $cnt_entries  = 12;
    my $pdbids 
      = '102l,103l,104l,107l,108l,109l,10gs,10mh,110l,11as,12as,1a20';

    ## Check basic properties of newly created CSA dataset object.
    check_csa_basics( $csa, $cnt_entries, $pdbids );

    ## Check contents of CSA entries.
    check_csa_contents($csa);
}

######################################################################
## Check results for second dataset file.
sub check_second_dataset {
    my $f_csa_basename = shift;

    my $f_csa = File::Spec->catfile( $t_dir, 'data', $f_csa_basename );
    my $fh_csa = IO::File->new( $f_csa, '<' );
    
    my $csa_io = CSA::IO->new();
    my $csa = $csa_io->read( csa_filehandle => $fh_csa );
    
    my $cnt_entries  = 3;
    my $pdbids = '9rub,9xia,9xim';
    
    ## Check CSA dataset properties.
    check_csa_basics( $csa, $cnt_entries, $pdbids );

    ## Check contents of CSA entries.
    check_csa_contents($csa);
}

######################################################################
## Check basic properties of newly created CSA dataset object, i.e.
## the number of entries in the dataset and the pdb ids of these
## entries.
sub check_csa_basics {
    my $csa         = shift;
    my $cnt_entries = shift;
    my $pdbids      = shift;

    ## Check that CSA object properly created by CSA::IO->read.
    ok( 
        $csa->isa('CSA'), 
        'Object returned by CSA::IO->read is CSA compliant.',
    );

    ## Check number of entries in dataset.
    is(
        scalar @{ $csa->entries }, $cnt_entries, 
        'Correct number of entries in dataset.',
    );

    ## Check properties of entries in dataset.
    my @pdb_ids;
    for my $csa_entry ( @{ $csa->entries } ) {
        push( @pdb_ids, $csa_entry->pdb_id );
    }
    is(
        join( ',', sort @pdb_ids ),
        $pdbids,
        'Correct list of pdb ids in dataset.',
    );
}

######################################################################
## Check contents of newly created CSA dataset object in detail.
sub check_csa_contents {
    my $csa = shift;

    for my $csa_entry ( @{ $csa->entries } ) {

        switch ( $csa_entry->pdb_id ) {
            case '102l' { check_entry_102l($csa_entry) }
            case '104l' { check_entry_104l($csa_entry) }
            case '12as' { check_entry_12as($csa_entry) }
            case '9rub' { check_entry_9rub($csa_entry) }
            case '9xim' { check_entry_9xim($csa_entry) }
        }
    }
}

######################################################################
## Check contents of CSA entry 102l.
sub check_entry_102l {
    my $csa_entry = shift;

    is(
        scalar @{ $csa_entry->sites }, 1, 
        'Correct #sites in entry 102l.',
    );
    
    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 102l, site 0.',
                );
                is(
                    scalar @{ $csa_site->residues }, 2,
                    'Correct #residues for 102l, site 0.',
                );
                is(
                    $csa_site->literature_entry, '206lA',
                    'Correct literature entry for 102l, site 0.',
                );
            }
        }
    }
}

######################################################################
## Check contents of CSA entry 104l.
sub check_entry_104l {
    my $csa_entry = shift;

    is(
        scalar @{ $csa_entry->sites }, 2, 
        'Correct #sites in entry 104l.',
    );

    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is( 
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 104l, site 0.',
                );
                is(
                    scalar @{ $csa_site->residues }, 2, 
                    'Correct #residues for 104l, site 0.',
                );

                for my $csa_res ( @{ $csa_site->residues } ) {
                    switch ( $csa_res->residue_number ) {
                      case '11' {
                        is( 
                            $csa_res->chemical_function, 'S',
                            'Correct chemical function.',
                        );
                        is( 
                            $csa_res->chain_id, 'A',
                            'Correct chain ID.',
                        );
                        is( 
                            $csa_res->residue_type, 'GLU',
                            'Correct residue type.',
                        );
                      }
                    }
                }
            }
            case '1' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 104l, site 1.',
                );
                is(
                    scalar @{ $csa_site->residues }, 2,
                    'Correct #residues for 104l, site 1.',
                );
            }
        }
    }
}

######################################################################
## Check contents of CSA entry 12as.
sub check_entry_12as {
    my $csa_entry = shift;
    
    is(
        scalar @{ $csa_entry->sites }, 3,
        'Correct #sites in entry 12as.',
    );
    
    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case 'O' { 
                is(
                    $csa_site->evidence, 'LIT',
                    'Correct evidence for 12as, site 0.',
                ); 
                is(
                    scalar @{ $csa_site->residues }, 3,
                    'Correct #residues for 12as, site 0.',
                );
            }
            
            case '1' {
                is(
                    $csa_site->evidence, 'LIT',
                    'Correct evidence for 12as, site 0.',
                );
                is(
                    scalar @{ $csa_site->residues }, 3,
                    'Correct #residues for 12as, site 1.',
                );
            }
            
            case '2' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 12as, site 2.',
                );
                is(
                    scalar @{ $csa_site->residues }, 1,
                    'Correct #residues for 12as, site 2.',
                );
                for my $csa_res ( @{ $csa_site->residues } ) {
                    switch ( $csa_res->residue_number ) {
                        case '125' {
                            is(
                                $csa_res->residue_type, 'CYS',
                                'Correct residue type.',
                            );
                            is(
                                $csa_res->chemical_function, 'S',
                                'Correct chemical function.',
                            );
                            is(
                                $csa_res->chain_id, 'A',
                                'Correct chain ID.',
                            );
                        }	
                    }
                }
            }
        }
    }
}

######################################################################
## Check contents of CSA entry 9rub.
sub check_entry_9rub {
    my $csa_entry = shift;
    
    is(
        scalar @{ $csa_entry->sites }, 4,
        'Correct #sites in entry 9rub.',
    );

    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 9rub, site 0.',
                );
                is(
                    scalar @{ $csa_site->residues }, 3,
                    'Correct #residues for 9rub, site 0.',
                );
                is(
                    $csa_site->literature_entry, '1rbaA',
                    'Correct literature entry for 9rub, site 0.',
                );
            }
        }
    }
}


######################################################################
## Check contents of CSA entry 9xim.
sub check_entry_9xim {
    my $csa_entry = shift;
    
    is(
        scalar @{ $csa_entry->sites }, 12,
        'Correct #sites in entry 9xim.',
    );

    for my $csa_site ( @{ $csa_entry->sites } ) {
        switch ( $csa_site->site_number ) {
            case '0' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 9xim, site 0.',
                );
                is(
                    scalar @{ $csa_site->residues }, 3,
                    'Correct #residues for 9xim, site 0.',
                );
                is(
                    $csa_site->literature_entry, '1de6A',
                    'Correct literature entry for 9xim, site 0.',
                );
                for my $csa_res ( @{ $csa_site->residues } ) {
                    switch ( $csa_res->residue_number ) {
                        case '220' {
                            is(
                                $csa_res->residue_type, 'HIS',
                                'Correct residue type.',
                            );
                            is(
                                $csa_res->chemical_function, 'S',
                                'Correct chemical function.',
                            );
                            is(
                                $csa_res->chain_id, 'A',
                                'Correct chain ID.',
                            );
                        }   
                    }
                }
            }
            case '11' {
                is(
                    $csa_site->evidence, 'PSIBLAST',
                    'Correct evidence for 9xim, site 11.',
                );
                is(
                    scalar @{ $csa_site->residues }, 4,
                    'Correct #residues for 9xim, site 11.',
                );
                is(
                    $csa_site->literature_entry, '2xisA',
                    'Correct literature entry for 9xim, site 11.',
                );
                for my $csa_res ( @{ $csa_site->residues } ) {
                    switch ( $csa_res->residue_number ) {
                        case '57' {
                            is(
                                $csa_res->residue_type, 'ASP',
                                'Correct residue type.',
                            );
                            is(
                                $csa_res->chemical_function, 'S',
                                'Correct chemical function.'
                            );
                            is(
                                $csa_res->chain_id, 'D',
                                'Correct chain ID.',
                            );
                        }
                    }
                }
            }
        }
    }
}