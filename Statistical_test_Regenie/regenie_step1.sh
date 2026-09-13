#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage2/fs1/epigenome/Active/shared_smaht:/storage2/fs1/epigenome/Active/shared_smaht'
#work_dir="/storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test/regenie/5.14_new"
work_dir="/storage1/fs1/jin810/Active/testing/vivien/regenie/5.14_new"
log_dir="${work_dir}/log"
#log_dir="/storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test/regenie/5.14_new/log"
mkdir -p ${log_dir}

bsub -R "rusage[mem=10G] span[hosts=1]" -G compute-jin810 -n 1 -oo "${log_dir}/regenie_step1_%J.log" -q general -a 'docker(briansha/regenie:v4.0)' LC_ALL=C \
LANGUAGE= \
regenie \
  --step 1 \
  --bed ${work_dir}/step1_pruned \
  --covarFile  ${work_dir}/new_covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --bsize 1000 \
  --bt \
  --out fit_bin_out \
  #--covarCol PC{1:10}
