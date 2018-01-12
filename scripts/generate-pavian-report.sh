#!/usr/bin/env bash
#
# Script to run centrifuge-kreport
#

set -u

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo Missing config \"$CONFIG\" ermagod!
    exit 12345
fi

mkdir -p $MY_TEMP_DIR
export CWD="$PWD"
export STEP_SIZE=1

PROG=`basename $0 ".sh"`
STDOUT_DIR="$CWD/pbs_logs/$PROG"

init_dir "$STDOUT_DIR" 

cd $PRJ_DIR

export CFUGELIST="$MY_TEMP_DIR/cfuge_list"

find $CFUGE_DIR -iname "*hits.tsv" > $CFUGELIST

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

cat $CFUGELIST >> $TODO

NUM_FILES=$(lc $TODO)

echo Found \"$NUM_FILES\" files in \"$CFUGE_DIR\" to work on

JOB=$(qsub -J 1-$NUM_FILES:$STEP_SIZE -V -N jj -j oe -o "$STDOUT_DIR" $WORKER_DIR/prep-for-pavian.sh)

if [ $? -eq 0 ]; then
  echo -e "Submitted job \"$JOB\" for you in steps of \"$STEP_SIZE.\"
  Miksch's Law: If a string has one end, then it has another end."
else
  echo -e "\nError submitting job\n$JOB\n"
fi

