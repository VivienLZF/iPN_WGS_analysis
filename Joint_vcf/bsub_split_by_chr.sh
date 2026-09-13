#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'
# Define your list of names

variable_list=($(ls /storage1/fs1/jin810/Active/testing/vivien/gatk_test/IPN1/gvcf/*.vcf| sed -e 's+/storage1/fs1/jin810/Active/testing/vivien/gatk_test/IPN1/gvcf/++g'))

# Submit the array job
for chr in $(seq 1 22); do
mkdir -p  /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step1/GLNEXUS/VCFs/chr${chr}
bsub -J "split_vcfs_by_chr${chr}[1-${#variable_list[@]}]" -R 'rusage[mem=5GB]' -g /l.vivien/testing_glnexus -q general -G compute-jin810 -o /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step1/GLNEXUS/LOGFILES/split_vcfs_by_chr/%J.%I.out -e /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step1/GLNEXUS/LOGFILES/split_vcfs_by_chr/%J.%I.err -a 'docker(elle72/glnexus:vs2)' bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step1/GLNEXUS/CODE/batch1_array.sh $chr
done
