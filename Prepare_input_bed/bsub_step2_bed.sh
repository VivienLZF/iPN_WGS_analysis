export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810:/storage1/fs1/jin810 /storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test:/storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test'
Project_Name=IPN
#mkdir -p /storage2/fs1/epigenome/Active/shared_smaht/TEST_RUN_FOLDER/vivien_test/regenie/log
#mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Plink_Merge_Split_Beds/${Project_Name} 
#mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Merge_Split_Beds
workdir="/storage1/fs1/jin810/Active/testing/vivien/regenie/bed_code"

bsub -n 1 -M 500GB -g /l.vivien/staar -R "span[ptile=8] select[mem>32GB && tmp>32GB] rusage[mem=100GB]" -G compute-jin810 -q general \
     -J "step2_bed_regenie" \
     -o ${workdir}/step2_bed_%J.out \
     -e ${workdir}/step2_bed_%J.err \
     -a 'docker(elle72/star:vs4)' \
     bash ${workdir}/step2_bed.sh ${Project_Name}