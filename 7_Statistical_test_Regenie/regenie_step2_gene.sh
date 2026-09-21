#!/bin/bash
##############################################################################

## Regenie step2 (gene-based)
## Binary trait, with Firth correction, adjusting for SEX and PC1-10
## Usage: bash regenie_step2_gene.sh
## Docker: briansha/regenie:v4.0

##############################################################################

work_dir=""
anno_dir="vep_anno"

regenie \
  --step 2 \
  --bed ${work_dir}/step2 \
  --covarFile  ${work_dir}/covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --covarColList PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
  --bsize 200 \
  --bt \
  --pred ${work_dir}/fit_bin_out_pred.list \
  --anno-file  ${anno_dir}/anno_merged_input.txt \
  --set-list  ${anno_dir}/merged_masks.txt \
  --extract-sets ${anno_dir}/inclusion_sets.txt \
  --mask-def mask_LP.txt \
  --rgc-gene-p \
  --out test_bin_out_firth_gene_based \
  --minMAC 1 \
  --firth --approx \
  --af-cc \
  --keep ${work_dir}/samples_list.txt