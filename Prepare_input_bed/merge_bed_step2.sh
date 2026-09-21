#!/bin/bash
##############################################################################

## Merge chr-specific bed files for regenie step2, update sex and phenotype info, including all genotype info
## Usage: bash merge_bed_step2.sh
## Docker: elle72/star:vs4

##############################################################################

Pheno_File=$(echo phenotype.txt)
Sex_File=$(echo sex_info.txt)
Bed_File_Dir=$(echo Plink_Make_Split_Beds)
Chr1_Prefix=$(echo ${Bed_File_Dir}/chr1/chr1_bed)

Merged_File_Prefix=$(echo regenie_step2)
Merge_List=$(echo regenie_step2_List.list)

truncate -s 0 ${Merge_List}

for i in $(seq 2 22); do
echo ${Bed_File_Dir}/chr${i}/chr${i}_bed >> ${Merge_List}
done

plink --bfile ${Chr1_Prefix} --merge-list ${Merge_List}  --make-bed --out "${Merged_File_Prefix}" \
  --pheno ${Pheno_File} --update-sex ${Sex_File} --mind 0.5 --hwe 0.000001 include-nonctrl

echo 'Done'
