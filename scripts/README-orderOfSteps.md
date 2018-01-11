# Order of operations
## Can pre-pend script names to 00, 01, etc. once finalized

* catSamples.py
* centrifuge.sh
{
`source ./scripts/config.sh`
`cd ./dna/cfuge/`
`centrifuge-kreport -x $CENT_DB Day0_SPHcentrifuge_hits.tsv Day0_Eriocentrifuge_hits.tsv Day50_SPHcentrifuge_hits.tsv Day50_Eriocentrifuge_hits.tsv`
then download the resultant files for the interactive pavian analysis
}
* interactive_pavian_analysis.R
* get-genomes.sh
* cat-and-bt2-build.sh
* align-with-bowtie2.sh
* convert-to-bam.sh

May want to change here to htseq count or some other program
Cuffquant / cuffnorm are suited for differential expression
(and eukaryotic expression at that)

* cuffquant.sh
* cuffnorm.sh
