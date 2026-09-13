#!/bin/bash
all_CMT="/storage1/fs1/jin810/Active/testing/vivien/vep_anno/CMT_variants_with_header.txt"
work_dir="/storage1/fs1/jin810/Active/testing/vivien/vep_anno"

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
  
  impact = F[hdr["IMPACT"]]
  cln = F[hdr["ClinVar_CLNSIG"]]
  rev = F[hdr["ClinVar_CLNREVSTAT"]]
  
  canonical = F[hdr["CANONICAL"]]
  lof_filter = F[hdr["LoF"]]

  # Ignore if SYMBOL or MAX_AF is missing or is pesudogene
  if (symbol == "-" || max_af == "-" || biotype ~ /pseudogene/) next
  # only look at canonical transcript
  if (canonical != "YES") next
  criteria_met = 0

  # keep ClinVar pathogenic variants
  if (cln == "Pathogenic" || cln == "Likely_pathogenic" || cln == "Pathogenic/Likely_pathogenic") criteria_met = 1

  if (criteria_met) print $0
}
' ${all_CMT} > ${work_dir}/CMT_clinvarP.txt