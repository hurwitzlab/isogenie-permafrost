#!/usr/bin/env bash

#Script to take taxonomy counts for the 4 DNA samples and make a taxonomy chart with krona tools

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=1:mem=5gb
#PBS -l walltime=8:00:00
#PBS -l cput=8:00:00
#PBS -M scottdaniel@email.arizona.edu
#PBS -m bea

echo "Time started: $(date)"

cd $CFUGE_DIR

echo Making Krona Charts
time ktImportTaxonomy \
    -o $KRONA_OUT_DIR/Day0-50_Erio-SPH_comparison.html \
    -q 1 \
    -t 3 \
    -s 4 \
    ${SAMPLE_NAMES[0]}centrifuge_hits.tsv,"${SAMPLE_NAMES[0]}" \
    ${SAMPLE_NAMES[1]}centrifuge_hits.tsv,"${SAMPLE_NAMES[1]}" \
    ${SAMPLE_NAMES[2]}centrifuge_hits.tsv,"${SAMPLE_NAMES[2]}" \
    ${SAMPLE_NAMES[3]}centrifuge_hits.tsv,"${SAMPLE_NAMES[3]}"

echo "Time ended: $(date)"
