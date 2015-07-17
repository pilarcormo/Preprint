2. Methods
===

####2.1. Model genome generation


We used model genomes to develop our mutant identification method. These were created by asigning idealised SNP distribution to a set of randomly shuffled sequences that imitate contigs. We created different model genomes based on the 34.9 Mb of _Arabidopsis thaliana_ chromosome I. The FASTA sequence used was [TAIR10_chr1.fas](ftp://ftp.arabidopsis.org/home/tair/home/tair/Sequences/whole_chromosomes) from [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) [@Lamesch:2012aa].

To create the model genomes, we use different variations of the script [create_model_genome.rb](https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/create_model_genome.rb).  A detailed protocol and Ruby and R code to replicate the model genomes are provided in the GitHub repository [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes). 

In the model, homozygous SNPs follow a normal distribution (as proven in the section x -results-). The R function rnorm (n, mean, sd) was used to define the homozygous SNPs distribution. The mean was specified in the middle of the model genome, generating a normal distribution with equally sized tails. The standard deviation (sd) was 2 times the mean value. Heterzygous SNPs followed a uniform distribution across the genome length. The R function runif (n, min, max) was used to define the heterozygous SNPs. The min value was fixed to one and the max value was the model genome length. For both functions, n varied in each genome to meet the requirement of finding a SNP every 500 bp.  

A minimum contig size is provided as an argument when running the model genome script, and the maximum contig size is obtained doubling the minimum value. Contig size randomly oscillates between these 2 values. First, we created 1, 3, 5, 7, 11, 13 and 15 Mb genomes with 1 SNP every 500 bp and 2 different contig sizes (1300 and 700 bp). Each genome was replicated 5 times, making a total of 70 genomes which can be found  at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb). 

Then, we used the whole chromosome I length to generate longer model genomes. In this case, 3 contig sizes were employed (1000, 2000 and 4000 approximately) and we replicated each model 5 times, obtaining 15 model genomes more. Those were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names chr1_i for 1000 contigs, chr1_A_i for 2000 contigs and chr1_B_i for  4000 contigs genomes. 

2 sets of model genomes with a non-centered mean were also generated to test SDM filtering step. These genomes were divided in 2000 contigs. They can be found at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names chr1_C_i, which presents an approximated 20% deviation to the right, and chr1_E_i, which presents an approximated 20% deviation to the left. 

####2.2. SDM implementation using model genomes 

SDM workflow is in **Fig.1**

The first step in the SDM pipeline is the calculation of the homozygous to heterozygous SNPs ratio on each contig. The ratio of homozygous to heterozygous SNPs on a contig n is defined as the sum homozygous SNPs on n plus 1 divided by the sum of heterozygous SNPs on n plus 1:

$Ratio_{n} = \frac{(\sum Hom) + 1}{(\sum Het) + 1}$

Then, the effect of the contig length is silenced by normalising the homozygous SNP density. The absolute number of homozygous SNPs in each contig is divided by the number of nucleotides (contig length) so we obtain the contig score:

$Score_{n} = \frac{\sum Hom}{length_{n}}$

[SDM](https://github.com/pilarcormo/SNP_distribution_method/blob/master/lib/SDM.rb) sorts the contigs based on their score so that they follow an ideal normal distribution. It starts by taking the 2 lowest values that should be at both tails of the distribution. Following this fashion, we obtained the right and left sides that together build up the whole distribution.

The first SDM version was run on the model genomes created as explained in the previous section. For all the 70 genomes ranging from 1 to 15 Mb, no filtering step based on the ratio was used. As the peak of the SNP homozygous distribution (mean) was known, the peak identified by SDM was compared to this original value to measure the deviation of the approach: 

$Deviation = \frac{|Candidate - Causative|}{Length}$

where 'Candidate' is the SDM predictred value and 'Causative' is the mean of the normal distribution of homozygous SNPs in the model genome. 

The Ruby code used in model genomes is available at the Github repository [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes).

The same approach was used for the whole-sized genomes. 

####2.3. Jitter plots for SDM deviation

The CSV file with the percentage of deviation calculated for each individual genome as explained in section 2.2  
are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv) and [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv). The R code 

####2.4. Pre-filtering step based on ratio
The homozygous to heterozygous SNPs ratio was used as a cut-off value to discard contigs located further away from the causal mutation.

If this filtering step is required, the threshold astringency should be provided as an integer (1, 5, 10, 20). Each integer represents the percentage of the maximum ratio below which a contig will be discarded. In example, if 1 is specified, SDM will discard those contigs with a ratio falling below 1% of the maximum ratio while a value of 20 is more astringent  will discard those contigs with a ratio falling below 20% of the maximum ratio. 
We used the model genomes defined on section 2.1 to test the effectiveness of the filtering step. In particular, we used the 5 genomes with the normal distribution peak shifted to the right and the 5 genomes the normal distribution peak shifted to the left (chr1_C_i and chr1_E_i). Protocol and results were deposit at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio). The folders /chr1_right and /chr1_left contain examples of SDM output after filtering using all the thresholds under the names Ratio_0_1 (no filtering), Ratio_1_1 (1%), Ratio_5_1 (5%), Ratio_10_1 (10%), Ratio_20_1 (20%). 


####4. Forward genetic screens used to analyse SNP distribution
We used five different sets of Illumina sequence reads (**table 1**) from 4 recent out-cross [@Galvão et al. 2012], [@Uchida et al. 2014] and back-cross experiments [@Allen et al. 2013], [@Monaghan et al. 2014] in *Arabidopsis thaliana* backgrounds **(table 1)**. _Arabidopsis thaliana_ genome is small with a well-described the genetic variation and a small content of repeats, making it an ideal model organism.

