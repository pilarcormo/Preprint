Results and discussion
===

~2300 words

**Table 1** r square, SD, kurtosis

**Table 2** Table candidate mutations 

**Figure 1** A) Formula to calculate deviation B) Bar chart for deviation 5-15 C) Bar chart for 30 Mb

**Figure 2** Using ratio as threshold

**Figure 3** A) Pipeline follow for real datasets B) Overlapping densities 

**Figure 4** A) QQplots

**Figure 5** Pipeline for SDM  

**Figure 6** Results when using SDM with real SNP densities A) QQ-plots B) Ratios

**Additional file 1**. A) Model genome B) formula to calculate ratio

**Additional file 2**. Effect of different factors on ratio

**Additional file 3**. figure comparing plotting before and after removing the background SNPs and the centromere. 

**Additional file 4** Overlapping density plots after SDM

######1. SDM design and modelling using Arabidopsis chromosome I and ideallized SNP densities (344)

To develop our method to identify an experimentally induced causal mutation, we created different model genomes (**Additional 1**) based on _Arabidopsis thaliana_ chromosome I (34.9 Mb). We tested different parameters that could have a potential effect on SDM performance: genome length, contig size, homozygous SNP density, heterozygous SNP density, way of calculating the homozygous to heterozygous ratio and location of the causal mutation.  

We assumed that homozygous SNPs are normally distributed and symmetric about their mean. The mean value correspond to the causal mutation position. In the model, heterozygous SNPs follow a uniform distribution, with no relevant contribution to the general SNP density. We created a VCF (Variant Call Format) file containing the SNP densities that give rise to the above distribution. Then, to emulate real data, we divided the model genome into fragments, which mimic contigs assembled from high-throughput sequencing (HTS) reads. Therefore, we have a FASTA file with the sequences of each fragment, and a VCF file with the SNPs on each fragment. In the model, each SNP is given an allele frequency of exactly 0.5 (heterozygous) or 1.0 (homozygous). 

We developed a method able to identify the candidate contigs carrying the causal mutation from unordered fragments. The first step is the normalisation of the homozygous SNP density by dividing the absolute number of SNPs in each contig by the number of nucleotides (length). Then, SDM sorts the fragments by their SNP density values so that they follow a Gaussian distribution. It starts by taking the 2 lowest values that should be at both tails of the distribution. Following this fashion, we obtained the the right and left sides that build up the distribution. In the tails, we have a high density of contigs with the same SNP density, so we our approach we cannot elucidate their order. However, the contigs surrounding the causal mutation are low in number and should be correctly ordered.  

SDM first calculates the homozygous SNPs to heterozygous SNPs (Hom/het) ratio. Ideally, due to the marker linkage to the causal mutation, the ratio will be higher in the low recombinant genomic region. We measure the ratio  on each fragment (**Additional 1B**), adding 1 to both enumerator and denominator to avoid diving by 0. We analysed the effect of this factor added to numerator and denominator (**Additional 2**) by using different values (1, 0.1 and 0.01) but did not find any conclusive improvement with any of them so decided to use 1. In our ideallised model, the ratio will be maximum in the area where the causative SNP is located.


######2. SDM detects the high SNP density peak with a negligible deviation from the expected peak when using model genomes (292)

To estimate the effect of the genome length, the model genomes ranged between 1 Mb and 15 Mb. To test the effect of the contig size, we used a variable contig length randomly ranging between a provided mininum value and a maximum value, calculated by doubling the minimum. We used two minimum contig sizes (500 bp and 1000 bp) that gave rise to approximately 1300 and 700 contigs respectively. 

We started using a high SNP density (1 SNP each 500 bp), with the causal mutation located in the middle of the distribution. In this way, we know where the mutation is located in the model genome and we can measure the deviation (**Fig. 1A**) of SDM from the expected position. To guarantee the confidence of SDM, we created 5 replicates for each condition and we calculate the average deviation from the causal mutation for all the genome sizes and contig sizes (**Fig. 1B**). In all the cases, we proved that SDM identified the high density peak with no significant effect of genome length and contig size. The deviation from the causal mutation assigned in the model was always lower than 0.5%, so we can conclude that our method was reliable to estimate the mutation under these conditions. In order to move on to less ideal genomes, we repeated the previous experiment by using the whole chromosome I and 3 different contig sizes. The results were similar to those for smaller genomes, and again we did not see any significant effect of genome length or contig size (**Fig. 1C**). 

