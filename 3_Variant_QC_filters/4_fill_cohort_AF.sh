#!/bin/bash
##############################################################################

## Following step 3_isec, recalculate AF, AF, AN in the filtered vcf
## Usage: bash 4_fill_cohort_AF.sh
## Docker: staphb/bcftools:latest

##############################################################################

nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."

  input_file="/VCFs/chr${chr}/0000.vcf"
  output="/VCFs/chr${chr}/chr${chr}_filled.vcf.gz"
  bcftools view --threads ${nthreads} ${input_file} | bcftools +fill-tags - -Oz -o ${output} -Wtbi -- -t AC,AF,AN"
done
