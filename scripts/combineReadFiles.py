#!/usr/bin/env python

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -l walltime=2:00:00
#PBS -l cput=2:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m ea
#PBS -j oe
#PBS -N combineReadfiles
#PBS -o pbs_logs/
#PBS -e pbs_logs/

"""script to combine fastq forward and reverse given by _1 or _2
Ex: SRR2363_1.fq.gz + SRR2363_2.fq.gz > SRR2363.fq.gz"""

import os
import sys
from pathlib import Path
#import shutil
from plumbum import local
import time

print('Started at {}'.format(time.localtime))

cat = local["cat"]

args = sys.argv[1:]

if len(args) != 2:
    print('Usage: {} [In: Directory of gzipped fastq]'.format(os.path.basename(sys.argv[0])),' [Out: Directory of combined gzipped fastq]')
    sys.exit(1)

in_dir = args[0]
out_dir = args[1]

print('Directory to work on is "{}"'.format(in_dir))
print('And outputting to "{}"'.format(out_dir))

#find = local["find"]

#should change the directory
os.chdir(os.environ.get('PBS_O_WORKDIR'))

#list_of_fastq =find('./fastq', '-iname', '*.fastq')

#make lists
forwardReads = list(Path(in_dir).glob('*_1.fastq.gz'))
reverseReads = list(Path(in_dir).glob('*_2.fastq.gz'))

#debug
#print('Forward reads are {}'.format(forwardReads))
#print('Reverse reads are {}'.format(reverseReads))

#sort them
forwardReads.sort()
reverseReads.sort()

for i in range(0, len(forwardReads)):
    print('{},{}'.format(forwardReads[i].name,reverseReads[i].name))
    short = forwardReads[i].name.split('_')[i]
    print('Combining into {}.fastq.gz'.format(short))
    catting = (cat[forwardReads[i],reverseReads[i]] > out_dir + short + '.fastq.gz')
    catting()

print('Done at {}'.format(time.localtime))
