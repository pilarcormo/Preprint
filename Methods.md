2. Methods
===

###2.1. Model genome generation

We used model genomes to develop our mutant identification method. We assigned an idealised SNP distribution to a set of randomly shuffled sequences that imitate contigs assembled from HTS. We created different model genomes based on the 34.9 Mb _Arabidopsis thaliana_ chromosome I. The FASTA sequence used was [TAIR10_chr1.fas](ftp://ftp.arabidopsis.org/home/tair/home/tair/Sequences/whole_chromosomes) from [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) [16]. *Arabidopsis thaliana* makes an ideal model genome due to its small size, a well-described genetic variation and a small content of repeats.

To create the model genomes, we used different variations of the script [https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/create_model_genome.rb](https://github.com/edwardchalstrey1/fragmented_genome_with_snps/blob/master/create_model_genome.rb).  A detailed protocol and the code to replicate the model genomes were deposited in a GitHub repository at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes). 

Homozygous SNPs followed a normal distribution (as proven in the section 3.4). The R function `rnorm` defined by `n`, `mean` and `sd` was used to describe the homozygous SNP distribution. The mean was specified in the middle of the model genome, generating a normal distribution with equally sized tails. The standard deviation (sd) was 2 times the mean value. Heterzygous SNPs followed a uniform distribution across the genome length. The R function `runif` defined by `n`, `min` and `max` was used to describe the heterozygous SNPs. The `min` value was fixed to 1 and the `max` value was the model genome length. For both functions, `n` varied in each genome to meet the requirement of finding a SNP every 500 bp so that the resolution of high SNP density peak is good even in small genomes. 

A minimum contig size is provided as an argument when running the script, and the maximum contig size is obtained by doubling the minimum value. Contig sizes are randomly chosen to be between these 2 values. 

We ran [small_model_genome.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/small_model_genome.rb) to create 1, 3, 5, 7, 11, 13 and 15 Mb genomes with 1 SNP every 500 bp and 2 different contig sizes to create 1300 and 700 contigs in total. We replicated each genome 5 times, making a total of 70 genomes which can be found at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/1-15Mb). 

Then, we also ran [chr1_model_genome.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/chr1_model_genome.rb) to use the whole chromosome I length to generate longer model genomes. A more realistic SNP density was used for these models (1 SNP every 3000 bp). In this case, 3 contig sizes were employed to create 1000, 2000 and 4000 contigs approximately) and we replicated each model 5 times, obtaining 15 model genomes more. Those were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names `chr1_i` for 1000 contigs, `chr1_A_i` for 2000 contigs and `chr1_B_i` for 4000 contigs genomes. `i` ranges from 1 to 5 and it is used to name the replicates 

We also generated 2 sets of model genomes with a non-centered mean to test SDM filtering step. These genomes were divided in 2000 contigs. They can be found at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/30Mb) under the names `chr1_C_i`, which presents an approximated 20% deviation to the right, and `chr1_E_i`, which presents an approximated 20% deviation to the left. 

Model genomes directories contain a FASTA file with the correct fragment order, a FASTA file with the randomly shuffled fragments and a VCF file with the homozygous and heterozygous SNP positions. For simplicity, homozygoys SNPs are given a fixed Allele Frequency (AF) of 1 and heterozygous SNPs are given an AF of 0.5 in the VCF file. 

###2.2. SDM implementation using model genomes 

