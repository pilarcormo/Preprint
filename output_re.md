
#Identification of genomic regions carrying a causal mutation in unordered genomes.

Whole genome sequencing using high-throughput sequencing (HTS) technologies offers powerful opportunities to study genetic variations. Mapping the mutations responsible for phenotypes is generally an involved and time-consuming process so researchers have developed user-friendly tools for mapping-by-sequencing, yet they are not applicable to organisms with non-sequenced genomes.

We introduce SDM (SNP Distribution Method), a reference independent method for rapid discovery of mutagen-induced mutations in typical forward genetics screens. SDM aims to order a disordered collection of HTS reads or contigs so that the fragment carrying the causative mutations can be identified. SDM uses typical distributions of homozygous SNPs that are linked to a phenotype-altering SNP in a non-recombinant region as a model to order the fragments. To implement and test SDM, we created model genomes with SNP density based on *Arabidopsis thaliana* chromosome and analysed fragments with size distribution similar to reads or contigs assembled from HTS sequencing experiments. SDM groups the contigs by their normalised SNP density and arranges them to maximise the fit to the expected SNP distribution. We analysed the procedure in existing data sets by examining SNP distribution in recent out-cross [17, 18] and back-cross experiments [19, 20] in *Arabidopsis thaliana* backgrounds. In all the examples we analysed, homozygous SNPs were normally distributed around the causal mutation. We used the real SNP densities obtained from these experiments to prove the efficiency and accuracy of SDM. The algorithm succeed in the identification of the genomic regions of small size (10-100 kb) containing the causative mutations.


1. Background 
===

Forward genetic screens have been a fundamental strategy to find genes involved in biological pathways in model species. In these a population is treated with a mutagen that alters the DNA of individuals in some way, e.g. induction of guanine-to-adenine substitutions using ethylmethane sulfonate (EMS) [1].  Then individuals with a phenotype of interest are isolated from a mutagenized population and a recombinant mapping population is created by back-crossing to the parental line or out-crossing to a polymorphic ecotype [2]. The recombinant population obtained from that cross will segregate for the mutant phenotype and individuals showing the mutant phenotype will carry the causal mutation, even if the genomic location is unknown. The recombination frequency between the causal mutation and nearby genetic markers is low, so the alleles of these linked genetic markers will co-segregate with the phenotype-altering mutation while the remaining unlinked makers segregate randomly in the genome [3].

 Hence, the allele distribution analysis can unhide these low recombinantregions to identify the location of the causal mutation. This process of genetic analysis is often referred to as bulk segregant analysis (BSA) [4].Traditional genetic mapping is a work intensive and time-consuming process but recent advances in high-throughput sequencing (HTS) have greatly accelerated the identification of mutations underlying mutant phenotypes in forward genetic screens. Several methods as  CandiSNP [2], SHOREmap [5,6] or NGM [7] based on bulked-segregant analysis of F2 progeny have succeeded in the mutant identification in *Arabidopsis thaliana*. All these methods depend on an assembled reference genome and cannot be used in species for which a reference genome is not available. Some alternative solutions as using reference sequences of related species have been proposed [8, 9], but these need low sequence divergence and high levels of synteny between the mutant reads and the related reference sequence. This has restained the application of this approach [3,10]. Substantial effort is being made to sequence many species but reasonable completion of a sequence remains expensive and time-consuming, and fragmented draft genomes present certain limitations in use for mutation mapping. For instance, fast-evolving and repetitive genes such as disease resistance genes [11] might be absent or divergent from draft reference genome assemblies. Also, draft genomes often have gaps that can frustrate alignments. In the last few years, several reference-free methods for general mutation identification have been proposed [10, 12, 13, 14] to solve the reference sequence restriction, but none have been extended to allow for direct identification of causative mutations. [3, 14, 15].

We propose SDM, a fast causative mutant identification method based on a simple reference-free contig assembly that allows the detection of candidate causative SNPs. Instead of relying on a genome comparison, we focus on the SNP linkage around the causal mutation and analyse the SNP distribution to identify the chromosome area where the putative mutated gene is located. SDM does not rely on previously known genetic markers and can be used on extremely fragmentary genome assemblies, even down to the level of long reads.

2. Methods
===

###2.1. Model genome generation

