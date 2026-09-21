#!/bin/bash
##############################################################################

## Following vcf split by chr, run GLNEXUS to generate joint bcf for the entire cohort
## Unfiltered genotype: specified by "--config gatk_unfiltered"
## Usage: bash run_GLNEXUS.sh $chr
## Docker: elle72/glnexus:vs2

##############################################################################

chr=$1
VCF_Files_Path_and_Pattern="*.g.vcf"

LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so glnexus_cli --config gatk_unfiltered -m 5 -t 16 \
  --dir TMP/chr${chr}/GLnexus.DB --bed BEDs/chr${chr}/Homo_sapiens_assembly38_chr${chr}.bed \
  ${VCF_Files_Path_and_Pattern} > BCFs/chr${chr}/chr${chr}_IPN_unfiltered.bcf
