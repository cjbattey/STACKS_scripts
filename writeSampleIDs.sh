#!/bin/bash

names=./aligned_reads/*
for n in $names
do
echo ${n#./aligned_reads/}
done > ./popmaps/sampleIDs.txt