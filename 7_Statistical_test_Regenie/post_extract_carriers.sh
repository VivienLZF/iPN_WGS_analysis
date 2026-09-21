#!/bin/bash
##############################################################################

## The purpose is to extract variant carrier IDs
## Extract vcf lines for variants included in regenie step2 (variant-based) output
## Usage: bash post_extract_carriers.sh
## Docker: staphb/bcftools:latest

##############################################################################


work_dir=""
TXT="${work_dir}/test_bin_out_firth_DIAGNOSIS.regenie"
VCF_DIR="VCFs"
OUTPUT_FILE="${work_dir}/carrier_vcf.txt"
TEMP_DIR=$(mktemp -d)

# Use chr1 VCF to get only the #CHROM header line
HEADER_SOURCE="${VCF_DIR}/chr1/chr1_hwe.vcf.gz"
if [[ -f "$HEADER_SOURCE" ]]; then
    zgrep -m1 "^#CHROM" "$HEADER_SOURCE" > "$OUTPUT_FILE"
else
    echo "Error: Header source VCF not found at $HEADER_SOURCE" >&2
    exit 1
fi

# Make a master BED with CHROM, POS-1, POS for all variants
BED_FILE="${TEMP_DIR}/variants.bed"
awk -F' ' '{
    chr=$1;
    pos=$2;
    if(chr ~ /^[0-9XY]+$/ && pos ~ /^[0-9]+$/) {print chr"\t"(pos-1)"\t"pos}
}' "$TXT" > "$BED_FILE"

# For each chromosome, create a BED and extract
cut -f1 "$BED_FILE" | sort -u | while read CHR; do
    CHR_BED="${TEMP_DIR}/chr${CHR}.bed"
    awk -v chr="$CHR" '$1==chr' "$BED_FILE" > "$CHR_BED"
    VCF_FILE="${VCF_DIR}/chr${CHR}/chr${CHR}_hwe.vcf.gz"

    if [[ -f "$VCF_FILE" ]]; then
        echo "Extracting from: $VCF_FILE using $CHR_BED"
        bcftools view -R "$CHR_BED" "$VCF_FILE" --no-header >> "$OUTPUT_FILE"
    else
        echo "Warning: VCF file not found for chr${CHR}" >&2
    fi
done

# Clean up
rm -r "$TEMP_DIR"