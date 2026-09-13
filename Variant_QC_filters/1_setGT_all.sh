#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs
nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."

  input_file="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN.vcf.gz"
  output_file="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_IPN_QC_all.vcf.gz"
  log_dir="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs"

  bsub -G compute-jin810 \
       -q general \
       -n 1 \
       -R 'rusage[mem=10GB]'\
       -a 'docker(staphb/bcftools:latest)' \
       -J QC_chr${chr} \
       -oo "${log_dir}/QC_chr${chr}_%J.log" \
       "bcftools view --threads ${nthreads} ${input_file} | \
        bcftools +setGT -- -t q -n . -i 'GQ<20 | DP<10 | DP>80' | \
        bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (AD[:1]/DP<0.3 | AD[:1]/DP>0.8)' | \
        bcftools +setGT -- -t q -n . -i 'GT=\"het\" & AD[:1]<4' | \
	bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (SB[:2]<1 | SB[:2]=\".\" )' | \
        bcftools +setGT -- -t q -n . -i 'GT=\"het\" & (SB[:3]<1 | SB[:3]=\".\" )' | \
        bcftools filter -Wtbi -Oz -o ${output_file}"

done
