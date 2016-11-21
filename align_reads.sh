#!/bin/bash

cd ~/Dropbox/ruhu/rad/stacks/

files=~/Dropbox/ruhu/rad/pyrad/demultiplexed_reads/*
for f in $files
do
  echo "Processing $f"
  
  bowtie2 -p 8 -x ./bowtie2_index/anhu -U $f \
  -S ${f}.sam
  
  samtools view ${f}.sam \
  -b -q 10 -o ${f%_R1.fq.gz}.bam
  
  rm ${f}.sam
  
done



















































































