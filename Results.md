Results and discussion
===

**Table 1** r square, SD, kurtosis

**Table 2** Table candidate mutations 

**Figure 1**  A) Model genome B) formula to calculate ratio

**Figure 2** A) Formula to calculate deviation B) Bar chart for deviation 5-15 C) Bar chart for 30 Mb

**Figure 3** Using ratio as threshold

**Figure 4** A) Pipeline follow for real datasets B) Overlapping densities C) QQplots


**Figure 5** Pipeline for SDM  

**Figure 6** Results when using SDM with real SNP densities A) QQ-plots B) Ratios


**Additional file 1**. Effect of different factors on ratio

**Additional file 2**. figure comparing plotting before and after removing the background SNPs and the centromere. 

**Additional file 3** Overlapping density plots after SDM

######1. SDM design and modelling using Arabidopsis chromosome I and ideallized SNP densities (344)

Code and examples are available at GitHub in [https://github.com/pilarcormo/SNP_distribution_method](https://github.com/pilarcormo/SNP_distribution_method)

To develop our method to identify an experimentally induced causal mutation, we create different model genomes based on _Arabidopsis thaliana_ chromosome I (34.9 Mb). We tested different parameters that could have a potential effect on SDM performance: genome length, contig size, homozygous SNP density, heterozygous SNP density, way of calculating the homozygous to heterozygous ratio and location of the causal mutation.  

We assumed that homozygous SNPs are normally distributed and symmetric about their mean. The mean value correspond to the causal mutation position. In the model, heterozygous SNPs follow a uniform distribution, with no relevant contribution to the general SNP density. We created a VCF (Variant Call Format) file containing the SNP densities that give rise to the above distribution. Then, to emulate real data, we divide the model genome into fragments, which mimic contigs assembled from high-throughput sequencing (HTS) reads. Therefore, we have a FASTA file with the sequences of each fragment, and a VCF file with the SNPs on each fragment. In the model, each SNP is given an allele frequency of exactly 0.5 (heterozygous) or 1.0 (homozygous). 

We can then measure the ratio of homozygous to heterozygous SNPs on each fragment (**Fig. 1B**). We add 1 to both enumerator and denominator to avoid diving by 0. In our ideal model, the ratio will be maximum where the causative SNP is located.

First, SDM normalises the homozygous SNP density by dividing the absolute number of SNPs in each contig by the number of nucleotides (length). Then, it sorts the fragments by their SNP density values so that they follow a Gaussian distribution. It starts by taking the 2 lowest values that should be at both tails of the distribution. Following this fashion, we obtained the the right and left sides that build up the distribution. In the tails, we have a high density of contigs, so we cannot be sure about their order. However, the contigs surrounding the causal mutation are low in number and should be correctly ordered.  


######2. SDM detects the high SNP density peak with a negligible deviation from the expected peak when using model genomes (292)

To estimate the effect of the genome length, the model genomes ranged between 1 Mb and 15 Mb. To test the effect of the contig size, we used two minimum contig sizes (500 bp and 1000 bp) that gave rise to approximately 700 and 1300 contigs respectively. By providing a variable contig size, we can change the length of each contig in our model. The maximum size is calculated by doubling the minimum size provided. Consequently, each contig's size is randomly chosen within the range minimum-maximum.

We started using a high SNP density (1 SNP each 500 bp), with the causal mutation located in the middle of the distribution. In this way, we know where the mutation is located in the model genome and we can measure the deviation (**figure 2A. formula**)of SDM when trying to assess the mutation. To guarantee the confidence of SDM, we created 5 replicates for each condition and we calculate the average deviation from the causal mutation for all the genome sizes and contig sizes (**figure 2B bar chart 1-15**). In all the cases, we proved that SDM identified the high density peak with no significant effect of genome length and contig size. The deviation from the causal mutation assigned in the model was always lower than 0.5%, so we can conclude that our method was reliable to estimate the mutation under these conditions. In order to move on to less ideal genomes, we repeated the previous experiment by using the whole chromosome I and 3 different contig sizes. The results were similar to those for smaller genomes, and again we did not see any significant effect of genome length or contig size (**figure 2C bar chart, 30 Mb**). 

######3. A pre-filtering step based on homozygous to heterozygous SNPs ratio improves SDM accuracy (219)

SDM worked perfectly when the idealised causal mutation was located in the middle of the distribution (mean) as the number of fragments at both sides (right and left) was the same. However, when we shifted the causal mutation in our model to one side (one tail was longer than the other), SDM was not able to sort the contigs properly. The reason for this shift is that the contigs with the same SNP frequency are impossible to classify as belonging to the right or left tail. 

To fix this issue, we determined a threshold value based on the ratio of homozygous to heterozygous SNPs. In this way, the contigs with a ratio below the threshold are not considered in the analysis, and only those with a high ratio are sorted. In this way, the exact position in the genome cannot be determined but we can assess the contigs in which the mutation is more likely to be found, dismissing a great part of the genome that is hiding the causative mutation. To start with, we used different values as a threshold, from 0.5 to 2 (**Fig. 3**). 0.5 or 1 were enough for SDM to find the correct order. In the end, we standardised this value and used a 25% of the maximum ratio as threshold. 


######4. Confirmation of the causative mutations identified by bulk segregant analysis using Illumina sequencing and Arabidopsis as a reference genome (678)

We selected different sets of data of bulk segregant analysis of a mutation segregating in an out-cross or back-cross population. We performed convencional genome alignment to the reference genome using the reads provided in 4 different mapping-by-sequencing experiments  that succeed in identifying the mutation([@Galvao:2012], [@Allen:2013], [@Monaghan:2014], [Uchida:2014]]). The techniques used to identify the mutations were different in every case so we took advantage of this fact to confirm the reproducibility of the methods available. To reproduce the experiments, we aligned the Illumina paired-end reads to the *Arabidopsis thaliana* reference genome (TAIR10) after a quality filtering step. Then, we used VarScan for variant detection. After plotting the SNP densitiy (**Fig. 4A, pipeline**), we analysed the homozygous SNPs distribution in each chromosome and the ratio homozygous to heterozygous to confirm the genomic region where the mutations were described. SNPs with a frequency of 0.8 or larger were considered homozygous. 

