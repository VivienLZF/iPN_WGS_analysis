# Submit IPN vcf format jobs for each interval in parallel
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810:/storage1/fs1/jin810'
Project_Name=IPN
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Format_Vcfs/${Project_Name} /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/INPUT_FILES/${Project_Name}/VCFs
bsub -n 4 -g /l.vivien/staar -R "span[hosts=1] rusage[mem=60GB]" -G compute-jin810 -q general \
     -J "STAAR-Step0-Format_Vcfs_${Project_Name}_[1-22]" \
     -o /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Format_Vcfs/${Project_Name}/STAAR-Step0-Format_Vcfs_${Project_Name}_%J_%I.out \
     -e /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Format_Vcfs/${Project_Name}/STAAR-Step0-Format_Vcfs_${Project_Name}_%J_%I.err \
     -a 'docker(elle72/basic:vs4)' \
     bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/${Project_Name}/STAAR-Step0-Format_Vcfs/STAAR-Step0-Format_Vcfs.sh ${Project_Name} /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/BCFs
# STAAR-Step0-Format_Vcfs_${Project_Name}[1-22]
#/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/LOGFILES/STAAR-Step0-Format_Vcfs/${Project_Name}/STAAR-Step0-Format_Vcfs_${Project_Name}%J_%I.
# bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/CODE/Bash_Scripts/${Project_Name}/STAAR-Step0-Format_Vcfs.sh /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/GLNEXSUS/BCFs ${Project_Name}