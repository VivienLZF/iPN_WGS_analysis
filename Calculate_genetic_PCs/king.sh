Project_Name=$(echo $1)
Merged_File_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Merge_Split_Beds/Merged_${Project_Name}_pruned)
King_File_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-King/King_${Project_Name})

king -b ${Merged_File_Prefix}.bed --ibdseg  --prefix ${King_File_Prefix}