[**Fig.1**](https://github.com/pilarcormo/Preprint/blob/master/Fig1/workflow.png) shows the SNP Distribution Method (SDM) workflow.

The first step in the pipeline is the homozygous to heterozygous SNPs ratio calculation per contig. The ratio of homozygous to heterozygous SNPs on a contig n is defined as the sum of all the homozygous SNPs on n plus 1 divided by the sum of all the heterozygous SNPs on n plus 1. 




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






[SDM](https://github.com/pilarcormo/SNP_distribution_method/blob/master/lib/SDM.rb) sorts the contigs based on their score so that they follow an ideal normal distribution. It starts by taking the 2 lowest values and locates them at each tail of the distribution. Following this fashion, we obtained the right and left sides of a normal distribution that together build up the whole distribution.

The first SDM version was run on the model genomes created as explained in section 2.1. SDM uses as input the VCF file with the homozygous and heterozygous SNP positions, the text files containing the lits of homozygous and heterozygous SNPs and the FASTA file with the shuffled contigs. The FASTA file with the correct contig ordered is used to calculate the ratios in the correctly ordered fragments so that they can be compared to the ratios obtained after SDM sorts the contigs. The command lines to run SDM on the model genomes are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SDM.sh](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SDM.sh). 

SDM generates a new FASTA file with the suggested contig order and plots comparing the SNP densities and ratios after SDM to original values. 

For all the 70 genomes ranging from 1 to 15 Mb, no filtering step based on the ratio was used (threshold = 0). The highest kernel density value for the SNP distribution after sorting the contigs with SDM was taken as candidate SNP. 
This value was compared to the initial mean of the homozygous SNP distribution to measure the peak shift: 




$$
\begin{aligned}
Peak shift = \frac{|Candidate - Causative|}{Length}
\end{aligned}
$$



where 'Candidate' is the SDM predicted position and 'Causative' is the mean of the normal distribution of homozygous SNPs in the model genome. A CSV file containing all the deviations in the model genomes can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/arabidopsis_datasets/1-15Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/arabidopsis_datasets/1-15Mb.csv). 
The same approach was used for the whole-sized genomes (`chr1_i`, `chr1_A_i` and `chr1_B_i`). 

The Ruby code used to run SDM on model genomes is available at the Github repository [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SNP_distribution_method.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/SNP_distribution_method.rb). 


###2.3. SDM deviation in jitter plots

The deviation percentages calculated independently for each genome as explained in section 2.2 are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/1-15Mb.csv) and [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Small_genomes/30Mb.csv). The R code to plot the deviation jitter plots for each genome length and contig size was deposited at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_cripts/jitter_plots.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_cripts/jitter_plots.R) 

###2.4. Pre-filtering step based on the hom/het ratio

The homozygous to heterozygous SNP ratio was used as a cut-off value to discard contigs located further away from the causal mutation. If this filtering step is required, the threshold astringency should be provided as an integer. Each integer represents the percentage of the maximum ratio below which a contig will be discarded. In example, if 1 is specified, SDM will discard those contigs with a ratio falling below 1% of the maximum ratio while a more strigent value of 20 will discard those contigs with a ratio falling below 20% of the maximum ratio. 

We used the model genomes defined on section 2.1 to test the effectiveness of the filtering step. In particular, we used the replicates of the genome with the normal distribution peak shifted to the right and the replicates of the genome with the normal distribution peak shifted to the left (`chr1_C_i` and `chr1_E_i`, respectively). Protocol and results were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Small_genomes/arabidopsis_datasets/Analyse_effect_ratio). The directories `/chr1_right` and `/chr1_left` contain examples of the SDM output after filtering  under the names `Ratio_0_1` (no filtering), `Ratio_1_1` (1% threshold), `Ratio_5_1` (5% threshold), `Ratio_10_1` (10% threshold), `Ratio_20_1` (20% threshold). 


###2.5. Forward genetic screens used to analyse SNP distribution

We used five different sets of Illumina sequence reads from 4 recent out-cross [17, 18] and back-cross experiments [19, 20] in *Arabidopsis thaliana* backgrounds [**(table 1)**](https://github.com/pilarcormo/Preprint/blob/master/tables.pdf). 

Galvão et al obtained the first set of reads (**OCF2**) by sequencing a mutant pool of 119 F2 mutants generated by out-crossing a Col-0 background mutant to a Ler-0 mapping line. They also sequenced the parental lines and performed conventional SHOREmap [5] to identify the mutation [17].  The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html)

