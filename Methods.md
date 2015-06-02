Methods
===

####SDM implementation

SDM is only available to use in a command-line environment. The Ruby (v2.0.0) source code is available at [https://github.com/pilarcormo/SNP_distribution_method](https://github.com/pilarcormo/SNP_distribution_method). See the README file for a step-by-step explanation on how to perform the filtering steps and how to run and interpret the results obtained from SDM. 

####NGS read mapping and SNP calling

Paired-end Illumina reads were obtained from bulked-segregant analysis of F2 progeny. The quality of the deep sequencing was evaluated using FastQC 0.11.2 (http://www.bioinformatics.babraham.ac.uk/projects/fastqc/). Reads were trimmed and quality filtered by Trimmomatic v0.33 [@Bolger:2014aa]. We performed a sliding window trimming, cutting once the average Phred quality fell below 20 in the window.

The clean reads were aligned to *Arabidopsis thaliana* reference genome (TAIR10) with BWA-MEM long-read alignment using bwa-v0.7.5a [@Li:2010]. The resultant alignment (sam) files were converted to sorted bam files using the samtools package v1.0. We used samtools mpileup command to convert bam files into pileup files.

  To call SNPs we used the mpileup2snp command from VarScan v2.3.7 (http://varscan.sourceforge.net) [@Koboldt:2012aa], [@Koboldt:2009aa] to get VCF 4.1 output. A default allele frequency of 0.8 was used to clasify the SNPs as homozygous. 

####Analysis of the SNP density distributions

From the VCF files obtained from VarScan we created lists for the homozygous and heterozygous SNP positions in each chromosome.

Density plots, QQplots and histograms were built as described in the R (v3.1.1) scripts at [https://github.com/pilarcormo/SNP_distribution_method/R_scripts](https://github.com/pilarcormo/SNP_distribution_method/R_scripts)

We used Kernel Density Estimation in R [@R_language] to identify the high homozygous SNP density areas in the chromosomes. Then, to test the correlation between the SNP distributions and a normal distribution we used the qqplot function available in R. We measured the kurtosis and skewness of the SNP distributions by using the package 'moments' [@momentsR].

 