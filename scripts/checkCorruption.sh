#!/usr/bin/env bash
#
# Script to run gunzip -t [file] to test for corrupt files
# this script splits them up into batches of 10
#

set -u

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo Missing config \"$CONFIG\" ermagod!
    exit 12345
fi

export CWD="$PWD"
export STEP_SIZE=10

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export CHECKLIST="$MY_TEMP_DIR/fna_list"

find $DL_CANCER -iname "*.fastq.gz" > $CHECKLIST
find $DL_CONTROL -iname "*.fastq.gz" >> $CHECKLIST

export TODO="$MY_TEMP_DIR/files_todo"

if [ -e $TODO ]; then
    rm $TODO
fi
#
#for FASTA in $(cat $LIST); do
#
#    if [ ! -e ""$FASTA".rev.2.bt2" ]; then
#        echo $FASTA >> $TODO
#    fi
#
#done

cat $CHECKLIST >> $TODO

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$DL_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N checkCorruption -j oe -o "$STDOUT_DIR" $WORKER_DIR/runGunzipTest.sh)

if [ $? -eq 0 ]; then
  echo -e "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
Q: How many Oregonians does it take to screw in a light bulb?
A: Three. One to screw in the lightbulb and two to fend off all those
   Californians trying to share the experience."
else
  echo -e "\nError submitting job\n$JOB\n"
fi

