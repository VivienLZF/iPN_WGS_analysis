#!/bin/bash
##############################################################################

## Regenie step2 (variant-based): the purpose is to extract carriers for each variant
## Binary trait, 
## Usage: bash regenie_step2_variant.sh
## Docker: briansha/regenie:v4.0

##############################################################################

work_dir=""
anno_dir="vep_anno"

regenie \
  --step 2 \
  --bed ${work_dir}/regenie_step2 \
  --covarFile  ${work_dir}/covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --covarColList PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
  --bsize 200 \
  --bt \
  --out test_bin_out_firth \
  --extract ${anno_dir}/unique_LP_IDs.txt \
  --minMAC 1 \
  --firth --approx \
  --af-cc \
  --pred ${work_dir}/fit_bin_out_pred.list