######3. A pre-filtering step based on the homozygous to heterozygous SNPs ratio improves SDM accuracy (219)

SDM worked perfectly when the idealised causal mutation was located in the middle of the distribution (mean) as the number of fragments at both sides (right and left) was the same. However, when we shifted the causal mutation in our model to one side (one tail was longer than the other), SDM was not able to sort the contigs properly. The reason for this shift is that the contigs with the same SNP frequency are impossible to classify as belonging to the right or left tail. 

To fix this issue, we determined a threshold value based on the ratio of homozygous to heterozygous SNPs. In this way, the contigs with a ratio below the threshold are not considered in the analysis, and only those with a high ratio are sorted. In this way, the exact position in the genome cannot be determined but we can assess the contigs in which the mutation is more likely to be found, dismissing a great part of the genome that is hiding the causative mutation. To test the influence of the threshold we used the whole chromosome I from *Arabdidopsis* as a model. We tested different ratio values from 0.5 to 2 (**Fig. 2**). 0.5 or 1 were discriminative enough for SDM to find the correct order of the relevant contigs. In the end, we standardised this value and used a 25% of the maximum ratio as threshold.


######4. Confirmation of the causative mutations identified by bulk segregant analysis using Illumina sequencing and Arabidopsis as a reference genome (678)

We selected different sets of data of bulk segregant analysis of a mutation segregating in an out-cross or back-cross population. We performed convencional genome alignment to the reference genome using the reads provided in 4 different mapping-by-sequencing experiments  that succeed in identifying the mutation([@Galvao:2012], [@Allen:2013], [@Monaghan:2014], [@Uchida:2014]]). The techniques used to identify the mutations were different in every case so we took advantage of this fact to confirm the reproducibility of the methods available. To reproduce the experiments, we aligned the Illumina paired-end reads to the *Arabidopsis thaliana* reference genome TAIR10 [@Lamesch:2012aa] after a quality filtering step. Then, we used VarScan for variant detection. After plotting the SNP densitiy (**Fig. 3, pipeline**), we analysed the homozygous SNPs distribution in each chromosome and the ratio of homozygous to heterozygous to confirm the genomic region where the mutations were described. SNPs with a frequency of 0.8 or larger were considered homozygous. 

In the first study, they generated a recombinant mapping population by outcrossing a Col-0 background mutant to the divergent accession Ler-0. The offspring were allowed to self-fertilize. A mutant pool of 119 F2 individuals was sequenced (we refer to this dataset as **OCF2**) [@Galvao:2012]. The two parental lines Col-0 and Ler-0 were also sequenced. Then, they performed conventional SHOREmap [@Schneeberger:2009] to identify the mutation causing late flowering which lied on chromosome 2, specifically on gene _SOC1_(18807538..18811047).

In an attempt to identify the gene involved in the Arabidopsis microRNA pathway, the mutants in the second study (**BCF2** dataset)[@Allen:2013] were generated by back-crossing a mutant to the non-mutagenized parental line followed by one round of self-fertilization. A pool of 110 mutant individuals showing leaf hyponasty and the non-mutagenized parental line mir159a were sequenced. They used different SNP callers that produced highly similar outcomes (NGM, SHOREmap, GATK and samtools)[@Austin:2011], [@Schneeberger:2009], [@DePristo:2011aa], [@Li:2009aa]. They identified the causal SNP mutation in _HASTY_, a gene on chromosome 3 (1401271..1408197). 

