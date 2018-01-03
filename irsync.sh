#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=72:00:00
#PBS -l cput=72:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -N irsync
#PBS -o pbs_logs/
#PBS -e pbs_logs/

export WD=$PBS_O_WORKDIR

cd $WD

mkdir -p pbs_logs

if [ -e config.sh ]; then
    source config.sh
else
    echo NO config file!
    exit 12345
fi

if [ ! -d "$DL_DIR" ]; then
    mkdir -p $DL_DIR
fi

cd $DL_DIR

echo "Started at $(date)"

echo "Syncing single-end read files to irods / cyverse" 

irsync -r /rsgrps/bhurwitz/hurwitzlab/data/controlled_access/PRJEB12449/single i:/iplant/home/scottdaniel/ebi/single

echo "Done at $(date)"