In the first study, they generated a recombinant mapping population by outcrossing a Col-0 background mutant to the divergent accession Ler-0. The offspring were allowed to self-fertilize. A mutant pool of 119 F2 individuals was sequenced (we refer to this dataset as **OCF2**) [@Galvao:2012]. The two parental lines Col-0 and Ler-0 were also sequenced. Then, they performed conventional SHOREmap [@Schneeberger:2009] to identify the mutation causing late flowering which lied on chromosome 2, specifically on gene _SOC1_(18807538..18811047).

In an attempt to identify the gene involved in the Arabidopsis microRNA pathway, the mutants in the second study (**BCF2** dataset)[@Allen:2013] were generated by back-crossing a mutant to the non-mutagenized parental line followed by one round of self-fertilization. A pool of 110 mutant individuals showing leaf hyponasty and the non-mutagenized parental line mir159a were sequenced. They used different SNP callers that produced highly similar outcomes (NGM, SHOREmap, GATK and samtools)[@Austin:2011], [@Schneeberger:2009], [@DePristo:2011aa], [@Li:2009aa]. They identified the causal SNP mutation in _HASTY_, a gene on chromosome 3 (1401271..1408197). 

We also analysed a recent forward screen done in the immune-deficient bak1-5 background to identify novel components involved in plant immune signalling [@Monaghan:2014]. In this screen, after mutagenizing bak1-5 seeds (in the Col-0 ecotype) with EMS, they screened the M2 generation for modifier of **bak1-5 (mob) mutants** that restored immune signalling. To obtain the mutants, they back-crossed bak1-5 mob mutants to the parental line (bak1-5). F2 mutants and the parental line (bak1-5) were sequenced. They used CandiSNP [@Etherington:2014] to map the mutations and identified causal mutations in the gene encoding the calcium-dependent protein kinase CPK28 (26456285..26459631) for both bak1-5 mob1 and bak1-5 mob2.

The last mapping-by-sequencing study we used was obtained by outcrossing a Arabidopsis Wassilewskija (Ws-0) background mutant to Col-0 wild-type plants followed by sequecing of 88 F2 individuals and Ws and Col as parental lines [Uchida:2014]. They described a pipeline to identify the causal mutation based on the peaks obtained by plotting ratios of homozygous SNPs to heterozygous SNPs. By following this approach, they reported that the majority of SNPs detected on chromosome 4 were homozygous and they identified the sup#1 mutation on the _SGT1b_ gene (6851277..6853860). They also shown a homozygous peak on chromosome 1 due to the original transgene being located there. 

Once we obtained the homozygous SNP densities, we proceed to plot the homozygous and heterozygous SNP densities. For all the forward genetics screens under analysis we confirmed that there was a high homozygous SNP density in the genomic area where the causal SNP was previous described, suggesting a linkage of homozygous SNPs to the phenotype-altering SNP in a low recombination area. By plotting the densities in all the chromosomes after filtering, we could confirm that the high SNP density peak was unique for all the cases apart from one. The outcrossed sup#1 mutant also showed a peak in chromosome 1, but this was expected and described in the original report [Uchida:2014]. We divide the chromosomes in 100 kb fragments and calculate the ratios of homozygous SNPs to heterozygous SNPs as described by the formula in figure 1.A. We overlapped both homozygous and heterozygous densities and the ratio. The result is (**Fig. 4B, overlapping densities**). 

######5.Homozygous SNPs in forward genetics screens are normally distributed around the causative mutation (232)

