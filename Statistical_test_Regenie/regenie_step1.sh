#!/bin/bash
##############################################################################

## Regenie step1: fit whole genome regression model
## Input: LD pruned bed, covariate and phenotype file
## Output: fit_bin_out_1.loco, fit_bin_out.log, fit_bin_out_pred.list
## Usage: bash regenie_step1.sh
## Docker: briansha/regenie:v4.0

##############################################################################

work_dir=""

regenie \
  --step 1 \
  --bed ${work_dir}/regenie_step1_pruned \
  --covarFile  ${work_dir}/covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --covarColList PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
  --bsize 1000 \
  --bt \
  --out fit_bin_out \
  --keep ${work_dir}/samples_list.txt
