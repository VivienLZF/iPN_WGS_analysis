Project_Name=$(echo $1)

#VCF_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/VCFs/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_${Project_Name}_afterQC.vcf.gz)
VCF_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/VCFs/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_hwe.vcf.gz)
Bed_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_bed)

#Bed_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/VCFs/chr${LSB_JOBINDEX}/chr${LSB_JOBINDEX}_bed)
#nthreads=$(nproc)
plink --vcf-half-call r --vcf ${VCF_File} --double-id --id-delim ' ' --make-bed --out ${Bed_File}
echo 'Done'
