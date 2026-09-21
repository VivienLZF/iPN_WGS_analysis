#!/bin/bash
##############################################################################

## Make bed file from filtered vcf split by chr
## Usage: bash make_bed_by_chr.sh
## Submit job array with index 1-22
## Docker: elle72/star:vs4

##############################################################################

VCF_File=$(echo /VCFs/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_hwe.vcf.gz)
Bed_File=$(echo Plink_Make_Split_Beds/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_bed)

plink --vcf-half-call r --vcf ${VCF_File} --double-id --id-delim ' ' --make-bed --out ${Bed_File}
