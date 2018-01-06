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

import os
import subprocess
from pathlib import Path
import shutil
from plumbum import local

find = local["find"]
mkdir = local["mkdir"]
cat = local["cat"]
xargs = local["xargs"]

#should change the directory
os.chdir(os.environ.get('PBS_O_WORKDIR'))

#function to import variable from config.sh or other sourcefile
def import_config(sourcefile='./config.sh'):
    command = ['bash', '-c', 'source ' + sourcefile + ' && env']
    proc = subprocess.Popen(command, stdout=subprocess.PIPE)
    for aline in proc.stdout:
        (key, _, value) = aline.decode().partition("=")
        os.environ[key] = value.rstrip('\n')
    proc.communicate()

#call the function
import_config()

#testing
#print("Current environment is {:s}".format(str(os.environ)))

list_of_fastq =find(os.environ.get('ISO_DIR'), '-iname', '*.fastq')

print("List of fastq files is {:s}".format(list_of_fastq))

#print("Making DNA_DIR {:s}".format(os.environ.get('DNA_DIR')))
#
#mkdir('-p',os.environ.get('DNA_DIR'))
#
##print("Concatenating Day50_Erio_R1")
##
##chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day50_Erio_output.fastq'] | \
##        xargs['-I','file','cat','file'] \
##        > os.environ.get('DNA_DIR')+'/Day50_Erio_R1.fastq')
#
##chain()
#
#print("Concatenating Day50_Erio_R2")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day50_Erio_output2.fastq'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day50_Erio_R2.fastq')
#
#chain()
#
#print("Done")
#print("Concatenating Day50_Erio_R2")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day50_Erio_output2.fastq'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day50_Erio_R2.fastq')
#
#chain()
#
#print("Done")
#print("Concatenating Day50_Erio_unpaired")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day50_Erio_unpaired*'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day50_Erio_unpaired.fastq')
#
#chain()
#
#print("Done")
#print("Concatenating Day0_Erio_unpaired")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day0_Erio_unpaired*'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day0_Erio_unpaired.fastq')
#
#chain()
#
#print("Done")
#
#print("Concatenating Day50_SPH_unpaired")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day50_SPH_unpaired*'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day50_SPH_unpaired.fastq')
#
#chain()
#
#print("Done")
#print("Concatenating Day0_SPH_unpaired")
#
#chain = (find[os.environ.get('ISO_DIR'),'-iname','*Day0_SPH_unpaired*'] | \
#        xargs['-I','file','cat','file'] \
#        > os.environ.get('DNA_DIR')+'/Day0_SPH_unpaired.fastq')
#
#chain()
#
#print("Done")
#

print("Copying and renaming Day50_SPH paired reads")

for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day50_SPH_output.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day50_SPH_R1.fastq'))

for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day50_SPH_output2.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day50_SPH_R2.fastq'))

print("Done")

print("Copying and renaming Day0_SPH paired reads")


for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day0_SPH_output.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day0_SPH_R1.fastq'))

for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day0_SPH_output2.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day0_SPH_R2.fastq'))

print("Done")

print("Copying and renaming Day0_Erio paired reads")

for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day0_Erio_output.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day0_Erio_R1.fastq'))

for line in list_of_fastq.split('\n'):
    p = Path(line)
    if str(p).endswith('Day0_Erio_output2.fastq'):
        shutil.copy(p, os.path.join(os.environ.get('DNA_DIR'),'Day0_Erio_R2.fastq'))

print("All done!")
