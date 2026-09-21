#!/bin/bash
##############################################################################

## Following step 1, extract all damaging variants of PN-associated genes
## Including loss-of-function and damaging missense predicted by AlphaMissense
## Usage: bash extract_damaging_fromPN.sh

##############################################################################

all_PN="PN_variants.txt"
work_dir=""

awk -F'\t' '
BEGIN { OFS = "\t" }
/^##/ { next }
/^#Uploaded_variation/ {
  sub(/^#/, "", $0)
  split($0, H, FS)
  for (i = 1; i <= length(H); i++) hdr[H[i]] = i
  next
}
{
  split($0, F, FS)
  symbol = F[hdr["SYMBOL"]]
  max_af = F[hdr["MAX_AF"]]
  max_af_pops = F[hdr["MAX_AF_POPS"]]
  afr_af = F[hdr["AFR_AF"]]
  amr_af = F[hdr["AMR_AF"]]
  eas_af = F[hdr["EAS_AF"]]
  eur_af = F[hdr["EUR_AF"]]
  sas_af = F[hdr["SAS_AF"]]
  afr_afe = F[hdr["gnomADe_AFR_AF"]]
  amr_afe = F[hdr["gnomADe_AMR_AF"]]
  eas_afe = F[hdr["gnomADe_EAS_AF"]]
  eur_afe = F[hdr["gnomADe_NFE_AF"]]
  sas_afe = F[hdr["gnomADe_SAS_AF"]]
  afr_afg = F[hdr["gnomADg_AFR_AF"]]
  amr_afg = F[hdr["gnomADg_AMR_AF"]]
  eas_afg = F[hdr["gnomADg_EAS_AF"]]
  eur_afg = F[hdr["gnomADg_NFE_AF"]]
  sas_afg = F[hdr["gnomADg_SAS_AF"]]
  impact = F[hdr["IMPACT"]]
  cln = F[hdr["ClinVar_CLNSIG"]]
  rev = F[hdr["ClinVar_CLNREVSTAT"]]
  spliceai = F[hdr["SpliceAI_pred"]]
  am_class = F[hdr["am_class"]]
  biotype = F[hdr["BIOTYPE"]]
  consequence = F[hdr["Consequence"]]
  canonical = F[hdr["CANONICAL"]]
  lof_filter = F[hdr["LoF"]]

  # Ignore if SYMBOL or MAX_AF is missing or is pesudogene
  if (symbol == "-" || max_af == "-" || biotype ~ /pseudogene/) next
  # only look at canonical transcript
  if (canonical != "YES") next

  maf_value = max_af + 0
  afr_value = afr_af + 0
  amr_value = amr_af + 0
  eas_value = eas_af + 0
  eur_value = eur_af + 0
  sas_value = sas_af + 0

  afre_value = afr_afe + 0
  amre_value = amr_afe + 0
  ease_value = eas_afe + 0
  eure_value = eur_afe + 0
  sase_value = sas_afe + 0

  afrg_value = afr_afg + 0
  amrg_value = amr_afg + 0
  easg_value = eas_afg + 0
  eurg_value = eur_afg + 0
  sasg_value = sas_afg + 0

  # filter out variants with maf_value > 0.005 in any of 5 major populations in 1KG or gnomAD)
  if (afr_value > 0.005 || amr_value > 0.005 || eas_value > 0.005 || eur_value > 0.005 || sas_value > 0.005) next
  if (afre_value > 0.005 || amre_value > 0.005 || ease_value > 0.005 || eure_value > 0.005 || sase_value > 0.005) next
  if (afrg_value > 0.005 || amrg_value > 0.005 || easg_value > 0.005 || eurg_value > 0.005 || sasg_value > 0.005) next

  # remove high-confidence clinvar benign variants:
  if ((cln == "Benign" || cln == "Likely_benign" || cln == "Benign/Likely_benign") && (rev == "criteria_provided,_multiple_submitters,_no_conflicts" || rev == "reviewed_by_expert_panel")) next

  criteria_met = 0

  # keep HIGH IMPACT variations unless noncoding, or high-confidence LoF variants
  if (impact == "HIGH" && consequence !~ /non_coding_transcript/ && lof_filter !="LC") criteria_met = 1
  else if (lof_filter =="HC") criteria_met = 1

  # keep variants with SpliceAI score > 0.8
  else if (spliceai != "-") {
    n = split(spliceai, sa_fields, "|")
    if (n >= 5) {
      for (i = 2; i <= 5; i++) {
        if (sa_fields[i] != "-" && sa_fields[i] + 0 >= 0.8) {
          criteria_met = 1
          break
        }
      }
    }
  }

  # In silico prediction: AlphaMissense
    count = 0
    if (am_class == "likely_pathogenic") count++
    if (count >= 1) criteria_met = 1

  if (criteria_met) print $0
}
' ${all_PN} > ${work_dir}/PN_damaging.txt