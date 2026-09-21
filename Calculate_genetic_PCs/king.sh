#!/bin/bash
##############################################################################

## kinship check
## Usage: bash king.sh
## Docker: elle72/star:vs4

##############################################################################

Merged_File_Prefix=$(echo regenie_step1_pruned)
King_File_Prefix=$(echo King/King)

king -b ${Merged_File_Prefix}.bed --ibdseg  --prefix ${King_File_Prefix}
