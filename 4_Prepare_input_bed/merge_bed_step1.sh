#!/bin/bash
##############################################################################

## Merge chr-specific bed files for regenie step1 and PC calculation, update sex and phenotype info
## Keep only high-quality common SNPs, remove samples with excess genotype missing, and prepare for LD pruning
## Usage: bash merge_bed_step1.sh
## Docker: elle72/star:vs4

##############################################################################

Pheno_File=$(echo phenotype.txt)
Sex_File=$(echo sex_info.txt)
Bed_File_Dir=$(echo Plink_Make_Split_Beds)
Chr1_Prefix=$(echo ${Bed_File_Dir}/chr1/chr1_bed)

Merged_File_Prefix=$(echo regenie_step1)
Merge_List=$(echo regenie_step1_List.list)

truncate -s 0 ${Merge_List}

for i in $(seq 2 22); do
echo ${Bed_File_Dir}/chr${i}/chr${i}_bed >> ${Merge_List}
done
## MAC and MAF added because of fastsparsegrm PCA limit
plink --bfile ${Chr1_Prefix} \
  --merge-list ${Merge_List} \
  --make-bed --out "${Merged_File_Prefix}" \
  --pheno ${Pheno_File} \
  --update-sex ${Sex_File} \
  --maf 0.05 --mac 5 \
  --mind 0.5 --geno 0.02 \
  --snps-only \
  --hwe 0.000001 include-nonctrl \
  --indep-pairwise 200 20 0.4

echo 'Done'
