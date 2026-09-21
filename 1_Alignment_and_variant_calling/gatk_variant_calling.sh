#!/bin/bash
##############################################################################

# Use GATK HaplotypeCaller to call variants from all bam files in /bam, excluding low-quality reads with excessive softclip.
# Skip samples with gvcf already generated in out_dir.
## Docker: broadinstitute/gatk:latest

##############################################################################

export LSF_DOCKER_VOLUMES=""

REF="Homo_sapiens_assembly38.fasta"
work_dir=""
bam_dir="${work_dir}/bam"
sample_names=($(ls ${bam_dir}/*.bam | sed -e 's#.*/##' -e 's#\.bam##'))

count=0
gvcf_dir="${work_dir}/gvcf"
[ ! -d $gvcf_dir ] && mkdir -p $gvcf_dir

for sample_name in "${sample_names[@]}"; do
    in_bam="${bam_dir}/${sample_name}.bam"
    out_gvcf="${gvcf_dir}/${sample_name}.g.vcf"
    if [ ! -f "${out_gvcf}" ]; then
    	/gatk/gatk HaplotypeCaller --reference "${REF}" \
            --input "${in_bam}" \
	    --java-options -Xmx30g \
            --output "${out_gvcf}" \
            -ERC GVCF \
            --native-pair-hmm-threads 4 \
	    --read-filter SoftClippedReadFilter --max-soft-clipped-ratio 0.2

    	count=$((count+1))
    else
        echo "Skipping ${sample_name} as .g.vcf files already exist."
    fi
done
echo "Number of samples to process: ${count}"