We also analysed a recent forward screen done in the immune-deficient bak1-5 background to identify novel components involved in plant immune signalling [@Monaghan:2014]. In this screen, after mutagenizing bak1-5 seeds (in the Col-0 ecotype) with EMS, they screened the M2 generation for modifier of **bak1-5 (mob) mutants** that restored immune signalling. To obtain the mutants, they back-crossed bak1-5 mob mutants to the parental line (bak1-5). F2 mutants and the parental line (bak1-5) were sequenced. They used CandiSNP [@Etherington:2014] to map the mutations and identified causal mutations in the gene encoding the calcium-dependent protein kinase CPK28 (26456285..26459631) for both bak1-5 mob1 and bak1-5 mob2.

The last mapping-by-sequencing study we used was obtained by outcrossing a Arabidopsis Wassilewskija (Ws-0) background mutant to Col-0 wild-type plants followed by sequecing of 88 F2 individuals and Ws and Col as parental lines [@Uchida:2014]. They described a pipeline to identify the causal mutation based on the peaks obtained by plotting ratios of homozygous SNPs to heterozygous SNPs. By following this approach, they reported that the majority of SNPs detected on chromosome 4 were homozygous and they identified the sup#1 mutation on the _SGT1b_ gene (6851277..6853860). They also shown a homozygous peak on chromosome 1 due to the transgene present in the original population. 

Once we obtained the homozygous SNP densities, we proceed to plot the homozygous and heterozygous SNP densities. For all the forward genetics screens under analysis we confirmed that there was a high homozygous SNP density in the genomic area where the causal SNP was previously described, suggesting a linkage of homozygous SNPs to the phenotype-altering SNP in a low recombination area. By plotting the densities (**Fig. 3B**) in all the chromosomes after filtering, we could confirm that the high SNP density peak was unique for all the cases apart from one. The outcrossed sup#1 mutant also showed a peak in chromosome 1, but this was expected and described in the original report [@Uchida:2014]. We divide the chromosomes in 100 kb fragments and calculate the ratios of homozygous SNPs to heterozygous SNPs (**Fig. 3B**).

######5.Homozygous SNPs in forward genetics screens are normally distributed around the causative mutation (232)

After running a standardised variant calling approach with different sets of reads obtained from bulk segregant analysis, we showed a unique distribution peak  around the causative mutation. The next step was to know if this SNP distribution obtained correlated well with a theoretical probability distribution. For this aim, we built probability plots or Q-Q plots with the homozygous SNP densities in back-cross and out-cross experiments in Arabidopsis (**Fig. 4A**). Our results indicate that there is a good correlation between these distributions and a normal distribution. We further validated the correlation between the sample values and the predicted values by a simple linear regression (r<sup>2</sup> >0.9) for all the examples. The standard deviation, although variable between samples, oscillated between 3 and 7 Mb (**Table 1**). 

