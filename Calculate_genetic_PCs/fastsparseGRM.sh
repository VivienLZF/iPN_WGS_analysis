Project_Name=$(echo $1)

Merged_File_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Merge_Split_Beds/Merged_${Project_Name}_pruned)
#King_IPN.seg  King_IPN.segments.gz  King_IPNallsegs.txt
King_File_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-King/King_${Project_Name})

R_HOME='/usr/local/R-3.6.1p/lib/R'
R_LIBS='/usr/local/R-3.6.1p/lib/R/library'
#export R_MAX_MEM_SIZE=10000000
export R_MAX_MEM_SIZE=1000000000
TMPDIR=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Merge_Split_Beds/TMP/)
mkdir -p ${TMPDIR}

getDivergence_Wapper=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/FastSparseGRM/extdata/getDivergence_wrapper.R)
getDivergence_Output=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/getDivergence.Rout)
getDivergence_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/${Project_Name}.divergence)
echo 'getDivergence'
R CMD BATCH --vanilla  --max-mem-size=100G "--args --prefix.in ${Merged_File_Prefix} --file.seg ${King_File_Prefix}.seg --num_threads 16  --prefix.out ${getDivergence_Prefix}" ${getDivergence_Wapper} ${getDivergence_Output}

extractUnrelated_Wrapper=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/FastSparseGRM/extdata/extractUnrelated_wrapper.R)
extractUnrelated_Output=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/extractUnrelated.Rout)
extractUnrelated_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/${Project_Name}.unrelated)
echo 'extractUnrelated'
R CMD BATCH --vanilla  --max-mem-size=100G "--args --prefix.in ${Merged_File_Prefix} --file.seg ${King_File_Prefix}.seg --degree 4 --file.div ${getDivergence_Prefix}.div --prefix.out ${extractUnrelated_Prefix}" ${extractUnrelated_Wrapper} ${extractUnrelated_Output}

runPCA_Wrapper=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/FastSparseGRM/extdata/runPCA_wrapper.R)
runPCA_Output=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/runPCA.Rout)
runPCA_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/${Project_Name}.pca)
echo 'runPCA'
#nThreads=nproc
#R CMD BATCH --vanilla  --max-mem-size=1000G "--args --prefix.in ${Merged_File_Prefix} --file.unrels ${extractUnrelated_Prefix}.unrels --num_threads 32 --prefix.out ${runPCA_Prefix}" ${runPCA_Wrapper} ${runPCA_Output}
R CMD BATCH --vanilla  --max-mem-size=1000G "--args --prefix.in ${Merged_File_Prefix} --file.unrels ${extractUnrelated_Prefix}.unrels --prefix.out ${runPCA_Prefix}" ${runPCA_Wrapper} ${runPCA_Output}

calcSparseGRM_Wrapper=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/FastSparseGRM/extdata/calcSparseGRM_wrapper.R)
calcSparseGRM_Output=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/calcSparseGRM.Rout)
calcSparseGRM_Prefix=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/${Project_Name}.sparseGRM)
echo 'calcSparseGRM'
R CMD BATCH --vanilla  --max-mem-size=1000G "--args --prefix.in ${Merged_File_Prefix} --prefix.out ${calcSparseGRM_Prefix} --file.train ${extractUnrelated_Prefix}.unrels --file.score ${runPCA_Prefix}.score --file.seg ${King_File_Prefix}.seg --num_threads 16" ${calcSparseGRM_Wrapper} ${calcSparseGRM_Output}


echo 'Making new phenotype file...'
STAAR_Pheno_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/phenotype_info/${Project_Name}_phenotype.txt)
STAAR_Sex_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/phenotype_info/${Project_Name}_sex_info.txt)
STAAR_Step4_Pheno=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/phenotype_info/${Project_Name}_step4_phenotype.txt)
new_Pheno_File=$(echo /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM/${Project_Name}.pheno_pca.csv)

echo 'Making new phenotype file...'

#join pheno and sex file, only need run once
#awk 'BEGIN {OFS="\t"}
#NR==FNR {sex[$2]=$3; next}
#FNR==1 {print "ID", "DIAGNOSIS", "SEX"}
#FNR>1 {if ($2 in sex) print $2, $3, sex[$2]}' ${STAAR_Sex_File} ${STAAR_Pheno_File} > ${STAAR_Step4_Pheno}

echo 'ID,DIAGNOSIS,SEX,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10'> ${new_Pheno_File}

awk 'BEGIN {FS=" "; OFS="\t"} NR==FNR{a[$1]=$1"\t"$2"\t"$3"\t"$4; next} ($1 in a) {print a[$1] $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' ${STAAR_Step4_Pheno} "${runPCA_Prefix}.score" | sed -e 's+\t+,+g' >> ${new_Pheno_File}

echo 'DONE!'