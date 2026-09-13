#!/bin/bash
CHR=$(echo $1)
vcf_list=($(ls /storage1/fs1/jin810/Active/testing/vivien/split_vcf/chr${CHR}_chunk*))
xx=${vcf_list[LSB_JOBINDEX-1]}

source_dir="/storage1/fs1/jin810/Active/testing/vivien/sources_of_anno"

/opt/vep/src/ensembl-vep/vep --fasta /storage1/fs1/jin810/Active/References/GRCh38/parabricks_sample/Ref/Homo_sapiens_assembly38.fasta --cache --offline --cache_version 114 --merged --dir_cache ${source_dir} --dir_plugins ${source_dir} -i ${xx} \
  -o /storage1/fs1/jin810/Active/testing/vivien/vep_anno/chr${CHR}/anno_chr${CHR}_${LSB_JOBINDEX} \
  --species homo_sapiens --assembly GRCh38 --use_given_ref --symbol \
  --custom file=${source_dir}/clinvar.vcf.gz,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN \
  --tab --safe \
  --sift b --polyphen b --humdiv --ccds --numbers --domains --regulatory --canonical --protein --biotype --af --af_1kg --max_af --pubmed --uniprot --tsl --appris --variant_class --gene_phenotype \
  --check_existing --nearest symbol --af_gnomadg --af_gnomade --show_ref_allele --total_length --mirna --mane --var_synonyms --gencode_basic --dont_skip --flag_gencode_primary --no_stats \
  --plugin CADD,snv=${source_dir}/whole_genome_SNVs.tsv.gz \
  --plugin AlphaMissense,file=${source_dir}/AlphaMissense_hg38.tsv.gz \
  --plugin LoFtool,${source_dir}/LoFtool_scores.txt \
  --plugin REVEL,file=${source_dir}/new_tabbed_revel_grch38.tsv.gz \
  --plugin SpliceAI,snv=${source_dir}/spliceai_scores.raw.snv.hg38.vcf.gz,indel=${source_dir}/spliceai_scores.raw.indel.hg38.vcf.gz \
  --plugin MaveDB,file=${source_dir}/MaveDB_variants.tsv.gz \
  --plugin Conservation,${source_dir}/gerp_conservation_scores.homo_sapiens.GRCh38.bw,MAX \
  --plugin DosageSensitivity,file=${source_dir}/Collins_rCNV_2022.dosage_sensitivity_scores.tsv.gz \
  --plugin NMD \
  --plugin pLI,${source_dir}/pLI_gene.txt \
  --plugin Enformer,file=${source_dir}/enformer_grch38.vcf.gz,PC=1 \
  --plugin IntAct,mutation_file=${source_dir}/mutations.tsv,mapping_file=${source_dir}/mutation_gc_map.txt.gz,all=1 \
  --plugin PhenotypeOrthologous,file=${source_dir}/PhenotypesOrthologous_homo_sapiens_112_GRCh38.gff3.gz \
  --plugin LOEUF,file=${source_dir}/loeuf_dataset_grch38.tsv.gz,match_by=gene \
  --plugin LoF,loftee_path:${source_dir}/loftee,human_ancestor_fa:${source_dir}/human_ancestor.fa.gz,conservation_file:${source_dir}/phylocsf_gerp.sql \
  --plugin TSSDistance \
  --custom file=${source_dir}/exp_prop_mean.bw,short_name=MeanPEXT,format=bigwig,type=exact \
  --custom file=/storage1/fs1/jin810/Active/testing/vivien/promoterAI/promoterAI_tss500.vcf.gz,short_name=PromoterAI,format=vcf,type=exact,coords=0,fields=promoterAI%promoter_gene%promoter_gene_id%promoter_transcript_id%promoter_strand%promoter_tss_pos

