#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active /storage2/fs1/epigenome/Active/shared_smaht:/storage2/fs1/epigenome/Active/shared_smaht'
work_dir="/storage1/fs1/jin810/Active/testing/vivien/regenie/5.14_new"
#anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/genome_wide/LP_by_chr"
#anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno"
anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/4.27_164PN/plof_am"
#anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/before12.26.25/10.3CMT"
log_dir="/storage1/fs1/jin810/Active/testing/vivien/regenie/5.14_new/log"
mkdir -p ${log_dir}

bsub -R "rusage[mem=60G,tmp=40G] span[hosts=1]" -G compute-jin810 -n 1 -oo "${log_dir}/regenie_step2_gene_based_%J.log" -q general -a 'docker(briansha/regenie:v4.0)' LC_ALL=C \
LANGUAGE= \
regenie \
  --step 2 \
  --bed ${work_dir}/step2 \
  --covarFile  ${work_dir}/new_covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --bsize 200 \
  --bt \
  --pred ${work_dir}/fit_bin_out_pred.list \
  --anno-file  ${anno_dir}/anno_merged_input.txt \
  --set-list  ${anno_dir}/merged_masks.txt \
  --extract-sets ${anno_dir}/inclusion_sets.txt \
  --mask-def mask_LP.txt \
  --rgc-gene-p \
  --out noPN_test_bin_out_spa_gene_based \
  --minMAC 1 \
  --spa \
  --af-cc \
  --keep ${work_dir}/noPN_control_samples1705.txt
  #--spa
  #--firth --approx
  #--ignore-pred
  #--minMAC 1
  #--vc-tests skat,skato,skato-acat,acatv,acato,acato-full