We used model genomes to develop our mutant identification method. We assigned an idealised SNP distribution to a set of randomly shuffled sequences that imitate contigs assembled from HTS. We created different model genomes based on the 34.9 Mb of *Arabidopsis thaliana* chromosome I. The FASTA sequence used was [TAIR10_chr1.fas](ftp://ftp.arabidopsis.org/home/tair/home/tair/Sequences/whole_chromosomes) from [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) [16]. 

To create the model genomes, we used different variations of the script [https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/create_model_genome.rb](https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/create_model_genome.rb).  A detailed protocol and the code to replicate the model genomes were deposited in a GitHub repository at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes). 

Homozygous SNPs followed a normal distribution (as proven in the section 3.4). The R function rnorm defined by number of observations (n), mean and standard deviation (sd) was used to describe the homozygous SNP distribution. The mean was specified in the middle of the model genome, generating a normal distribution with equally sized tails. The standard deviation (sd) was 2 times the mean value. Heterzygous SNPs followed a uniform distribution across the genome length. The R function runif defined by number of observations (n), minimum value and maximum value was used to describe the heterozygous SNPs. The min value was fixed to one and the max value was the model genome length. For both functions, n varied in each genome to meet the requirement of finding a SNP every 500 bp.  

A minimum contig size is provided as an argument when running the script, and the maximum contig size is obtained doubling the minimum value. Contig size randomly oscillates between these 2 values. 

We ran [small_model_genome.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/small_model_genome.rb) to create 1, 3, 5, 7, 11, 13 and 15 Mb genomes with 1 SNP every 500 bp and 2 different contig sizes to create 1300 and 700 contigs in total. We replicated each genome 5 times, making a total of 70 genomes which can be found at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb). 

Then, we also ran [chr1_model_genome.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/chr1_model_genome.rb) to use the whole chromosome I length to generate longer model genomes. A more realistic SNP density was used for these models (1 SNP every 3000 bp). In this case, 3 contig sizes were employed to create 1000, 2000 and 4000 contigs approximately) and we replicated each model 5 times, obtaining 15 model genomes more. Those were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names chr1_i for 1000 contigs, chr1_A_i for 2000 contigs and chr1_B_i for 4000 contigs genomes. i ranges from 1 to 5 and it is used to name the replicates.

We also generated 2 sets of model genomes with a non-centered mean to test SDM filtering step. These genomes were divided in 2000 contigs. They can be found at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names chr1_C_i, which presents an approximated 20% deviation to the right, and chr1_E_i, which presents an approximated 20% deviation to the left. 

Model genomes directories contain a FASTA file with the correct fragment order, a FASTA file with the randomly shuffled fragments and a VCF file with the homozygous and heterozygous SNP positions. For simplicity, homozygoys SNPs are given a fixed Allele Frequency (AF) of 1 and heterozygous SNPs are given an AF of 0.5 in the VCF file. 

###2.2. SDM implementation using model genomes 

[**Fig.1**](https://github.com/pilarcormo/Preprint/blob/master/Fig1/workflow.png) shows the SNP Distribution Method (SDM) workflow.

The first step in the pipeline is the homozygous to heterozygous SNPs ratio calculation per contig. The ratio of homozygous to heterozygous SNPs on a contig n is defined as the sum of all the homozygous SNPs on n plus 1 divided by the sum of all the heterozygous SNPs on n plus 1. In the [additional figure 2](add2_comparison_ratios.png) we show the effect of using other factors instead of 1 to calculate the ratio.




$$
\begin{aligned}
Ratio_{n} = \frac{(\sum Hom) + 1}{(\sum Het) + 1}
\end{aligned}
$$




The effect of contig length on SNP density is reduced by normalising the SNP density by length. The absolute number of homozygous SNPs in each contig is divided by the number of nucleotides (contig length) so we obtain the contig score:




$$
\begin{aligned}
Score_{n} = \frac{\sum Hom}{length_{n}}
\end{aligned}
$$






[SDM](https://github.com/pilarcormo/SNP_distribution_method/blob/master/lib/SDM.rb) sorts the contigs based on their score so that they follow an ideal normal distribution. It starts by taking the 2 lowest values and locates them at both tails of the distribution. Following this fashion, we obtained the right and left sides of a normal distribution that together build up the whole distribution.

The first SDM version was run on the model genomes created as explained in section 2.1. SDM uses as input the VCF file with the homozygous and heterozygous SNP positions, the text files containing the lists of homozygous and heterozygous SNPs and the FASTA file with the shuffled contigs. The FASTA file with the correct contig order is used to calculate the ratios in the correctly ordered fragments so that they can be compared to the ratios obtained after SDM sorts the contigs. The command lines to run SDM on the model genomes are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SDM.sh](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SDM.sh). 

SDM generates a new FASTA file with the suggested contig order and plots comparing the SNP densities and ratios after SDM to original values. 

For all the 70 genomes ranging from 1 to 15 Mb, no filtering step based on the ratio was used (threshold = 0). The highest kernel density value for the SNP distribution after sorting the contigs with SDM was taken as candidate SNP. 
This value was compared to the initial mean of the homozygous SNP distribution to measure the deviation of the approach: 




$$
\begin{aligned}
Deviation = \frac{|Candidate - Causative|}{Length}
\end{aligned}
$$



where 'Candidate' is the SDM predicted position and 'Causative' is the mean of the normal distribution of homozygous SNPs in the model genome. A CSV file containing all the deviations in the model genomes can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/arabidopsis_datasets/1-15Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/arabidopsis_datasets/1-15Mb.csv). 
The same approach was used for the whole-sized genomes (chr1_i, chr1_A_i and chr1_B_i). 

