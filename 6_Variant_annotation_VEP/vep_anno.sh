#!/bin/bash
##############################################################################

## Use VEP to annotate variants
## May split vcf by chunk to parallel jobs
## Need download sources of annotations to run with local cache
## Usage: bash vep_anno.sh
## Docker: lvivien/vep_samtools:v1.0

##############################################################################

CHR=$(echo $1)
vcf_list=($(ls split_vcf/chr${CHR}_chunk*))
xx=${vcf_list[LSB_JOBINDEX-1]}

source_dir="sources_of_anno"

/opt/vep/src/ensembl-vep/vep --fasta Homo_sapiens_assembly38.fasta --cache --offline --cache_version 114 --merged --dir_cache ${source_dir} --dir_plugins ${source_dir} -i ${xx} \
  -o vep_anno/chr${CHR}/anno_chr${CHR}_${LSB_JOBINDEX} \
  --species homo_sapiens --assembly GRCh38 --use_given_ref --symbol \
  --custom file=${source_dir}/clinvar.vcf.gz,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN \
  --tab --safe \
  --sift b --polyphen b --humdiv --ccds --numbers --domains --regulatory --canonical --protein --biotype --af --af_1kg --max_af --pubmed --uniprot --tsl --appris --variant_class --gene_phenotype \
  --check_existing --nearest symbol --af_gnomadg --af_gnomade --show_ref_allele --total_length --mirna --mane --var_synonyms --gencode_basic --dont_skip --flag_gencode_primary --no_stats \
  --plugin CADD,snv=${source_dir}/whole_genome_SNVs.tsv.gz \
  --plugin AlphaMissense,file=${source_dir}/AlphaMissense_hg38.tsv.gz \
  --plugin REVEL,file=${source_dir}/new_tabbed_revel_grch38.tsv.gz \
  --plugin SpliceAI,snv=${source_dir}/spliceai_scores.raw.snv.hg38.vcf.gz,indel=${source_dir}/spliceai_scores.raw.indel.hg38.vcf.gz \
  --plugin pLI,${source_dir}/pLI_gene.txt \
  --plugin LOEUF,file=${source_dir}/loeuf_dataset_grch38.tsv.gz,match_by=gene \
  --plugin LoF,loftee_path:${source_dir}/loftee,human_ancestor_fa:${source_dir}/human_ancestor.fa.gz,conservation_file:${source_dir}/phylocsf_gerp.sql \
  --plugin TSSDistance \
  --custom file=/promoterAI/promoterAI_tss500.vcf.gz,short_name=PromoterAI,format=vcf,type=exact,coords=0,fields=promoterAI%promoter_gene%promoter_gene_id%promoter_transcript_id%promoter_strand%promoter_tss_pos

