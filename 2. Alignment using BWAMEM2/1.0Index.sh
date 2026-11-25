#!/bin/bash

#SBATCH -A hpc2n2026-056
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem=60G
#SBATCH -t 10:00:00
#SBATCH -J index_ROS
#SBATCH --open-mode=append
#SBATCH -o index_ROS.%j.log
#SBATCH -e index_ROS.%j.log

set -euo pipefail

echo "======================================"
echo "Reference genome indexing started"
echo "Date: $(date)"
echo "======================================"

# Load software modules
module load GCC/14.2.0 bwa-mem2/2.2.1 SAMtools/1.22
module load picard/2.25.1-Java-11

# Project reference directory
REF_DIR="/proj/nobackup/mhc/jmt_pra/ref_db/ROS_Cfam_1.0_database"

# Reference genome
REF="${REF_DIR}/ROS_Cfam_1.0.fa"  # run inside where the ref is 

# Picard dictionary output
DICT_OUT="${REF_DIR}/ROS_Cfam_1.0.dict"

# Move to reference directory
cd "${REF_DIR}"

# Check that reference genome exists
if [[ ! -f "${REF}" ]]; then
    echo "ERROR: Reference genome not found: ${REF}"
    exit 1
fi

echo "Reference genome: ${REF}"

# Step 1: Create BWA-MEM2 index
echo "Starting BWA-MEM2 indexing: $(date)"

bwa-mem2 index -p ROS_Cfam_1.0.fa "${REF}"

echo "BWA-MEM2 indexing completed: $(date)"

# Step 2: Create SAMtools FASTA index
echo "Starting SAMtools indexing: $(date)"

samtools faidx "${REF}"

echo "SAMtools indexing completed: $(date)"

# Step 3: Create Picard sequence dictionary
echo "Starting Picard sequence dictionary creation: $(date)"

java -Xmx4g -jar "${EBROOTPICARD}/picard.jar" CreateSequenceDictionary \
    REFERENCE="${REF}" \
    OUTPUT="${DICT_OUT}"

echo "Picard dictionary creation completed: $(date)"

echo "======================================"
echo "All reference indexing steps completed!"
echo "Date: $(date)"
echo "======================================"

