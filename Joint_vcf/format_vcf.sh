#!/bin/bash
##############################################################################

## From joint bcf, generate joint vcf (by chr) and format: splits multiallelic sites into biallelic records
## Usage: bash format_vcf.sh ${Project_Name} ${BCF_Input_Path}
# ${Project_Name} is specified as "IPN" for this project
## Docker: elle72/basic:vs4

##############################################################################

Project_Name=$(echo $1)
BCF_Input_Path=$(find ${2}/chr${LSB_JOBINDEX} -name '*bcf')
VCF_Output_Path=$(echo VCFs/chr${LSB_JOBINDEX})
VCF_File_Path=$(echo ${VCF_Output_Path}/chr${LSB_JOBINDEX}_${Project_Name}.vcf)
GZVCF_File_Path=$(echo ${VCF_Output_Path}/chr${LSB_JOBINDEX}_${Project_Name}.vcf.gz)
TMP_VCF_File_Path=$(echo ${VCF_Output_Path}/TEMP_chr${LSB_JOBINDEX}_${Project_Name}.vcf)
CONV_File_Path=$(echo ${VCF_Output_Path}/chr${LSB_JOBINDEX}_${Project_Name}_conv.txt)
Anno_File_Prefix=$(echo ${VCF_Output_Path}/Anno_chr${LSB_JOBINDEX}_${Project_Name})

mkdir -p $VCF_Output_Path
nthreads=$(nproc)
bcftools norm --threads ${nthreads} -m-any ${BCF_Input_Path} -Ov -o ${VCF_File_Path}
echo "chr${LSB_JOBINDEX} ${LSB_JOBINDEX}" > ${CONV_File_Path}
## Need to shorten Variant ID because plink runs out of memory if id is too long (over 80 chars)

bcftools query -f '%CHROM\t%POS\t%REF\t%FIRST_ALT\n' ${VCF_File_Path} | awk 'BEGIN {FS="\t"; OFS="\t"} {print $1, $2, $1"-"$2"-vP:"NR, $3, $4}' |sed -e 's+\tchr+\t+g' > ${Anno_File_Prefix}.tsv
bgzip ${Anno_File_Prefix}.tsv
tabix -s 1 -b 2 -e 2 ${Anno_File_Prefix}.tsv.gz 
bcftools annotate --threads ${nthreads} -a ${Anno_File_Prefix}.tsv.gz -c CHROM,POS,ID,REF,ALT --rename-chrs ${CONV_File_Path} ${VCF_File_Path} -Ov -o ${TMP_VCF_File_Path}

bcftools +fill-tags ${TMP_VCF_File_Path} -Oz -o ${GZVCF_File_Path} -- -t AF,AN,AC
rm ${TMP_VCF_File_Path}
bcftools index --threads ${nthreads} ${GZVCF_File_Path} -o ${GZVCF_File_Path}.tbi
