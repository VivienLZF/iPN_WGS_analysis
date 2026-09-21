#!/bin/bash
##############################################################################

## Filter out variants violating Hardy-Weinberg equilibrium with p-value < 10e-6
## Usage: bash 5_HWE_filter.sh
## Docker: staphb/bcftools:latest

##############################################################################

nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."

  input_file="VCFs/chr${chr}/chr${chr}_filled.vcf.gz"
  output="VCFs/chr${chr}/chr${chr}_hwe.vcf.gz"

  bcftools +fill-tags ${input_file} -Ou -- -t HWE | bcftools filter -Oz -o ${output} -Wtbi -e 'HWE < 0.000001'"
done