The Ruby code used to run SDM on model genomes is available at the Github repository [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SNP_distribution_method.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SNP_distribution_method.rb). 


###2.3. SDM deviation in jitter plots

The deviation percentages calculated independently for each genome as explained in section 2.2 are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv) and [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv). The R code to plot the deviation jitter plots for each genome length and contig size was deposited at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_cripts/jitter_plots.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_cripts/jitter_plots.R) 

###2.4. Pre-filtering step based on the homomozygous to heterozygous ratio

The homozygous to heterozygous SNP ratio was used as a cut-off value to discard contigs located further away from the causal mutation. If this filtering step is required, the threshold astringency should be provided as an integer. Each integer represents the percentage of the maximum ratio below which a contig will be discarded. In example, if 1 is specified, SDM will discard those contigs with a ratio falling below 1% of the maximum ratio while a more astrigent value of 20 will discard those contigs with a ratio falling below 20% of the maximum ratio. 

We used the model genomes defined on section 2.1 to test the effectiveness of the filtering step. In particular, we used the replicates of the genome with the normal distribution peak shifted to the right and the replicates of the genome with the normal distribution peak shifted to the left (chr1_C_i and chr1_E_i, respectively). Protocol and results were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio). The directories /chr1_right and /chr1_left contain examples of the SDM output after filtering  under the names Ratio_0_1 (no filtering), Ratio_1_1 (1% threshold), Ratio_5_1 (5% threshold), Ratio_10_1 (10% threshold), Ratio_20_1 (20% threshold). 


###2.5. Forward genetic screens used to analyse SNP distribution

We used five different sets of Illumina sequence reads from 4 recent out-cross [17, 18] andback-cross experiments [19, 20] in *Arabidopsis thaliana* backgrounds [**(table 1)**](https://github.com/pilarcormo/Preprint/blob/master/tables.pdf). 

Galvão et al obtained the first set of reads (**OCF2**) by sequencing a mutant pool of 119 F2 mutants generated by out-crossing a Col-0 background mutant to a Ler-0 mapping line. They also sequenced the parental lines and performed conventional SHOREmap [5] to identify the mutation [17].  The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html)

In the second study (**BCF2** dataset), Allen et al back-crossed the *Col-0* mutant to the non-mutagenized *Col-0* parental line [19]. A pool of 110 mutant individuals showing the mutant phenotype and the parental line were sequenced. They used different SNP identification methods that produced highly similar outcomes (NGM, SHOREmap, GATK and samtools) [5, 7, 21, 22]. The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html)

The third study we analysed was also a back-cross experiment. Monaghan et al obtained two different and independent *Col-0 *mutants (called ***bak1-5 mob1*** and ***bak1-5 mob2***) [20]. The mutants were back-crossed to a parental *Col-0* line and sequenced. They used CandiSNP [2] to identify the causal mutation.

