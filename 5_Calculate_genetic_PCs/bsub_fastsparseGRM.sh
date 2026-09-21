export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810:/storage1/fs1/jin810'
Project_Name=IPN
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step4-FastSparseGRM/${Project_Name} 
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step4-FastSparseGRM

bsub -n 1 -M 1000GB -g /l.vivien/staar -R "select[mem>32GB && tmp>32GB] rusage[mem=100GB]" -G compute-jin810 -q general \
     -J "STAAR-Step4-FastSparseGRM_${Project_Name}" \
     -o /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step4-FastSparseGRM/${Project_Name}/STAAR-Step4-FastSparseGRM_${Project_Name}_%J.out \
     -e /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step4-FastSparseGRM/${Project_Name}/STAAR-Step4-FastSparseGRM_${Project_Name}_%J.err \
     -a 'docker(elle72/star:vs4)' \
     bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/${Project_Name}/STAAR-Step4-FastSparseGRM/STAAR-Step4-FastSparseGRM.sh ${Project_Name}
