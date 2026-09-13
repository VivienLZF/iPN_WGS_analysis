#!/bin/bash
# Define your list of names
variable_list=($(ls /storage1/fs1/jin810/Active/testing/vivien/gatk_test/IPN1/gvcf/*.vcf| sed -e 's+/storage1/fs1/jin810/Active/testing/vivien/gatk_test/IPN1/gvcf/++g'))

# Loop through the list and execute the command for each name
xx=$(($LSB_JOBINDEX - 1))
name=$(echo ${variable_list[$xx]})
bcftools view /storage1/fs1/jin810/Active/testing/vivien/gatk_test/IPN1/gvcf/$name | grep -P '^(#|(chr){0,'$1'}'$1'\t)' >> /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step1/GLNEXUS/VCFs/chr$1/$name
