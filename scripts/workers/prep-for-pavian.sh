#!/usr/bin/env bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l place=free:shared
#PBS -l select=1:ncpus=12:mem=68gb:pcmem=6gb
#PBS -l walltime=12:00:00
#PBS -l cput=144:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

#make sure this matches ncpus in the above header!
export THREADS="--threads 12"
#
# runs centrifuge, brought to you by the good people who brought you bowtie2
#

# --------------------------------------------------
# singularity is needed to run singularity images
module load singularity
#
#LOAD REQUIRED R MODULES
#module load unsupported
#module load markb/R/3.1.1

# --------------------------------------------------

unset module
set -u

CONFIG="$SCRIPT_DIR/config.sh"

if [ -e $CONFIG ]; then
  . "$CONFIG"
else
  echo Missing config \"$CONFIG\"
  exit 1
fi

cd $PRJ_DIR

echo Host \"$(hostname)\"

echo Started $(date)

TMP_FILES=$(mktemp)

get_lines $TODO $TMP_FILES $PBS_ARRAY_INDEX $STEP_SIZE

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
    echo Something went wrong or no files to process
    exit 1
else
    echo Found \"$NUM_FILES\" files to process
fi

export cent="singularity exec \
    -B $CFUGE_DIR:$SING_WD,$(dirname $CENT_DB):$SING_CENT \
    $SING_IMG/centrifuge.img centrifuge-kreport" 

mkdir -p $CFUGE_DIR

#RUN CENTRIFUGE ON ALL SEQUENCE FILES FOUND IN FIXED_DIR
while read HITS; do

    SAMPLE=$(basename $HITS _hits.tsv)

    echo "Doing Sample $SAMPLE"

    $cent -x $SING_CENT/$DB $SING_WD/$HITS > "$SAMPLE"-pavian.tsv

done < $TMP_FILES


echo done $(date)
