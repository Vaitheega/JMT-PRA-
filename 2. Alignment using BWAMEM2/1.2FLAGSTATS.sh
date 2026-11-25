#!/bin/bash -l

#SBATCH -A hpc2n2026-056
#SBATCH -t 09:00:00
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=16G
#SBATCH -J flagstats
#SBATCH --array=1-7
#SBATCH -o flagstats_%A_%a.log
#SBATCH -e flagstats_%A_%a.log

echo "Script: 1.2FLAGSTATS_array.sh"
echo "Date: $(date)"

# Load modules
module load GCC/14.2.0
module load SAMtools/1.22

echo "SAMtools version:"
samtools --version

# Project directories
MAIN="/proj/nobackup/mhc/jmt_pra"
INPUT_DIR="${MAIN}/bams_ROS"
OUT_DIR="${MAIN}/coverage"

mkdir -p "$OUT_DIR"

# BAM file list
BAMS=(
    "JMT-7_Molle_sorted.bam"
    "JMT-75_Fait_sorted.bam"
    "JMT-76_Kia_sorted.bam"
    "JMT-043_Wiggo_sorted.bam"
    "JMT-314_Jada_sorted.bam"
    "JMT-315_Welho_sorted.bam"
    "JMT-523_Arro_sorted.bam"
)

# Select one BAM file for this task
file="${INPUT_DIR}/${BAMS[$((SLURM_ARRAY_TASK_ID-1))]}"

if [ ! -f "$file" ]; then
    echo "ERROR: BAM file not found: $file"
    exit 1
fi

dog_id=$(basename "$file" _sorted.bam)

echo "Processing dog: $dog_id"
echo "Started: $(date)"

# 1. Flagstat
echo "Running flagstat..."
samtools flagstat "$file" \
    > "${OUT_DIR}/${dog_id}_flagstats.txt" || exit 1

echo "Flagstat completed"

# 2. Average depth
echo "Running depth..."

samtools depth -a "$file" | \
    awk '{sum+=$3; count++} END {
        if (count > 0)
            print "Genome-wide average =", sum/count
        else
            print "No positions found"
    }' > "${OUT_DIR}/${dog_id}_depth.txt" || exit 1

echo "Depth completed"

# 3. Coverage
echo "Running coverage..."

samtools coverage "$file" \
    -o "${OUT_DIR}/${dog_id}_coverage.txt" || exit 1

echo "Coverage completed"

echo "Finished dog: $dog_id"
echo "Completed: $(date)"
