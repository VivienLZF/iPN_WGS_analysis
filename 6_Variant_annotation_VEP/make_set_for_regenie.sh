#!/bin/bash
##############################################################################

## Prepare damaging variant set to test for regenie
## Regenie step2 input files: unique_LP_IDs.txt, merged_masks.txt, anno_merged_input.txt, inclusion_sets.txt
## Usage: bash make_set_for_regenie.sh

##############################################################################

anno_dir="vep_anno"
cut -f1,20 ${anno_dir}/PN_damaging.txt | sort -u > ${anno_dir}/unique_LP_IDandSYMBOL.txt
cut -f1 ${anno_dir}/unique_LP_IDandSYMBOL.txt | sort -u > ${anno_dir}/unique_LP_IDs.txt

awk -F '\t' '
{
    gene = $2
    # Extract chr and pos from first column without split()
    match($1, /^([0-9XYMT]+)-([0-9]+)/, a)
    chr = a[1]
    pos = a[2]

    if (!(gene in first_pos)) {
        first_pos[gene] = pos
        chr_map[gene] = chr
    }
    if (gene in vars)
        vars[gene] = vars[gene] "," $1
    else
        vars[gene] = $1
}
END {
    for (g in vars)
        print g, chr_map[g], first_pos[g], vars[g]
}
' OFS='\t' ${anno_dir}/unique_LP_IDandSYMBOL.txt > temp.txt

awk -F'\t' '$1 != "-" && split($4, a, ",") >= 1' temp.txt > ${anno_dir}/merged_masks.txt
rm temp.txt

awk '$2 != "-" {print $0, "LP"}' ${anno_dir}/unique_LP_IDandSYMBOL.txt > ${anno_dir}/anno_merged_input.txt

cut -f1 ${anno_dir}/merged_masks.txt > ${anno_dir}/inclusion_sets.txt