#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'
batches=(
    "/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/IPN/STAAR-Step0-QC_Filter_Vcfs/PNRR.txt"
    "/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/IPN/STAAR-Step0-QC_Filter_Vcfs/TWHJ.txt"
    "/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/IPN/STAAR-Step0-QC_Filter_Vcfs/WES.txt"
    "/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/IPN/STAAR-Step0-QC_Filter_Vcfs/Carlos.txt"
)
for chr in {3..22}; do
  echo "Processing chr$chr..."
  log_dir="/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-QC_Filter_Vcfs"

  bsub -G compute-jin810 \
       -q general \
       -n 1 \
       -R 'rusage[mem=10GB]' \
       -a 'docker(staphb/bcftools:latest)' \
       -J "QC_batch_chr${chr}[1-${#batches[@]}]" \
       -oo "${log_dir}/QC_batch_chr${chr}_%J_%I.log" \
       bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/IPN/STAAR-Step0-QC_Filter_Vcfs/miss_batch.sh ${chr}
done
