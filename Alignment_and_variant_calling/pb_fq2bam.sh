#!/bin/bash
export LSF_DOCKER_VOLUMES="/scratch1/fs1/ris/application/parabricks-license:/opt/parabricks /storage1/fs1/jin810/Active:/storage1/fs1/jin810/Active /scratch1/fs1/jin810:/scratch1/fs1/jin810 $HOME:$HOME"
export PATH="/opt/miniconda/bin:$PATH"
export LSF_DOCKER_NETWORK=host
export LSF_DOCKER_ENTRYPOINT=/bin/sh

PARA_REF="/storage1/fs1/jin810/Active/References/GRCh38/parabricks_sample/Ref/Homo_sapiens_assembly38.fasta"
pKS4="/storage1/fs1/jin810/Active/References/GRCh38/parabricks_sample/Ref/Homo_sapiens_assembly38.known_indels.vcf.gz"

txt_file="/storage1/fs1/jin810/Active/testing/vivien/gatk_test/Carlos/Carlos_585_final.txt"
sample_names=()
while IFS= read -r line; do
    line=$(echo "$line" | sed ''s/[^[:alnum:]-]//g'')
    sample_names+=("$line")
done < "$txt_file"

count=0
current_date=$(date +"%Y%m%d")
jobname="realign"
work_dir="/storage1/fs1/jin810/Active/testing/vivien/gatk_test/Carlos"

fsq_dir="${work_dir}/fq"
out_bams="${work_dir}/realigned_bam"
out_gvcfs="${work_dir}/gvcf"
out_metrics="${work_dir}/metrics"

[ ! -d $out_bams ] && mkdir -p $out_bams
[ ! -d $out_gvcfs ] && mkdir -p $out_gvcfs
[ ! -d $out_metrics ] && mkdir -p $out_metrics
log_dir="${work_dir}/log/realign"
[ ! -d $log_dir ] && mkdir -p $log_dir

for sample_name in "${sample_names[@]}"; do
    fastq_r1="${fsq_dir}/${sample_name}_R1.fastq.gz"
    fastq_r2="${fsq_dir}/${sample_name}_R2.fastq.gz"
    out_bam="${out_bams}/${sample_name}.bam"
    out_gvcf="${out_gvcfs}/${sample_name}.g.vcf"
    out_recal="${out_metrics}/${sample_name}.report.txt"
    out_duplicate_metrics="${out_metrics}/${sample_name}.dup_metrics.txt"
    
    if [ ! -f "${out_bams}/${sample_name}.bam" ]; then
        RGTAG="@RG\tID:${sample_name}\tLB:lib1\tPL:Illumina\tSM:${sample_name}\tPU:${sample_name}"
        mkdir -p "${work_dir}/BAM/TMP/${sample_name}"
        
        bsub -g /l.vivien/staar -o "${log_dir}/%J_${sample_name}.out" -e "${log_dir}/%J_${sample_name}.err" -M 500GB -R 'gpuhost rusage[mem=350GB, tmp=40GB]' -G compute-jin810 -q general -gpu "num=2:j_exclusive=no" -a 'docker(nvcr.io/nvidia/clara/clara-parabricks:4.0.0-1)' TMPDIR="${work_dir}/BAM/TMP/${sample_name}" pbrun germline --ref "${PARA_REF}" \
            --in-fq "${fastq_r1}" "${fastq_r2}" "${RGTAG}" \
            --knownSites "${pKS4}" \
            --out-bam "${out_bam}" \
            --out-variants "${out_gvcf}" \
            --out-recal-file "${out_recal}" \
            --out-duplicate-metrics "${out_duplicate_metrics}" \
            --bwa-options='-Y -K 100000000' \
            --static-quantized-quals 10 \
            --static-quantized-quals 20 \
            --static-quantized-quals 30 \
            --gvcf \
            --num-gpus 2 \
            --tmp-dir "${work_dir}/BAM/TMP/${sample_name}"
    else
        echo "Skipping ${sample_name} as .bam and .g.vcf files already exist."
        count=$((count+1))
    fi
done
echo "Number of samples already processed: ${count}"