In the second study (**BCF2** dataset), Allen et al back-crossed the Col-0 mutant to the non-mutagenized Col-0 parental line [19]. A pool of 110 mutant individuals showing the mutant phenotype and the parental line were sequenced. They used different SNP identification methods that produced highly similar outcomes (NGM, SHOREmap, GATK and samtools) [5, 7, 21, 22]. The reads are available to download at [http://bioinfo.mpipz.mpg.de/shoremap/examples.html](http://bioinfo.mpipz.mpg.de/shoremap/examples.html).

The third study we analysed was also a back-cross experiment. Monaghan et al obtained two different and independent Col-0 mutants (called **bak1-5 mob1** and **bak1-5 mob2**) [20]. The mutants were back-crossed to a parental Col-0 line and sequenced. They used CandiSNP [2] to identify the causal mutation.

The last dataset we used (**sup#1** dataset) was obtained by outcrossing an Arabidopsis Wassilewskija (Ws) mutant to wild-type Col-0  plants followed by sequecing of 88 F2 individuals and Ws and Col as parental lines. Uchida et al described a pipeline to identify the causal mutation based on the peaks obtained by plotting ratios of homozygous SNPs to heterozygous SNPs  [18]. Reads are available at [http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344](http://www.ncbi.nlm.nih.gov/sra/?term=DRA000344)


###2.6. Read mapping and SNP calling

Mutant and parental reads were subjected to the same variant calling approach. The Rakefile and scripts used to perfom the alignment and SNP calling can be found in the [Suplementary file 1](https://github.com/pilarcormo/Preprint/blob/master/sup_file1.md).

The quality of the deep sequencing was evaluated using FastQC 0.11.2 ([http://www.bioinformatics.babraham.ac.uk/projects/fastqc/](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)). Reads were trimmed and quality filtered by Trimmomatic v0.33 [23]. We performed a sliding window trimming, cutting once the average Phred quality fell below 20 in the window.

The paired-end reads were aligned to the reference sequence of *Arabidopsis thaliana* TAIR10_chr_all.fas at [ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_chromosome_files/](ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_chromosome_files/) [16] from  [The Arabidopsis Information Resource](https://www.arabidopsis.org/index.jsp) by BWA-MEM long-read alignment using BWA v 0.7.5a with default settings [24]. The resultant alignment (SAM files) were converted to BAM file and then sorted  using the samtools package v1.0. Then, we used samtools mpileup command to convert the BAM files into pileup files. To call SNPs we used the mpileup2snp command from VarScan v2.3.7 [http://varscan.sourceforge.net](http://varscan.sourceforge.net) [25, 26] to get VCF 4.1 output. A default allele frequency of 0.8 was used to clasify the SNPs as homozygous. 

VCF files for mutants and mapping lines can be found at the repository [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads) in the individual folder for each screen (/OCF2, /BCF2, /Aw_sup1-2, /m_mutants)

The whole pipeline used for read mapping and SNP calling is summarised in the [Additional figure 1](https://github.com/pilarcormo/Preprint/blob/master/Additional/Add1_worflow_methods.png).

###2.7. Parental filtering

To improve SDM accuracy and unmask the high homozygous SNP peak, we performed a filtering step to reduce the SNP density in the mutant VCF files. The parental reads were also mapped to the Arabidopsis reference genome as explained in section 2.6 followed by a step of SNP calling. The SNPs present in the non-mutant parental reads were obviously not induced by the mutagen (EMS) and can be considered as 'background' mutations (not responsible for the mutant phenotype). So they can be discarded from the mutant VCF file.

The workflow used to filter reads can be found in the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md) and the protocol is available in the README file deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads). The code used is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/manage_vcf.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/manage_vcf.rb)

###2.8. Centromere removal

A great part of the variability observed in the genomes was due to the presence of centromeres. The code at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/remove_cent.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/remove_cent.rb) was used to discard the SNP positions that were due to the centremere variability. The workflow used to filtered the reads can be found in the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md) and a detailed protocol is available in the README file deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Reads)

###2.9. SNP density analysis

The absolute number of homozygous SNPs before and after filtering was taken from the reads folder by running [SNP_density.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/snp_density.rb). The  command lines are available at [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md). 

The output CSV file is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density.csv). It shows the number of homozygous SNPs per chromosome and per forward genetic screen (BCF2, OCF2, sup#1, mob1, mob2). After obtaining the total number of homozygous SNPs per genome by adding together the values per chromosome, we wrote new CSV files for the back-cross and the out-cross experiments. Those are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_back.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_back.csv) and [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_out.csv](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/density_sum_out.csv). 

We used the R code at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_scripts/SNP_filtering.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/R_scripts/SNP_filtering.R) to plot the total number of homozygous SNPs before filtering, after parental filtering and after centromere removal. 

