#!/bin/bash
#Extract reads by chromosome from C.anna alignments
#previously...
#1. aligned C.anna genome (illumina) to repeat-masked tgut2 (sanger, w/chromosomes)
#2. identified all contigs/scaffolds with >= 1kb total matching seq to each tgut chromosome
#   (no C. anna scaffold matched to > 1 tgut2 chromosome)

#To do: 
#1. loop through bam files extracting z-chromosome reads
#2. re-run STACKS from start on just z-chr reads, 
#3. output vcf & structure for PCA's + Fst., 4. Compare z & autosome divergence

cd ~/Dropbox/ruhu/rad/stacks/
mkdir aligned_reads_sorted
mkdir zChr_reads

files=aligned_reads/*

for f in $files
do
echo "subsetting $f"
samtools sort $f > ./aligned_reads_sorted/${f#*/}
samtools index ./aligned_reads_sorted/${f#*/}
samtools view -b ./aligned_reads_sorted/${f#*/} C11652863 scaffold1057 scaffold121 scaffold1267 scaffold128 scaffold13 scaffold138 scaffold1426 scaffold151 scaffold1547 scaffold1755 scaffold178 scaffold179 scaffold207 scaffold245 scaffold251 scaffold253 scaffold26 scaffold261 scaffold270 scaffold276 scaffold280 scaffold29 scaffold301 scaffold331 scaffold351 scaffold375 scaffold387 scaffold407 scaffold451 scaffold46 scaffold466 scaffold497 scaffold50 scaffold501 scaffold508 scaffold511 scaffold537 scaffold54 scaffold584 scaffold586 scaffold59 scaffold593 scaffold618 scaffold62 scaffold628 scaffold76 scaffold768 scaffold775 scaffold792 scaffold796 scaffold803 scaffold850 scaffold859 scaffold87 scaffold89 scaffold893 scaffold95 > ./zChr_reads/${f#*/}.chrZ.bam
done


