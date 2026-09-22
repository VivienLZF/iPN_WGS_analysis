#!/bin/bash
##############################################################################

## Reset low quality genotype as missing for all chromosomes
## QC criteria: GQ≥20, 10≤DP≤80; for heterozygous call: 0.3≤VAF≤0.7, AD≥4, SB≥1 for each strand supporting Alt
## Usage: bash 1_setGT_all.sh
## Docker: staphb/bcftools:latest

##############################################################################

nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."

  input_file="VCFs/chr${chr}/chr${chr}_IPN.vcf.gz"
  output_file="VCFs/chr${chr}/chr${chr}_IPN_QC_all.vcf.gz"

       bcftools view --threads ${nthreads} ${input_file} | \
       bcftools +setGT -- -t q -n . -i 'GQ<20 | DP<10 | DP>80' | \
       bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (AD[:1]/DP<0.3 | AD[:1]/DP>0.7)' | \
       bcftools +setGT -- -t q -n . -i 'GT=\"het\" & AD[:1]<4' | \
       bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (SB[:2]<1 | SB[:2]=\".\" )' | \
       bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (SB[:3]<1 | SB[:3]=\".\" )' | \
       bcftools filter -Wtbi -Oz -o ${output_file}"

done
