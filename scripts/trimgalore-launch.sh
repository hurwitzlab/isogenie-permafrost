#!/usr/bin/env bash
#
# runs singularity fastqc.img trim_galore to trim adapters and low quality bases
#

set -u
source ./config.sh
export CWD="$PWD"
#batches of N
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export DNALIST="$MY_TEMP_DIR/dna_fastq_file_list"

find $DL_CANCER $DL_CONTROL -iname "*_1.fastq.gz" > $DNALIST

mkdir -p $TRIMMED_DIR
mkdir -p $TRMD_CANC
mkdir -p $TRMD_CONT

export TODO="$MY_TEMP_DIR/files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi

#TODO: something aint right with the paired end stuff, it cant find certain files, check logs (unpaired went fine)

echo "Checking if trimming has already been done for dna"
while read FASTQ; do

    if [[ $FASTQ =~ "cancer" ]]; then
    
        if [ ! -e "$TRMD_CANC/$(basename $FASTQ _1.fastq.gz)_trimmed.fq.gz" ]; then
            echo $FASTQ >> $TODO
        fi

    else
        
        if [ ! -e "$TRMD_CONT/$(basename $FASTQ _1.fastq.gz)_trimmed.fq.gz" ]; then
            echo $FASTQ >> $TODO
        fi

    fi

done < $DNALIST

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$PRJ_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N trimgalore -j oe -o "$STDOUT_DIR" $WORKER_DIR/trimgalore.sh)

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\" grep me no patterns and I will tell you no lines.
else
  echo -e "\nError submitting job\n$JOB\n"
fi

