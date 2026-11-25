#!/bin/bash
#SBATCH -A hpc2n2026-056
#SBATCH -t 48:00:00
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem=100G
#SBATCH --array=1-7
#SBATCH -J bwa
#SBATCH --open-mode=append
#SBATCH -o bwa_%A_%a.log
#SBATCH -e bwa_%A_%a.log

set -euo pipefail

echo "Job started: $(date)"
echo "Script: BWA-MEM2 ROS_Cfam_1.0"
echo "Array job ID: ${SLURM_ARRAY_JOB_ID}"
echo "Array task ID: ${SLURM_ARRAY_TASK_ID}"

# --------------------
# Modules
# --------------------

module load GCC/14.2.0 bwa-mem2/2.2.1 SAMtools/1.22

# --------------------
# Paths
# --------------------

proj_dir="/proj/nobackup/mhc/jmt_pra"

REF="${proj_dir}/ref_db/ROS_Cfam_1.0_database/ROS_Cfam_1.0.fa"

INPUT_DIR="${proj_dir}/fastq_JMT_pra"

OUT_DIR="${proj_dir}/bams_ROS"

SAMPLE_LIST="${proj_dir}/scripts/samples.txt"

mkdir -p "${OUT_DIR}"

# --------------------
# Threads
# --------------------

THREADS=12
SORT_THREADS=4

# --------------------
# Get sample name
# --------------------

dog_id=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_LIST}")

if [[ -z "${dog_id}" ]]; then
    echo "ERROR: No sample found for array task ${SLURM_ARRAY_TASK_ID}"
    exit 1
fi

echo "Processing sample: ${dog_id}"

# --------------------
# FASTQ files
# --------------------

R1="${INPUT_DIR}/${dog_id}.R1.fastq.gz"
R2="${INPUT_DIR}/${dog_id}.R2.fastq.gz"

if [[ ! -f "${R1}" || ! -f "${R2}" ]]; then
    echo "ERROR: FASTQ files not found for ${dog_id}"
    echo "Expected:"
    echo "${R1}"
    echo "${R2}"
    exit 1
fi

# --------------------
# Reference check
# --------------------

if [[ ! -f "${REF}" ]]; then
    echo "ERROR: Reference genome not found: ${REF}"
    exit 1
fi

# --------------------
# Output BAM
# --------------------

BAM="${OUT_DIR}/${dog_id}_sorted.bam"

# --------------------
# Alignment
# --------------------

echo "Starting alignment: $(date)"

bwa-mem2 mem -M -t "${THREADS}" \
    -R "@RG\tID:${dog_id}\tSM:${dog_id}\tPL:Illumina\tLB:${dog_id}\tPU:None" \
    "${REF}" "${R1}" "${R2}" \
    | samtools view -@ "${SORT_THREADS}" -u - \
    | samtools sort -@ "${SORT_THREADS}" -m 4G -o "${BAM}"

# --------------------
# Index BAM
# --------------------

echo "Indexing BAM: $(date)"

samtools index "${BAM}"

echo "Finished ${dog_id}: $(date)"
echo "Output: ${BAM}"
echo "BAM index: ${BAM}.bai"

echo "Job completed successfully"