The first set of reads (**OCF2**) was obtained  by sequencing a mutant pool of 119 F2 mutants generated by out-crossing a Col-0 background mutant to Ler-0. They also sequenced the parental lines and performed conventional SHOREmap [@Schneeberger:2009] to identify the mutation [@Galvao:2012]. The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html)

In the second study (**BCF2** dataset) [@Allen et al. 2013], they back-cross the mutant Col-0 to the non-mutagenized parental line. A pool of 110 mutant individuals showing the mutant phenotype and the parental line were sequenced. They used different SNP identification methods that produced highly similar outcomes (NGM, SHOREmap, GATK and samtools) [@Austin:2011], [@Schneeberger:2009], [@DePristo:2011aa], [@Li:2009aa]. The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html)

We analysed two different and independent mutants (**mob1** and **mob2**) [@Monaghan:2014]. [DM 5] The mutants (in the Col-0 ecotype) were back-crossed to the parental line and sequenced. They used CandiSNP [@Etherington:2014] to identify the causal mutations
+[DM 5] Not sure how these are different from the others. Can you mention what the mutant screen was looking for and what the expected SNP density is (ie it would be higher in Col / Ler crosses than the Col / Col crosses)

The last dataset we used (**sup#1** dataset) was obtained by outcrossing a Arabidopsis Ws-0 background mutant to Col-0 wild-type plants followed by sequecing of 88 F2 individuals and Ws and Col as parental lines. They described a pipeline to identify the causal mutation based on the peaks obtained by plotting ratios of homozygous SNPs to heterozygous SNPs  [@Uchida et al. 2014]. Reads are available at [http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344](http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344)

**Provide scripts, bam files and vcf files**
**links for reads**

####5. Read mapping and SNP calling

Mutant and parental reads were subjected to the same variant calling approach. The Rakefile and scripts used to perfom the alignment and SNP calling can be found in the **[Additional file with Rakefile]**

The quality of the deep sequencing was evaluated using FastQC 0.11.2 ([http://www.bioinformatics.babraham.ac.uk/projects/fastqc/](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)). Reads were trimmed and quality filtered by Trimmomatic v0.33 [@Bolger:2014aa]. We performed a sliding window trimming, cutting once the average Phred quality fell below 20 in the window.

The paired-end reads were aligned to the reference sequence of *Arabidopsis thaliana* ([TAIR10_chr_all.fas](ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_chromosome_files/)) [@Lamesch:2012aa] from  [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) by BWA-MEM long-read alignment using BWA v 0.7.5a with default settings [@Li:2010]. The resultant alignment (SAM files) were converted to BAM file and then sorted  using the samtools package v1.0. Then, we used samtools mpileup command to convert the BAM files into pileup files. To call SNPs we used the mpileup2snp command from VarScan v2.3.7 [http://varscan.sourceforge.net](http://varscan.sourceforge.net) [@Koboldt:2012aa], [@Koboldt:2009aa] to get VCF 4.1 output. A default allele frequency of 0.8 was used to clasify the SNPs as homozygous. 

BAM and VCF files were deposited on a Github repository at [](). 



####6. Parental filtering
Additional file for scripts

To improve SDM accuracy and unmask the high homozygous SNP peak, we performed a filtering step to reduce the SNP density in the mutant VCF files based on the background SNPs. The parental reads were also aligned to the TAIR10 reference genome followed by a step of SNP calling. The SNPs present in the non-mutant parental reads were obviously not induced by the mutagen (EMS) and are considered as'background' mutations (not responsible for the mutant phenotype). To do the fitering, we run manage-vcf.rb. The code is available at [](). 

 The specific command lines for each dataset are in the additional file 1. 

####7. Centromere removal
Same additional file

####8. Probability plots
Github link

####9. Kurosis

Github link

####10. Analysis of average contig size in different whole genome assemblies 
Github link
  
####10. Model genomes based on real SNP densities

####11. SDM with real SNP densities


The VCF files obtained from VarScan allowed us the generation of homozygous and hetezygous SNP positions lists in the chromosome where the causal mutation was previously described. We divide the chromosome in fragments of 100 kb and used the real SNP densities to run SDM. 

SDM generates several output files: 

a. FASTA file with the suggested fragment order
b. Q-Qplot comparing the correlation between the homozygous SNP distribution after SDM and a the expected normal distribution 
c. Density plot with the hypothetical homozygous and  heterozygous SNP densities and ratios 
d. Density plot to analyse the deviation of the hypothetical ratios after SDM from the theoretical expected ratios 
e. Text file with the candidate contigs and the SNP positions they contain. 

We used the Kernel Density Estimation in R [@R_language] to identify the high homozygous SNP density areas in the chromosomes. Then, to test the normal correlation of the SNP distributions we used the qqplot function available in R. We measured the kurtosis and skewness of the SNP distributions by using the package 'moments' [@momentsR]. [DM 10]
+
+[DM 10] This reads like the brief description of methods that acts as the introduction of the results sections . I couldn't faithfully reproduce what you did from this.

####6. Filtering steps

To improve SDM accuracy and unmask the high homozygous SNP peak, we perform two filtering steps. The first one based on the background SNPs, those SNPs that were present in both parental and mutant VCF files were removed from the mutant SNP list. The second step of filtering was based on the variability in the centromeric region.

 