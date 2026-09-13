#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs
nthreads=$(nproc)

for chr in {1..22}; do
  echo "Processing chr$chr..."

  input_file="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/0000.vcf"
  #isec_loci="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/shared_loci_chr${chr}.txt"
  output="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/IPN/VCFs/chr${chr}/chr${chr}_filled.vcf.gz"
  log_dir="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs"

  bsub -G compute-jin810 \
       -q general \
       -n 1 \
       -R 'rusage[mem=10GB]' \
       -a 'docker(staphb/bcftools:latest)' \
       -J fillAF_chr${chr} \
       -oo "${log_dir}/fillAF_chr${chr}_%J.log" \
       "bcftools view --threads ${nthreads} ${input_file} | bcftools +fill-tags - -Oz -o ${output} -Wtbi -- -t AC,AF,AN"
done
