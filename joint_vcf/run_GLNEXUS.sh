#!/bin/bash
export LSF_DOCKER_VOLUMES='/storage1/fs1/jin810/Active/testing:/storage1/fs1/jin810/Active/testing'
for chr in $(seq 1 22); do
mkdir -p /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/BCFs/chr${chr} /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/LOGFILES/chr${chr} /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/TMP/chr${chr}
bsub -M 1000GB -R 'select[mem>32GB && tmp>32GB] rusage[mem=100GB, tmp=40GB]'  -g /l.vivien/testing_glnexus -o /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/LOGFILES/chr${chr}/gl_%J.out -e /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/LOGFILES/chr${chr}/gl_%J.err -G compute-jin810 -q general -a 'docker(jinlab/glnexus:v1.4.1)' TMPDIR=/storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/TMP/chr${chr} /bin/bash /storage1/fs1/jin810/Active/testing/vivien/STAAR_new/step2/GLNEXUS/CODE/run_GLNEXUS.sh ${chr}
done