We plotted the homozygous and heterozygous SNP densities obtained after filtering for each study  together with the ratio signal to identify the high density peaks in the distribution.  The R code was deposited at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/filtering.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/filtering.md)

###2.10. Probability plots

To analyse the correlation of the homozygous SNP density in forward genetic screens to a normal distribution, we created probability plots (QQ-plots).  We used the homozygous SNP positions in the chromosome where the causative mutation was located after parental filtering and centromere removal. The R code and plots are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/qqplot.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/qqplot.md)

###2.11. Distribution shape analysis

We analysed the shape and variance of the normal homozygous SNP distributions. The R code results are available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/kurtosis.md](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Reads/kurtosis.md)

###2.12. Analysis of average contig size in different whole genome assemblies 
Genome assemblies at contig level available for plants at [http://www.ncbi.nlm.nih.gov/assembly/organism/3193/all/](http://www.ncbi.nlm.nih.gov/assembly/organism/3193/all/) were used to define a more realistic contig size in our model genomes. We analysed all the contig assemblies from January 2013 until June 2015 which provided a full genome representation and a genome coverage higher than 1x. Only those providing the sequencing technology and the N50 contig size were selected to analyse the contig size distribution. 

The whole table with the chosen assemblies and the results are available at this Github repository [https://github.com/pilarcormo/SNP_distribution_method/tree/master/Contigs](https://github.com/pilarcormo/SNP_distribution_method/tree/master/Contigs). 

We plotted the N50 contig size against the genome size using a different colour for each sequencing technology. Then, we calculated the N50 density and the median of the distribution. The R code can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R). We focused on the 16 assemblies built with Illumina Hiseq and we tried to define a model for the N50 contig size change over genome length. We applied a Generalized Additive Model (GAM) to fit non-parametric smoothers to the data without specifing a particular model. First, we applied logarithms to both N50 size and genome length on the Illumina HiSeq assemblies.
The R code can be found at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R](https://github.com/pilarcormo/SNP_distribution_method/blob/master/Contigs/contigs.R)

###2.13. Model genomes based on real SNP densities

We created new model genomes using the homozygous and heterozygous SNP densities obtained from the forward genetic screens after parental filtering and centromere removal. Three minimum contig sizes were used (2,000, 5,000 and 10,000 bp), being the maximum values 4,000, 10,000 and 20,000 bp respectively. The contig sizes oscillated between the minimum and the maximum values. Instead of using idealised SNP distributions as explained in section 2.1, we used the homozygous and heterozygous SNP lists from the genetic screens. The densities were deposited at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/SNP_densities](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/SNP_densities). 

The genomes  were generated by running [https://github.com/pilarcormo/SNP_distribution_method/blob/master/model_genome_real_hpc.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/model_genome_real_hpc.rb). The  command lines are available at the [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md).

The genomes are available at [https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere). They are classified by contig size. The directories contain the following: frags_shuffled.fasta, frags.fasta, hm_snps.txt, ht_snps.txt and snps.vcf

###2.14. SDM with real SNP densities
The model genomes generated as explained in 2.13 were used to prove SDM efficiency to identify the genomic region carrying the causative mutation. The Ruby code is available at [https://github.com/pilarcormo/SNP_distribution_method/blob/master/SNP_distribution_method_variation.rb](https://github.com/pilarcormo/SNP_distribution_method/blob/master/SNP_distribution_method_variation.rb). The input and output specification for SDM can be found at the README file in the main project Github repository [https://github.com/pilarcormo/SNP_distribution_method](https://github.com/pilarcormo/SNP_distribution_method). 

Instead of specifying a percentage of the maximum ratio to filter the contigs, we used an automatic approach to tailor the threshold for each specific SNP density and contig length. The default percentage of the maximum ratio used was 1%. After the first filtering round, if the amount of dicarded contigs is less than 3% of the original amount of contigs, the percentage of the maximum ratio is increased by 2 and the filtering is repeated until the condition specified is met. 

The command lines used to run SDM on the model genomes generated as explained in section 2.13 are available at [Suplementary file 2](https://github.com/pilarcormo/Preprint/blob/master/sup_file2.md).


