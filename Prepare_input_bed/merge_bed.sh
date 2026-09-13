Project_Name=$(echo $1)

Pheno_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/phenotype_info/${Project_Name}_phenotype.txt)
Sex_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/phenotype_info/${Project_Name}_sex_info.txt)
Bed_File_Dir=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds)
Chr1_Prefix=$(echo ${Bed_File_Dir}/chr1/chr1_bed)

Merged_File_Prefix=$(echo /storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test/regenie/step1LD4)
Merge_List=$(echo /storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test/regenie/step1_List.list)

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
  #--remove Carlos_nonwhite.txt
#plink --bfile "${Merged_File_Prefix}_temp" --make-bed --out "${Merged_File_Prefix}" --covar ${Pheno_File} --covar-name AGE,DIAGNOSIS

#rm "${Merged_File_Prefix}_temp"*

echo 'Done'
