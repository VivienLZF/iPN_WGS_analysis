# iPN_WGS_analysis

This repository contains the scripts used for whole-genome sequencing-based rare variant association analysis of idiopathic peripheral neuropathy (iPN), from raw sequence alignment through variant calling, quality control, annotation, and gene-based association testing with Regenie. It will also include scripts for a replication analysis in the All of Us Research Program.

> **Citation:** (manuscript in preparation) Genomic and Functional Analyses Uncover Coding and Regulatory Variation Contributing to Idiopathic Peripheral Neuropathy

## Repository structure

The folders are numbered in the order they are run. Each step uses the output of the previous one.

| Step | Folder | Purpose |
|------|--------|---------|
| 1 | `1_Alignment_and_variant_calling/` | Align reads to the reference genome (GRCh38) and call variants per sample|
| 2 | `2_Joint_vcf/` | Combine per-sample calls into a joint-called multi-sample VCF |
| 3 | `3_Variant_QC_filters/` | Apply genotype- and variant-level QC filters |
| 4 | `4_Prepare_input_bed/` | Convert the filtered VCF into PLINK BED/BIM/FAM files for downstream analyses |
| 5 | `5_Calculate_genetic_PCs/` | Compute genetic principal components to use as covariates for population structure |
| 6 | `6_Variant_annotation_VEP/` | Annotate variants with Ensembl VEP and extract damaging variants |
| 7 | `7_Statistical_test_Regenie/` | Run Regenie step 1 (whole-genome regression) and step 2 (single-variant and/or gene-based burden tests) |
| – | `Replication analysis in All of Us/` | Replicate the main findings in All of Us data within the Researcher Workbench |

## Contact

Zefan Li (l.vivien@wustl.edu)