We also analysed the shape of the distributions by measuring the kurtosis (**Table 1**). 4 of the 5 distributions were platykurtic, as they showed a negative kurtosis and consequently a lower, wider peak around the mean and thinner tails. Only one (sup#1) was leptokurtic (positive kurtosis). We also measured the skewness; this value implies that the distribution of the data is skewed to the left (negatively skewed) or to the right (positively skewed). The skewness will depend on the location of the causal mutation in the chromosome, so as expected, we did not see any conserved tendency among the data (**Table 1**). 

######6. Filtering background SNPs and centromeres unmasks the high homozygous SNP density peak (200)

We filtered the background SNPs to reduce the complexity of the SNP lists and improve the degree of correlation to a normal distribution. The parental reads were subjected to the same variant calling approach and those SNPs that were present in both parental and mutant samples were removed from the mutant SNP list (**Fig. 4.A**, **Additional file 1**). The usefulness of removing non-unique SNPs is not new, and all the  mapping-by-sequencing  experiments we have chosen here did the same filtering to some extent. 

Also, SDM accuracy was improved when the we removed SNPs concentrated around centromeres. It was easy in this case since we were using *Arabidopsis thaliana* as a model organism and centromeres are defined in the genome assembly. However, for the long-term goal of the methodology proposed, we still have to develop some way to identify the variability due to the centromere. Many studies have shown the peculiarity of the centromere, so these sequences should be easy to identify. Centromeres are  characterised by  the presence of tandem repeats, and extremely high repeat abundance (often >10,000 copies per chromosome) [@Melters:2013aa].

######7. SDM identifies the genomic region carrying the causal mutation previously described by other methods

As a final proof-of-concept, we used the SNP densities obtained from OCF2, BCF2, mob1-mob2 and sup#1 datasets to create new model genomes. Again, we took the chromosomes where the mutations were described and split them into fragments of minimum size 100 kb (contig size ranges between 100 and 200 kb). The model genomes were created in the same way as explained above, but instead of using an idealised SNP density, we used the real SNP positions after parental filtering and centromere removal. SDM generates several output files: 

a. FASTA file with the hypothetical fragment order
b. Q-Qplot comparing the correlation between the homozygous SNP distribution after SDM and a the expected normal distribution (**Fig. 6A**)
c. Density plot with the hypothetical homozygous and  heterozygous SNP densities and ratios (**Additional 4**)
d. Density plot to analyse the deviation of the hypothetical ratios after SDM from the theoretical expected ratios (**Fig. 6B**)
e. Text file with the candidate contigs and the SNP positions they contain. 

We regained the normal distribution for all the datasets after shuffling the contig order and running SDM on them (**Fig. 6A**). The correct contig order and real ratio distribution are known, so we created a plot comparing the hypothetical ratio distribution after SDM and the real one to test the performance of SDM (**Fig. 6B**). 

In our case studies, the causal mutation estimation by SDM was more accurate in back-crosses (bak1-5 mutants and BCF2) than in out-crosses (OCF2 and sup#1). The number of segregating SNPs is lower in back-cross experiments (1 SNP every 65,000 bp)  compared to out-crosses (1 SNP every 900 bp) [@Etherington:2014]. The large number of segregating SNPs in out-crosses complicated the assignation of a position in the normal distribution to a contig. For example, if more than 2 contigs contain 4 SNPs, there is no reliable way to discriminate between them and the problem gets worse when the number of contigs with the same number of SNPs increases. Hence, we added a feature to SDM to specify the type of cross before defining the candidate mutations. 

As expected, the approximation to the causal mutation is more accurate in back-cross experiments and the number of candidates oscillates between 4 and 10 (**Table 2**). In our two out-cross examples the number of homozygous SNPs differs; SDM identified the causal mutation position in OCF2 (**Table 2**) even though the number of candidates was greater compared to the back-crosses. However, more than 100 candidate mutations out of several thousand SNPs were proposed for sup#1 in a very small region of the chromosome (100 kb) and the actual causal SNP was not in that list (**Table 2**). Therefore, out-crosses to a reference line would need more filtering steps to reduce the number of SNPs at the starting point as they did in the original report [Uchida:2014]. We can conclude that SDM is a rapid and precise method to perform bulk segregant linkage analysis from back-crossed populations without relying on the disponibility of a reference genome, but we need to be cautious when dealing with out-cross experiments.  


Conclusions
===

Forward genetic screens are very useful to identify genes responsible for particular phenotypes. Thanks to the advances in HTS technologies, mutant genomes sequencing has become quick and unexpensive. However, the mapping-by-sequencing methods available present certain limitations, complicating the mutation identification especially in non-sequenced species. To target this problem, we proposed a fast, reference genome independent method to identify causative mutations. We showed that homozygous SNPs are normally distributed in the mutant genome of back-cross and out-crossed individuals. Based on that idea, we defined a theoretical SNP distribution used by SDM to identify the genomic region where the causative mutation was located. We conclude that SDM is especially sucessful for analysing mutants obtained from a back-cross population. The increase in the number of SNPs in out-cross experiments complicated the genetic analysis and the mutation estimation. Ideally, over the next few years, sequencing costs will decrease and this will allow to sequence every mutant individual from a forward genetic screen. Therefore, we need fast and reliable methods to identify variants bypassing the reference genome assembly step. We now aim to improve and apply SDM in forward genetics screens of species where a reference genome is not yet available. Also, we plan to develop an accessible software that will speed up gene finding in non-sequenced organisms. 