The last dataset we used (**sup#1** dataset) was obtained by outcrossing a Arabidopsis Wassilewskija (Ws) mutant to wild-type *Col-0*  plants followed by sequecing of 88 F2 individuals and Ws and Col as parental lines. Uchida et al described a pipeline to identify the causal mutation based on the peaks obtained by plotting ratios of homozygous SNPs to heterozygous SNPs  [18]. Reads are available at [http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344](http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344)


###2.6. Read mapping and SNP calling

Mutant and parental reads were subjected to the same variant calling approach. The Rakefile and scripts used to perfom the alignment and SNP calling can be found in the [Suplementary file 1](https://github.com/pilarcormo/Preprint/blob/master/sup_file1.md).

The quality of the deep sequencing was evaluated using FastQC 0.11.2 ([http://www.bioinformatics.babraham.ac.uk/projects/fastqc/](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)). Reads were trimmed and quality filtered by Trimmomatic v0.33 [23]. We performed a sliding window trimming, cutting once the average Phred quality fell below 20 in the window.

The paired-end reads were aligned to the reference sequence of *Arabidopsis thaliana* TAIR10_chr_all.fas at [ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_chromosome_files/](ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_chromosome_files/) [16] from  [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) by BWA-MEM long-read alignment using BWA v 0.7.5a with default settings [24]. The resultant alignment (SAM files) were converted to BAM file and then sorted  using the samtools package v1.0. Then, we used samtools mpileup command to convert the BAM files into pileup files. To call SNPs we used the mpileup2snp command from VarScan v2.3.7 [http://varscan.sourceforge.net](http://varscan.sourceforge.net) [25, 26] to get VCF 4.1 output. A default allele frequency of 0.8 was used to clasify the SNPs as homozygous. 

VCF files for mutants and mapping lines can be found at the repository [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads) in the individual folder for each screen (/OCF2, /BCF2, /Aw_sup1-2, /m_mutants)

The whole pipeline used for read mapping and SNP calling is summarised in the [Additional figure 1](https://github.com/pilarcormo/Preprint/blob/master/Additional/Add1_worflow_methods.png).

###2.7. Parental filtering

To improve SDM accuracy and unmask the high homozygous SNP peak, we performed a filtering step to reduce the SNP density in the mutant VCF files. The parental reads were also mapped to the Arabidopsis reference genome as explained in section 2.6 followed by a step of SNP calling. The SNPs present in the non-mutant parental reads were not induced by the mutagen (EMS) and can be considered as 'background' mutations (not responsible for the mutant phenotype). Therefore, they can be discarded from the mutant VCF file.

The workflow used to filtered the reads can be found in the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md) and the protocol is available in the README file deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads). The code used is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/manage_vcf.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/manage_vcf.rb)

###2.8. Centromere removal

A great part of the variability observed in the genomes was due to the presence of centromeres. The code at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/remove_cent.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/remove_cent.rb) was used to discard the SNP positions that were due to the centromere variability. The workflow used to filter the reads can be found in the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md) and a detailed protocol is available in the README file deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads)

###2.9. SNP density analysis

The absolute number of homozygous SNPs before and after filtering was taken from the reads folder by running [SNP_density.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/snp_density.rb). The  command lines are available at [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md). 

The output CSV file is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density.csv). It shows the number of homozygous SNPs per chromosome and per forward genetic screen (BCF2, OCF2, sup#1, mob1, mob2). After obtaining the total number of homozygous SNPs per genome by adding together the values per chromosome, we wrote new CSV files for the back-cross and the out-cross experiments. Those are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_back.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_back.csv) and [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_out.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_out.csv). 

We used the R code at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_scripts/SNP_filtering.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_scripts/SNP_filtering.R) to plot the total number of homozygous SNPs before filtering, after parental filtering and after centromere removal. 

We plotted the homozygous and heterozygous SNP densities obtained after filtering for each study  together with the ratio signal to identify the high density peaks in the distribution.  The R code was deposited at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/filtering.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/filtering.md)

###2.10. Probability plots

To analyse the correlation of the homozygous SNP density in forward genetic screens to a normal distribution, we created probability plots (QQ-plots).  We used the homozygous SNP positions in the chromosome where the causative mutation was located after parental filtering and centromere removal. The R code and plots are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/qqplot.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/qqplot.md)

###2.11. Kurtosis

We analysed the shape and variance of the normal homozygous SNP distributions. The R code results are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/kurtosis.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/kurtosis.md)

###2.12. Analysis of average contig size in different whole genome assemblies 
Genome assemblies at contig level available for plants at [http://www.ncbi.nlm.nih.gov/assembly/organism/3193/all/](http://www.ncbi.nlm.nih.gov/assembly/organism/3193/all/) were used to define a more realistic contig size in our model genomes. We analysed all the contig assemblies from January 2013 until June 2015 which provided a full genome representation and a genome coverage higher than 1x. Only those providing the sequencing technology and the N50 contig size were selected to analyse the contig size distribution. 

The whole table with the chosen assemblies and the results are available at this Github repository [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Contigs](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Contigs). 

We plotted the N50 contig size against the genome size using a different colour for each sequencing technology. Then, we plotted the N50 density and calculated the median of the distribution. The R code can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R). We focused on the 16 assemblies built with Illumina Hiseq and we tried to define a model for the N50 contig size change over genome length. We applied a Generalized Additive Model (GAM) to fit non-parametric smoothers to the data without specifing a particular model. First, we applied logarithms to both N50 size and genome length on the Illumina HiSeq assemblies.
The R code can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R)

