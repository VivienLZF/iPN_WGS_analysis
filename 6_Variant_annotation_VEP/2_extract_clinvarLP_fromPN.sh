#!/bin/bash
##############################################################################

## Following step 1, extract all Clinvar P/LP variants of PN-associated genes
## Usage: bash extract_clinvarLP_fromPN.sh

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
  
  cln = F[hdr["ClinVar_CLNSIG"]]
  rev = F[hdr["ClinVar_CLNREVSTAT"]]
  
  canonical = F[hdr["CANONICAL"]]

  # Ignore if SYMBOL is missing
  if (symbol == "-") next
  # only look at canonical transcript
  if (canonical != "YES") next
  criteria_met = 0

  # keep ClinVar pathogenic variants
  if (cln == "Pathogenic" || cln == "Likely_pathogenic" || cln == "Pathogenic/Likely_pathogenic") criteria_met = 1

  if (criteria_met) print $0
}
' ${all_PN} > ${work_dir}/PN_clinvarP.txt
