#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage2/fs1/epigenome/Active/shared_smaht:/storage2/fs1/epigenome/Active/shared_smaht /storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active'

mkdir -p /storage1/fs1/jin810/Active/testing/vivien/vep_anno/log
log_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/log"
for i in $(seq 1 22); do
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/vep_anno/chr$i
done

for CHR in $(seq 1 22); do
num=$(ls /storage1/fs1/jin810/Active/testing/vivien/split_vcf/chr${CHR}_chunk*|wc -l)

bsub -n 1 -M 1000GB -g /l.vivien/staar -R "rusage[mem=20GB,tmp=4GB]" -G compute-jin810 -q general-interactive \
     -J "vep_anno_chr${CHR}_${Project_Name}[1-${num}]" \
     -o ${log_dir}/vep_chr${CHR}_%J_%I.out \
     -e ${log_dir}/vep_chr${CHR}_%J_%I.err \
     -a 'docker(lvivien/vep_samtools:v1.0)' \
     bash /storage1/fs1/jin810/Active/testing/vivien/vep_anno/vep_anno.sh ${CHR}
done