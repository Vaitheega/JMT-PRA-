# JMT-PRA-
Whole-genome sequencing analysis of Jämthund (JMT) dogs to investigate genetic variants associated with Progressive Retinal Atrophy (PRA). Includes Illumina read quality control, BWA-MEM2 alignment, BAM processing, GATK variant calling, variant filtering and annotation.


Identifying the genetic cause of autosomal recessive inherited retinal degeneration in Swedish Elkhound (Jämthund) using whole-genome sequencing.

## About
 
This repository documents a 10 hp research training project in bioinformatics. The aim is to gain practical experience in whole-genome sequencing analysis and candidate variant filtering.

## Research Question 
Which genetic variant is responsible for autosomal recessive inherited retinal degeneration (PRA) in Swedish Elkhounds (Jämthund)?

## Hypothesis

All three affected Swedish Elkhounds share the same recessive disease-causing variant, so they will be homozygous for it, while the parents and unaffected dogs will not.

## Data
 
Illumina short-read sequencing data from 108 dogs of various breeds, including:
 
- Two Swedish Elkhound trios
- One additional affected Swedish Elkhound
- One unrelated unaffected Swedish Elkhound

## Workflow
 
1. Read quality control
2. Alignment to a canine reference genome (BWA-MEM2)
3. Per-sample variant calling (GATK)
4. Joint genotyping (GATK)
5. Variant-by-sample genotype matrix
6. Candidate variant filtering (assuming all three affected dogs share the same recessive variant)
7. Supervised candidate review and read inspection


| Step | Tool | Output |
|---|---|---|
| 1. Read QC | FastQC, MultiQC | QC reports |
| 2. Alignment | BWA-MEM2, samtools | Sorted BAM |
| 3. Duplicate marking | GATK MarkDuplicates | Deduplicated BAM |
| 4. Per-sample calling | GATK HaplotypeCaller | One GVCF per dog |
| 5. Joint genotyping | GATK GenomicsDBImport, GenotypeGVCFs | Cohort VCF |
| 6. Variant filtering | GATK, bcftools | Filtered VCF |
| 7. Genotype matrix | bcftools query | Variant-by-sample table |
| 8. Candidate filtering | bcftools / script | Candidate variants |
| 9. Read inspection | IGV | Visual confirmation |

## Tools
 
- BWA-MEM2
- GATK
- HPC cluster

## Timeline
| Period | Activities |
|---|---|
| 2–13 November | Introduction, HPC setup, literature reading, quality control and testing scripts |
| 16–27 November | Alignment and per-sample variant calling for all dogs |
| 30 November–11 December | Joint genotyping, genotype matrix generation and candidate filtering |
| 14–18 December | Supervised candidate review, read inspection and final documentation |
| 17 January | Report completion and short oral presentation |


## Status
 
In progress.

## Repository structure
 
```
├── scripts/     # Pipeline scripts
├── results/     # Output tables and candidate variants
├── docs/        # Literature notes and meeting notes
└── README.md


Acknowledgements

Research Training conducted at the Swedish University of Agricultural Sciences (SLU), under the supervision of Suvi Mäkeläinen.
