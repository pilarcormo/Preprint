
#Reference-free identification of genomic regions carrying a causal mutation.

##Abstract
##Background
- NGS useful for mappping mutations.
- Forward genetic screens.
- SNP/Variant calling methods require a reference genome: NGM, SHOREmap, CandiSNP, MutMap... Advantages and limitations
- Reference-free methods. NIKS, De Bruijn graphs. Limitations
- Brief explanation of SDM. 

##Results

######Homozygous SNPs in forward genetics screens are normally distributed around the causative mutation
Arabidopsis screens (and approach used to identify the mutation)

1. mob1/mob2 (candiSNP)
2. OCF2 (Shoremap)
3. BCF2 (NGM, Shoremap, Samtools, GATK)
4. sup#1 (-)

qqplots

######SDM modelling using Arabidopsis thaliana chromosome I and ideal SNP densities
SDM workflow

######SDM accuracy improvement by filtering background SNPs 
Parental VCF

Centromere

######Mutant identification using SDM
Pre-filtering step based on the homozygous to heterozygous SNPs ratio is crucial to define the contigs surrounding the mutation. 

Pipeline

Results

######SDM performance and comparison to other methods

##Discussion
- backcross vs outcross experiments
- Advantages and future perspectives


