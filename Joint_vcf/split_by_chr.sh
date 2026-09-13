#!/bin/bash
## Split the orignal per-sample (g)vcf by chromosome.
## Usage: bash split_by_chr.sh $chr

# Define your list of names
input_dir=""
out_dir=""
variable_list=($(ls "${input_dir}"/*.vcf | xargs -n1 basename))

# Loop through the list and execute the command for each name
xx=$(($LSB_JOBINDEX - 1))
name=$(echo ${variable_list[$xx]})
mkdir -p "${out_dir}/chr$1"
bcftools view ${input_dir}/$name | grep -P '^(#|(chr){0,'$1'}'$1'\t)' >> ${out_dir}/VCFs/chr$1/$name
