#!/usr/bin/env python

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -N renameFiles
#PBS -o pbs_logs/
#PBS -e pbs_logs/

import os, sys, argparse, subprocess
from plumbum import local

find = local["find"]

#should change the directory
os.chdir(os.environ.get('PBS_O_WORKDIR'))

#function to import variable from config.sh or other sourcefile
def import_config(sourcefile='./config.sh'):
    command = ['bash', '-c', 'source ' + sourcefile + ' && env']
    proc = subprocess.Popen(command, stdout = subprocess.PIPE)
    for line in proc.stdout:
        (key, _, value) = line.decode().partition("=")
        os.environ[key] = value.rstrip('\n')
    proc.communicate()

#call the function
import_config()

#testing
#print("Current environment is {:s}".format(str(os.environ)))

list_of_fastq = find(os.environ.get('ISO_DIR'),'-iname','*.fastq')

print("List of fastq files is {:s}".format(list_of_fastq))

