grep "#Uploaded" chr1/anno_chr1_1 > CMT_variants_with_header.txt
awk 'NR==FNR {cmt[$1]; next} !/^#/ && ($20 in cmt)' /storage1/fs1/jin810/Active/testing/vivien/IPN_storage2/Invitae_OMIM_165.txt chr*/anno_chr* >> CMT_variants_with_header.txt
