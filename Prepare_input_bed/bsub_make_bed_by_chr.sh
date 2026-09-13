export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810:/storage1/fs1/jin810'
Project_Name=IPN
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Plink_Make_Split_Beds/${Project_Name} 
for i in $(seq 1 22); do 
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/ANALYSIS/INPUT_FILES/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds/chr$i 
done

bsub -n 1 -M 100GB -g /l.vivien/staar -R "span[ptile=8] select[mem>32GB && tmp>32GB] rusage[mem=10GB]" -G compute-jin810 -q general \
     -J "STAAR-Step0-Plink_Make_Split_Beds_${Project_Name}_[1-22]" \
     -o /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Plink_Make_Split_Beds/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds_${Project_Name}_%J_%I.out \
     -e /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Plink_Make_Split_Beds/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds_${Project_Name}_%J_%I.err \
     -a 'docker(elle72/star:vs4)' \
     bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/${Project_Name}/STAAR-Step0-Plink_Make_Split_Beds/STAAR-Step0-Plink_Make_Split_Beds.sh ${Project_Name}

