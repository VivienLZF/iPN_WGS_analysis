#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active /storage2/fs1/epigenome/Active/shared_smaht:/storage2/fs1/epigenome/Active/shared_smaht'
work_dir="/storage1/fs1/jin810/Active/testing/vivien/regenie/5.14_new"
#anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno"
#anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/10.9CMT_plof_LOEUF1"
anno_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/4.27_164PN/plof_am"
log_dir="/storage1/fs1/jin810/Active/testing/vivien/regenie/5.14_new/log"
#log_dir="/storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test"
mkdir -p ${log_dir}

bsub -R "rusage[mem=60G,tmp=40G] span[hosts=1]" -G compute-jin810 -n 1 -oo "${log_dir}/regenie_step2_%J.log" -q general -a 'docker(briansha/regenie:v4.0)' LC_ALL=C \
LANGUAGE= \
regenie \
  --step 2 \
  --bed ${work_dir}/step2 \
  --covarFile  ${work_dir}/new_covar.txt \
  --phenoFile  ${work_dir}/pheno.txt \
  --catCovarList SEX \
  --bsize 200 \
  --bt \
  --out test_bin_out_spa \
  --extract ${anno_dir}/unique_LP_IDs.txt \
  --minMAC 1 \
  --spa \
  --af-cc \
  --pred ${work_dir}/fit_bin_out_pred.list
  #--covarCol PC{1:10}
  #--ignore-pred
