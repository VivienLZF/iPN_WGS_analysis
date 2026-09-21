#!/bin/bash
##############################################################################

## Following merged bed file, perform LD pruning to reduce downstream input size
## Usage: bash LDprune_bed_step1.sh
## Docker: elle72/star:vs4

##############################################################################

Pheno_File=$(echo phenotype.txt)
Sex_File=$(echo sex_info.txt)
Bed_File_Dir=$(echo Plink_Make_Split_Beds)
Chr1_Prefix=$(echo ${Bed_File_Dir}/chr1/chr1_bed)

Merged_File_Prefix=$(echo regenie_step1)
Merge_List=$(echo regenie_step1_List.list)

truncate -s 0 ${Merge_List}

plink --bfile "${Merged_File_Prefix}" \
      --extract "${Merged_File_Prefix}.prune.in" \
      --make-bed \
      --out "${Merged_File_Prefix}_pruned"

echo 'Done'
