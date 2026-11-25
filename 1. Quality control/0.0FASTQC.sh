#!/bin/bash

#SBATCH -A hpc2n2026-056
#SBATCH -t 12:00:00
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mem=8G
#SBATCH -J FastQC
#SBATCH -o fastqc_%j.out -e fastqc_%j.err

set -euo pipefail

echo "FastQC job started: $(date)"

# --------------------
# Modules
# --------------------
module load GCCcore/13.3.0 FastQC/0.12.1-Java-17

# --------------------
# Paths
# --------------------
proj_dir="/proj/nobackup/mhc/jmt_pra"

INPUT_DIR="${proj_dir}/fastq_JMT_pra"
OUT_DIR="${proj_dir}/fastqc_results"

mkdir -p "${OUT_DIR}"

# --------------------
# Threads
# --------------------
THREADS=$SLURM_CPUS_PER_TASK

# --------------------
# FASTQ files
# --------------------
shopt -s nullglob
R1_FILES=("${INPUT_DIR}"/*.R1.fastq.gz)

if [[ ${#R1_FILES[@]} -eq 0 ]]; then
    echo "ERROR: No R1 FASTQ files found in ${INPUT_DIR}"
    exit 1
fi

echo "Number of R1 files found: ${#R1_FILES[@]}"

# --------------------
# Run FastQC
# --------------------
for R1 in "${R1_FILES[@]}"; do

    R2="${R1%.R1.fastq.gz}.R2.fastq.gz"

    if [[ ! -f "${R2}" ]]; then
        echo "ERROR: Matching R2 file not found: ${R2}"
        exit 1
    fi

    echo "Running FastQC:"
    echo "${R1}"
    echo "${R2}"

    fastqc --threads "${THREADS}" \
        --outdir "${OUT_DIR}" \
        "${R1}" "${R2}"

done

echo "FastQC analysis completed successfully: $(date)"
