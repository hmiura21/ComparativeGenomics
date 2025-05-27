#!/bin/bash

source ~/miniforge3/etc/profile.d/conda.sh


#fetch raw files ------------------------------------------------------------

#activate env from ex 3
conda activate ex3

#create new directory and go to it
mkdir Raw_FastQs
cd Raw_FastQs/

#prefetch files
for accession in SRR1556294 SRR1556293 SRR1556289 SRR1556296 SRR1556290 SRR1556291 SRR1556297 SRR1556295 SRR1556288 SRR1553827; do
    prefetch "${accession}"
done

#fetch files
for accession in SRR1556294 SRR1556293 SRR1556289 SRR1556296 SRR1556290 SRR1556291 SRR1556297 SRR1556295 SRR1556288 SRR1553827; do
  fasterq-dump \
   "${accession}" \
   --outdir . \
   --split-files \
   --skip-technical
done

#zip files
pigz -9 *.fastq

#go back to home directory 
cd ..

#read clean ------------------------------------------------------------

#create new directory and go to it
mkdir Cleaned_FastQs
cd Cleaned_FastQs

#clean with fastp
for read in ../Raw_FastQs/*_1.fastq.gz; do
  sample="$(basename ${read} _1.fastq.gz)"
   fastp \
   -i "${read}" \
   -I "${read%_1.fastq.gz}_2.fastq.gz" \
   -o "${sample}.R1.fq.gz" \
   -O "${sample}.R2.fq.gz" \
   --json "${sample}.json" \
   --html "${sample}.html"
done

#check files
ls *.gz

#go back to home directory 
cd ..

#assembly ------------------------------------------------------------

#create new directory and go to it
mkdir Assemblies
cd Assemblies

#assemble with skesa
for read in ../Cleaned_FastQs/*.R1.fq.gz; do
  sample="$(basename ${read} .R1.fq.gz)"
  skesa \
   --reads "${read}","${read%R1.fq.gz}R2.fq.gz" \
   --cores 4 \
   --min_contig 1000 \
   --contigs_out "${sample}".fna
done

#check files
ls *.fna

#go back to home directory
cd ..

#ParSNP ------------------------------------------------------------

#activate new conda env from class exercise
conda deactivate
conda activate harvestsuite

#create new directory and go to it
mkdir parsnp_input_assemblies
cd parsnp_input_assemblies

#make shortcut files
for file in ../Assemblies/*.fna; do
  ln -sv "${file}" "$(basename ${file})"
done

#confirm files
ls -alhtr *.fna

#go back to home directory
cd ..

#create new directory for reference file and go to it
mkdir parsnp_ref_assembly

#move ref file from input assembly file to ref assembly directory
mv parsnp_input_assemblies/SRR1556288.fna parsnp_ref_assembly/

#parsnp
parsnp \
 -d parsnp_input_assemblies \
 -r parsnp_ref_assembly/SRR1556288.fna \
 -o parsnp_outdir \
 -p 4

 #launch GUI for phylogenetic tree
 figtree parsnp_outdir/parsnp.tree

 #within GUI, select midpoint rooting and order by increasing for 
 #tree visualization

 #deactivate conda env
 conda deactivate