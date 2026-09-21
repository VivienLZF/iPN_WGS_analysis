#!/bin/bash
##############################################################################

## Only keep high-quality variant loci across all batches
## Usage: bash 3_isec_combine_batch.sh
## Docker: staphb/bcftools:latest

##############################################################################

nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."
  
  input="VCFs/chr${chr}/chr${chr}_IPN_QC_all.vcf.gz"
  input1="VCFs/chr${chr}/chr${chr}_IPN_batchQC_1.vcf.gz"
  input2="VCFs/chr${chr}/chr${chr}_IPN_batchQC_2.vcf.gz"
  input3="VCFs/chr${chr}/chr${chr}_IPN_batchQC_3.vcf.gz"
  input4="VCFs/chr${chr}/chr${chr}_IPN_batchQC_4.vcf.gz"
  output="VCFs/chr${chr}"

  bcftools isec -n=5 -c none -w1 --threads ${nthreads} ${input} ${input1} ${input2} ${input3} ${input4} -p ${output}"
done
