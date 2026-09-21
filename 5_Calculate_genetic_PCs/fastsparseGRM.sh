#!/bin/bash
##############################################################################

## FastSparseGRM to run PCA and get genetic PCs for each sample, as covariates for regression
## Reference: https://github.com/rounakdey/FastSparseGRM
## Usage: bash fastsparseGRM.sh
## Docker: elle72/star:vs4

##############################################################################

Merged_File_Prefix=$(echo regenie_step1_pruned)
#King.seg  King.segments.gz  Kingallsegs.txt
King_File_Prefix=$(echo King/King)

R_HOME='/usr/local/R-3.6.1p/lib/R'
R_LIBS='/usr/local/R-3.6.1p/lib/R/library'
export R_MAX_MEM_SIZE=1000000000
TMPDIR=$(echo TMP/)
mkdir -p ${TMPDIR}

getDivergence_Wapper=$(echo FastSparseGRM/extdata/getDivergence_wrapper.R)
getDivergence_Output=$(echo FastSparseGRM/getDivergence.Rout)
getDivergence_Prefix=$(echo FastSparseGRM/$divergence)
echo 'getDivergence'
R CMD BATCH --vanilla  --max-mem-size=100G "--args --prefix.in ${Merged_File_Prefix} --file.seg ${King_File_Prefix}.seg --num_threads 16  --prefix.out ${getDivergence_Prefix}" ${getDivergence_Wapper} ${getDivergence_Output}

extractUnrelated_Wrapper=$(echo FastSparseGRM/extdata/extractUnrelated_wrapper.R)
extractUnrelated_Output=$(echo FastSparseGRM/extractUnrelated.Rout)
extractUnrelated_Prefix=$(echo FastSparseGRM/$unrelated)
echo 'extractUnrelated'
R CMD BATCH --vanilla  --max-mem-size=100G "--args --prefix.in ${Merged_File_Prefix} --file.seg ${King_File_Prefix}.seg --degree 4 --file.div ${getDivergence_Prefix}.div --prefix.out ${extractUnrelated_Prefix}" ${extractUnrelated_Wrapper} ${extractUnrelated_Output}

runPCA_Wrapper=$(echo FastSparseGRM/extdata/runPCA_wrapper.R)
runPCA_Output=$(echo FastSparseGRM/runPCA.Rout)
runPCA_Prefix=$(echo FastSparseGRM/$pca)
echo 'runPCA'

R CMD BATCH --vanilla  --max-mem-size=1000G "--args --prefix.in ${Merged_File_Prefix} --file.unrels ${extractUnrelated_Prefix}.unrels --prefix.out ${runPCA_Prefix}" ${runPCA_Wrapper} ${runPCA_Output}

calcSparseGRM_Wrapper=$(echo FastSparseGRM/extdata/calcSparseGRM_wrapper.R)
calcSparseGRM_Output=$(echo FastSparseGRM/calcSparseGRM.Rout)
calcSparseGRM_Prefix=$(echo FastSparseGRM/$sparseGRM)
echo 'calcSparseGRM'
R CMD BATCH --vanilla  --max-mem-size=1000G "--args --prefix.in ${Merged_File_Prefix} --prefix.out ${calcSparseGRM_Prefix} --file.train ${extractUnrelated_Prefix}.unrels --file.score ${runPCA_Prefix}.score --file.seg ${King_File_Prefix}.seg --num_threads 16" ${calcSparseGRM_Wrapper} ${calcSparseGRM_Output}


echo 'Making new phenotype file...'
Pheno_File=$(echo phenotype.txt)
Sex_File=$(echo sex_info.txt)
Pheno=$(echo phenotype.txt)
new_Pheno_File=$(echo FastSparseGRM/$pheno_pca.csv)

echo 'Making new phenotype file...'

echo 'ID,DIAGNOSIS,SEX,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10'> ${new_Pheno_File}

awk 'BEGIN {FS=" "; OFS="\t"} NR==FNR{a[$1]=$1"\t"$2"\t"$3"\t"$4; next} ($1 in a) {print a[$1] $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' ${Pheno} "${runPCA_Prefix}.score" | sed -e 's+\t+,+g' >> ${new_Pheno_File}

echo 'DONE!'