###2.13. Model genomes based on real SNP densities

We created new model genomes using the homozygous and heterozygous SNP densities obtained from the forward genetic screens after parental filtering and centromere removal. Three minimum contig sizes were used (2,000, 5,000 and 10,000 bp), being the maximum values 4,000, 10,000 and 20,000 bp respectively. The contig sizes oscillated between the minimum and the maximum values. Instead of using idealised SNP distributions as explained in section 2.1, we used the homozygous and heterozygous SNP lists from the genetic screens. The densities were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/SNP_densities](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/SNP_densities). 

The genomes  were generated by running [https://github.com/pilarcormo/SNP_distribution_method/blob/master/model_genome_real_hpc.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/model_genome_real_hpc.rb). The  command lines are available at the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md).

The genomes are available at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere). They are classified by contig size. The directories contain the following: frags_shuffled.fasta, frags.fasta, hm_snps.txt, ht_snps.txt and snps.vcf

###2.14. SDM with real SNP densities
The model genomes generated as explained in 2.13 were used to prove SDM efficiency to identify the genomic region carrying the causative mutation. The Ruby code is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/SNP_distribution_method_variation.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/SNP_distribution_method_variation.rb). The input and output specification for SDM can be found at the README file in the main project Github repository [https://github.com/pilarcormo/SNP_distribution_method](https://github.com/pilarcormo/SNP_distribution_method). 

Instead of specifying a percentage of the maximum ratio to filter the contigs, we used an automatic approach to tailor the threshold for each specific SNP density and contig length. The default percentage of the maximum ratio used was 1%. After the first filtering round, if the amount of dicarded contigs is less than 3% of the original amount of contigs, the percentage of the maximum ratio is increased by 2 and the filtering is repeated until the condition specified is met. 

The command lines used to run SDM on the model genomes generated as explained in section 2.13 are available at [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md).


3. Results and discussion
===

###3.1. SDM works over a range of effective genome lengths and realistic fragment sizes

We created model genomes based on _Arabidopsis thaliana_ chromosomes to develop our mutant identification method.  *Arabidopsis thaliana* is a widely used organism for forward genetic screening due to its relatively small and well-annotated genome. Also, SNP densities in several mapping-by-sequencing experiments in *Arabidopsis* are publicly available (see section 3.3 for several examples) so they were used as a starting point to develop our methodology. 

By making customised genomes we could rapidly alter different paramenters as genome length, contig size or SNP density to analyse their effect on the detection method accuracy. Our dinamic way of creating model genomes helped us define all the different aspects that should be taken into account when analysing the SNP distribution. Also, the causative mutation was defined manually by us, so we could measure the deviation between the defined and the predicted value. We generated the model genomes by asigning an idealised SNP distribution to a set of randomly shuffled sequences that imitate contigs assembled from HTS. In the model genomes, homozygous SNPs follow a normal distribution while heterozygous SNPs follow a uniform distribution. 

To estimate the effect of the genome length on SDM's ability to find the causative mutation, we created model genomes of different sizes ranging from 1 Mb to 15 Mb with a high SNP density (1 SNP every 500 bp). We defined a variable contig length randomly ranging between a provided mininum value and its double. We used two minimum contig sizes to create 1300 and 700 contigs approximately in each model. To guarantee the confidence of SDM, we created 5 replicates for each condition. 
For the second set of model genomes, we used the whole  _A. thaliana_ chromosome I  and a more realistic SNP density (1 SNP every 3000 bp). In this case, we used 3 contig sizes were employed  to generate 1000, 2000 and 4000 contigs in each model.

The SNP Distribution Method (SDM) sorts the sequence fragments by their SNP density values (the score calculated as defined in section 2.2) so that they follow a normal distribution. We applied a second sorting step in which the contigs are also sorted by their ratio (calculated as defined in section 2.2). We considered the highest kernel density value for the SNP distribution after SDM as the candidate SNP location and this value was compared to the peak of the normal distribution previously defined in the model genome. The difference was called 'deviation' and can be found in  [**Fig. 2**](Fig2/big_jitter.png). Consistent results were obtained for all the replicates. SDM identified the high density peak with no significant effect of genome length and contig size. The deviation from the causative mutation assigned in the model was lower than 1% in the small SNP-riched genomes (Fig 2A). This was also true for the whole-sized genomes when they were fragmented in 1000 and 2000 contigs but not for the 4000 contigs (Fig 2B), where 4 of the 5 replicates had a deviation between 1 and 3%. 

We can conclude that the increase in the number of contigs makes the sorting harder. We used a constant SNP density for all the contig sizes,  so SNPs are spreaded over shorter fragments. The high density peak is fragmented and the sorting becomes more complicated. Hence, SDM works over a range of different genome lengths and contig sizes. We observed a slight decrease in SDM efficiency when the contig size for a 30 Mb genome was below 5,000 bp. 


###3.2. A pre-filtering step based on the homozygous to heterozygous SNPs ratio improves SDM accuracy 

SDM succeed in the high density peak identification in model genomes when the idealised causative mutation was located in the middle of the distribution as the number of fragments at both sides (right and left) of the distribution was the same. However, this success is only true in the high SNP density area (peak of the distribution) while the contigs located in the tails cannot be sorted by their SNP density. When we shifted the causal mutation in our model to one side (one tail was longer than the other), SDM was not able to sort the contigs in the tails properly. Even though the contigs located in the peak were correct,  the algorithm was not able to classify the low SNP density contigs as belonging to the right or left tail and the highest kernel density value in the distribution appeared deviated from the previously defined peak [(**Fig. 3A**)](Fig3/ratios.png). 

We delimited a threshold value based on the ratio of homozygous to heterozygous SNPs to discard contigs located further away from the causative mutation. We excluded those contigs with a ratio below a given percentage of the maximum ratio. Therefore, only those contigs with a high ratio are sorted. Even though the exact position in the genome cannot be determined by this approach, we can assess the contigs in which the mutation is more likely to be found, dismissing a great part of the genome that is hiding the causative mutation. To test the influence of the threshold we used the whole chromosome I from *Arabdidopsis thaliana* as a model genome [(**Fig. 3**)](Fig3/ratios.png). In our model genome, the mean in the normal distribution was shiffed approximately a 20% to the left or to the right. 

with a high SNP density (1 SNP every 3000 bp), and a normal distribution of standard deviation 1 Mb, the high density peak matched the expected when 10% of the maximum ratio was used as a threshold.  a when aproximately a 80-90% of the genome was discarded. 

In this case, the SNP density was high (1 SNP every 3000 bp) and the distribution peak was narrow. However, we cannot establish a standard threshold, since it will depend on the peak deviation on each case. To avoid lossing interesting mutations by being too strict with the filtering, we suggest using 1-5% of the maximum ratio to obtain optimal results. 

 
###3.3. Filtering background SNPs and centromeres unmasks the high homozygous SNP density peak in several bulk segregant analysis in Arabidopsis 

We selected different sets of data of bulk segregant analysis of a mutation segregating in an out-crossed [17, 18] or back-crossed [19, 20] population. We performed conventional genome alignment to the reference genome using the reads provided in the 4 studies. The techniques used to identify the mutations ([**Table 1**](tables.pdf)) were different in every case so we took advantage of this fact to confirm the reproducibility of the available methodology to identify causative mutations.  We aligned the Illumina paired-end reads to the *Arabidopsis thaliana* reference genome [16]. Then, we used VarScan for variant calling. 

In the first out-cross experiment (OCF2), Galvão et al identified the mutation causing late flowering which lied on chromosome 2, specifically on the  _SOC1_ gene (18807538..18811047) [17]. In the second study (BCF2) Allen at al analised the mutant individuals showing leaf hyponasty to identify a gene involved in the Arabidopsis microRNA pathway [19]. They identified the causal SNP mutation in _HASTY_, a gene on chromosome 3 (1401271..1408197). We used the reads from a forward screen done in the immune-deficient bak1-5 background to identify new components involved in plant immunity. Monaghan et al found 2 causative mutations in the gene encoding the calcium-dependent protein kinase CPK28 (26456285..26459631) for both bak1-5 mob1 and bak1-5 mob2 [20]. In the last mapping-by-sequencing study, Uchida et al identified the sup#1 mutation on the _SGT1b_ gene (6851277..6853860) on chromosome 4 [18] ([**Table 2**](tables.pdf))

The main advantage of working with already identified mutations is to focus on the chromosome were the mutation was previously described. We analysed the total number of homozygous SNPs in the chromosome where the causative mutation was located as shown in [**Fig. 4**](Fig4/snp_dens.png).  When the mutant individual is out-crossed to a distant mapping line (OCF2 and sup#1), the SNP density is up to 20 times higher than in the case of back-crossing to the parental line (BCF2 and mob mutants). In the back-crossed populations, we identified approximately 1,700 homozygous SNPs. That gives an overall density of 1 SNP every 15,000 bp. We identified 9,200 homozygoys SNPs in the chromosome of interest in the first out-crossed population (OCF2) and 27,000 SNPs in the second out-crossed population (sup#1). The overall density was of 1 SNP every 2,500 bp for OCF2 and 1 SNP every 700 bp for sup#1. 

Parental filtering was fundamental to reduce the SNP density and unmask the SNP linkage around the causative mutation and it was especially crucial in out-crossed populations where the starting density was higher. The parental lines used to back or out-cross were also sequenced and mapped to the *Arabidopsis thaliana* reference genome. The SNPs present in the non-mutant parental reads were considered 'background' mutations and filtered from the mutant SNP lists. In the back-cross studies, the absolute homozygous SNP number was reduced up to 9 times ([**Fig. 4A**](Fig4/snp_dens.png)) after parental filtering.  The total number of homozygous SNPs was reduced 3 times in out-crossed populations  ([**Fig. 4C**](Fig4/snp_dens.png)). Even though the centromere removal did not reduce the total number of SNPs in the same proportion as parental filtering did, it was essential to unhide the normal distribution around the causative mutation. Many studies have shown the centromeres peculiarity, characterised by high repeat abundance (often >10,000 copies per chromosome) [27]. This high variability in a few hundred of bp generates a high SNP density peak which hides the peak of interest. 

The filtering steps reduced the complexity of the distribution ([Additional fig 3](Additional/addit3.png)) and improved the degree of correlation to a normal distribution (see section 3.5). The usefulness of removing non-unique SNPs is not new, and all the  mapping-by-sequencing  experiments we used did the same filtering to some extent.

We identified a unique peak in the area where the causative mutation was described when we plotted the homozygous SNP density obtained after filtering. We calculated the homozygous to heterozygous ratio for each contig and the ratio values were overlapped to the SNP densities. [**Fig. 5A**](Fig5/back.png) shows the density plots obtained for the back-crossed populations and and [**Fig. 5B**](Fig5/out.png) shows the density plots for the out-crossed populations. All the densities were congruent with the results described in the publications [17, 18, 19, 20].

###3.4. Homozygous SNPs in forward genetics screens are normally distributed around the causative mutation 

After running the variant calling approach with the different datasets, we showed a unique peak in the SNP distribution around the causative mutation (**Fig. 5**). The next step was to analyse the correlation of the SNP density to a theoretical probability distribution. We created probability plots or Q-Q plots with the homozygous SNP densities in the back-crossed and out-crossed populations ([**Fig. 6**](Fig6/qqplots.png)). Our results indicate a good correlation between the homozygous SNP frequencies and a normal distribution. We further validated the correlation between the sample values and the predicted values by a simple linear regression  (R-sq > 0.9). The standard deviation is variable but oscillate between 3 and 7 Mb ([**Table 2**](tables.pdf)), so that is evidence that 15 Mb model genomes are large enough to identify the normal distribution when using real SNP densities from forward genetic screens. 

We analysed the shape of the distributions by measuring the kurtosis ([**Table 3**](tables.pdf)). 4 of the 5 distributions were platykurtic, as they showed a negative kurtosis and consequently a lower, wider peak around the mean and thinner tails. Only one (sup#1) was leptokurtic (positive kurtosis). This observation might be due to the high homozygous SNP density observed in sup#1, that was more than 3 times higher than the SNP density observed in the other out-crossed population (OCF2).  This high density generates a narrower peak due to the greater linkage of SNPs in the non-recombinant area. In the other examples, the number of SNPs linked together is lower and they are highly scattered in the genome, generating the lower, wider platykurtic distribution peak. 


###3.5. The N50 contig size in plant genome assemblies depends on genome size and sequencing technology

To generate more realistic model genomes, we needed a representational contig size. We analysed 29 assemblies at contig level. The relationship between genome length and N50 contig size was not really obvious as other aspects as the sequencing technology used **([Fig. 7A](Fig7/contigs.png))** or the genome coverage have a high impact on the final N50 contig size. We observed that the preferred sequencing technology in the last 2-3 years is Illumina HiSeq since half of the assemblies were built using this technology. Other assemblies used combinations of different techniques (including Illumina, 454 and PacBio). The median value of the N50 contig length for all the 29 assemblies is 11,517 bp while it is reduced to 5,484 bp when analysing only HiSeq assemblies **([Fig. 7B](Fig7/contigs.png))**. To decrease the effect of the technology used, we focused on the 16 assemblies built with Illumina Hiseq and we tried to establish a model that could explain the N50 change over genome length.  

The relationship was not linear but we did not have any mechanistic model to describe it, so we apply a Generalized Additive Model (GAM) to fit non-parametric smoothers to the data without specifing a particular model.  When we focused on those genomes larger than 200 Mb, the model fit well the data (R-sq = 0.807).

We used 3 different contig sizes to create the model genomes. The first two model genomes were built using the N50 median values. We chose 10,000 bp (based on the median for all the assemblies) and 5,000 bp (based on the median for Illumina Hiseq). The smallest contig size was decided looking at the model defined for Illumina HiSeq assemblies. Due to the *Arabidopsis thaliana* genome size, the minimum contig size decided for these model genomes was 2,000 bp.

###3.6. SDM identifies the genomic region carrying the causal mutation previously described by other methods

As a proof-of-concept, we used the SNP densities obtained from OCF2, BCF2, mob1, mob2 and sup#1 datasets as explained in section 3.3 after parental filtering and centromere removal to build new model genomes. We split the *Arabidopsis thaliana* chromosomes where the mutations were described into fragments of size specified in section 3.5. The SNP density used to build the model genomes was the same for all the contig sizes.

We regained the normal distribution for all the datasets after shuffling the contig order and running SDM.  The results for all the model genomes generated were deposited in a Github repository at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere).

Our prior knowledge about the correct contig order allowed us to define the real chromosomic positions in the artificially-made contigs identified by SDM as candidates. In that way, we were able to adjust the method to get its best efficiency ([**Table 4**](tables.pdf)). Contig size had an effect on the number of candidate contigs supplied by SDM. When the minimum contig sizes were 2 and 5 kb, the SNP positions were split into different contigs and it was harder for SDM to find the correct contig order. When the average contig size was below 10 kb, 20 candidate contigs were considered enough for back-crossed populations and 40 were needed for out-crossed populations due to the high SNP densities. However, when the average contig size was over 10 kb, 12 candidate contigs in the middle of the distribution were enough to contain the causative mutation. Hence, the candidate region ranges from 60 to 180 kb depending on the contig size and the type of cross. 

In our model populations, the number of candidate positions was higher for the out-crosses [**Fig. 4B**](Fig4/snp_dens.png) than for the back-crosses [**Fig. 4C**](Fig4/snp_dens.png). This is logical as the SNP density after filtering was higher in the out-crossed populations, and therefore, the number of segerating SNPs in the candidate contigs is larger.

We could not define a universal cut-off value based on the homozygous to heterozygous ratio for all the different SNP densities and crosses, as sometimes the region with a high ratio was narrow due to a high SNP linkage in the area, while in other cases, the increase in the ratio was progressive, and the peak was wider. Therefore, when we worked with real densities, we used an automatic approach that tailor the threshold for each specific SNP density and contig length. [**Table 4**](Tables.pdf) shows the tailored thresholds and total discarded contigs for all the datsets.

We can conclude that SDM is a rapid and precise method to perform bulk segregant linkage analysis from back-crossed and out-crossed populations without relying on the disponibility of a reference genome, specially effective on contig sizes over 5 kb. Even though it can be accurate with smaller contigs, we defined detection limit on 2-4 kb contigs. In 2 out of the 5 models, the contig carrying the candidate mutation was lost when the contig size oscillated between 2 and 4 kb.
 
Conclusions
===

Forward genetic screens are very useful to identify genes responsible for particular phenotypes. Thanks to the advances in HTS technologies, mutant genomes sequencing has become quick and unexpensive. However, the mapping-by-sequencing methods available present certain limitations, complicating the mutation identification especially in non-sequenced species. To target this problem, we proposed a fast, reference genome independent method to identify causative mutations. We showed that homozygous SNPs are normally distributed in the mutant genome of back-cross and out-crossed individuals. Based on that idea, we defined a theoretical SNP distribution used by SDM to identify the genomic region where the causative mutation was located. We conclude that SDM is especially sucessful to identify the genomic region carrying a causative mutation in back-crossed and out-crossed populations, specially when contig are over 2 kb in length. The increase in the SNP density in out-cross experiments increased the number of candidate contigs obtained from SDM. Ideally, over the next few years, sequencing costs will decrease and this will allow to sequence every mutant individual from a forward genetic screen. We need fast and reliable methods to identify variants bypassing the reference genome assembly step. We now aim to improve and apply SDM in forward genetics screens of species where a reference genome is not yet available. We plan to develop an accessible software that will speed up gene finding in non-sequenced organisms. 


