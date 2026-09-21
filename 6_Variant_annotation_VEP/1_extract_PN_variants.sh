#!/bin/bash
##############################################################################

## Extract all variants of PN-associated genes in a predefined list: PN_genes.txt
## Usage: bash extract_PN_variants.sh

##############################################################################

grep "#Uploaded" chr1/anno_chr1_1 > PN_variants.txt
awk 'NR==FNR {cmt[$1]; next} !/^#/ && ($20 in cmt)' PN_genes.txt chr*/anno_chr* >> PN_variants.txt