After running a standardised variant calling approach with different sets of reads obtained from bulk segregant analysis, we showed a unique distribution peak  around the causative mutation. The next step was to know if this SNP distribution obtained correlated well with a theoretical probability distribution. For this aim, we built probability plots or Q-Q plots with the homozygous SNP densities in back-cross and out-cross experiments in Arabidopsis (**Fig. 4C, QQPlots**). Our results indicate that there is a good correlation between these distributions and a normal distribution. We further measure this correlation by a simple linear regression and the square of the correlation between the sample values and the predicted values was high for all the examples. The standard deviation, although variable between samples, oscillated between 3 and 7 Mb. 

We also analysed the shape of the distributions by measuring the kurtosis (**Table 1**). 4 of the 5 distributions were platykurtic, as they showed a negative kurtosis and consequently a lower, wider peak around the mean and thinner tails. Only one (sup#1) was leptokurtic (positive kurtosis). We also measured the skewness; this value implies that the distribution of the data is skewed to the left (or negatively skewed) or to the right (positively skewed). The skewness will depend on the location of the causal mutation in the chromosome, so as expected, we did not see any conserved tendency among the data (**Table 1**). 


<table>
  <tr><th>Sample <th>Number of homozygous SNPs</th><th>Chromosome</th><th>Correlation with normal distribution (r<sup>2</sup>)</th><th>Standard deviation (Mb)</th><th>Kurtosis</th><th>Skewness</th></tr>
  
  <tr><td> OCF2</th> <td>151</th> <td>2</th><td>0.949<td>6.01</th><td>1.85</th><td>-0.392</th>
  
  <tr><td> BCF2</th>  <td>15</th><td>3</th><td>0.959<td>3.20</th><td>2.02</th><td>0.201</th>
  
  <tr><td> bak1-5 mob1</td>  <td>25</th><td> 5</th><td>0.944<td>7.20 </th><td>2.69</th><td>-0.240</th>
  
  <tr><td>bak1-5 mob2 </td> <td>41</th> <td> 5</th><td>0.894<td>3.71</th><td>2.37</th><td>0.445</th>  
   
  <tr><td> sup#1</th>  <td>4633</th><td>4</th><td>0.976<td>3.66</th><td>3.50</th><td>0.370</th>
  
</table>


######6. Filtering background SNPs and centromeres improves normal correlation (200)

We filtered the background SNPs to reduce the complexity of the SNP lists  and improve the correlation to a normal distribution. The parental reads were subjected to the same variant calling approach and those SNPs that were present in both parental and mutant samples were removed from the mutant SNP list (**Figure 4.A, pipeline**, Additional file 1). The usefulness of removing non-unique SNPs is not new, and all the  mapping-by-sequencing  experiments we have chosen here did the same filtering to some extent. 

Also, SDM accuracy was improved when the we removed SNPs concentrated around centromeres. It was easy in this case since we were using *Arabidopsis thaliana* as a model organism and centromeres are defined in the genome assembly. However, for the long-term goal of the methodology proposed, we still have to develop some way to identify the variability due to the centromere. Many studies have shown the peculiarity of the centromere, so these sequences should be easy to identify. Centromeres are  characterised by  the presence of tandem repeats, and extremely high repeat abundance (often >10,000 copies per chromosome) [@Melters:2013aa].


######7. SDM identified the genomic region carrying the causal mutation previously found with other methods

As a final proof-of-concept, we used the SNP densities obtained from OCF2, BCF2, mob1-mob2 and sup#1 datasets (**Fig. 4A**) to create new model genomes. Again, we took the chromosomes where the mutations were described and split them into fragments of minimum size 100 kb (contig size ranges between 100 and 200 kb). The model genomes were created in the same way as explained above, but instead of using an idealised SNP density, we used the real SNP positions after parental filtering and removal of the centromeres. SDM generates several output files: a FASTA file with the ordered fragments, a Q-Qplot comparing the correlation between the homozygous SNP distribution after SDM and a the expected normal distribution (**Fig 6A**), a density plot with the hypothetical homozygous, heterozygous SNP densities and ratios (**Additional file**), a text file with the candidate contigs with the SNP positions they contain. As we know the correct order and the real ratio distribution, to test the performance of SDM, we create a plot comparing the hypothetical ratio distribution after SDM and the real one (**Fig. 6B**). 

In our case studies, the causal mutation estimation by SDM was more accurate in back-crosses (bak1-5 mutants and BCF2) than in out-crosses (OCF2 and sup#1). The number of segregating SNPs is lower in back-cross experiments (1 SNP every 65,000 bp)  compared to out-crosses (1 SNP every 900 bp) [@Etherington:2014]. Therefore, SDM was an easy way to perform bulk segregant linkage analysis from a back-crossed population without relying on the disponibility of a reference genome.

The large number of segregating SNPs in out-crosses complicate the assignation of a position in the normal distribution to a contig. For example, is more than 10 contigs contain 4 SNPs, there is no reliable way to discriminate between them by our approach. 

- Next:
 
Comparison of results obtained with SDM and the methods they used to find the mutation in the original study. 
Speed
Usefulness
Improvement

Ways of calculating the ratios (Additional result)