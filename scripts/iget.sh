#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=1gb
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

if [ ! -d "$ISO_DIR" ]; then
    mkdir -p $ISO_DIR
fi

cd $ISO_DIR

echo "Started at $(date)"

echo "getting isogenie data"

iget -N 12 -r -X ./restartFile --lfrestart ./lfsrestartFILE $IRODS_DIR

echo "Done at $(date)"
