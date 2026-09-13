#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs
nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."
  
  input="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_QC_all.vcf.gz"
  input1="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_batchQC_PNRR.vcf.gz"
  input2="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_batchQC_TWHJ.vcf.gz"
  input3="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_batchQC_WES.vcf.gz"
  input4="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_batchQC_Carlos.vcf.gz"
  output="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}"
  log_dir="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs"

  bsub -G compute-jin810 \
       -q general \
       -n 1 \
       -R 'rusage[mem=10GB]' \
       -a 'docker(staphb/bcftools:latest)' \
       -J isec_chr${chr} \
       -oo "${log_dir}/isec_chr${chr}_%J.log" \
       "bcftools isec -n=5 -c none -w1 --threads ${nthreads} ${input} ${input1} ${input2} ${input3} ${input4} -p ${output}"
done
