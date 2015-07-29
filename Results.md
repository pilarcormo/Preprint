3. Results and discussion
===

###3.1. SDM works over a range of effective genome lengths and realistic fragment sizes

We created model genomes based on _Arabidopsis thaliana_ chromosomes to develop our mutant identification method. By making customised genomes, we could rapidly alter different paramenters as genome length, contig size or SNP density to analyse their effect on the detection method accuracy. Our dinamic way of creating model genomes helped us define all the different aspects that should be taken into account when analysing the SNP distribution. Also, the causative mutation was defined manually by us, so we could measure the deviation between defined and predicted value. We generated the model genomes by asigning an idealised SNP distribution to a set of randomly shuffled sequences that imitate contigs assembled from HTS. In the model genomes, homozygous SNPs follow a normal distribution while heterozygous SNPs follow a uniform distribution. 

To estimate the effect of the genome length on SDM's ability to find the causative mutation, we created model genomes of different sizes ranging from 1 Mb to 15 Mb. We defined a variable contig length randomly ranging between a provided mininum value and its double. We used two minimum contig sizes (500 bp and 1000 bp) that gave rise to approximately 1300 and 700 contigs respectively. To guarantee the confidence of SDM, we created 5 replicates for each condition. 
For the second set of model genomes, we used the whole chromosome I length and a more realistic SNP density (1 SNP every 3000 bp). In this case, 3 contig sizes were employed (1000, 2000 and 4000 approximately).

The SNP Distribution Method (SDM) sorts the sequence fragments by their SNP density values (the score calculated as defined in section 2.2) so that they follow a normal distribution. Then, a second sorting step in which the contigs are also sorted by their ratio (calculated as defined in section 2.2) is applied. We considered the highest kernel density value for the SNP distribution after SDM sorting as the candidate SNP location and this value was compared to the peak of the normal distribution previously defined in the model genome. The difference was called 'deviation' and can be found in [**Fig.2**](Fig2/deviation_stata.png). Consistent results were obtained for all the replicates. SDM identified the high density peak with no significant effect of genome length and contig size. The deviation from the causative mutation assigned in the model was lower than 1% in the small SNP-riched genomes (Fig 2A). This was also true for the whole-sized genomes when they were divided in 1000 and 2000 contigs but not for the 4000 contigs (Fig 2B), where 4 replicates had a deviation between 1 and 3%. Even though the deviation is still low, the higher the number of contigs, the harder it is to get to the correct order. Also, as we did not change the SNP density, the SNPs are spreaded over more fragments and the sorting is more complicated. 


###3.2. A pre-filtering step based on the homozygous to heterozygous SNPs ratio improves SDM accuracy 

As explained in the previous section, SDM succeed in the high density peak identification in model genomes when the idealised causative mutation was located in the middle of the distribution as the number of fragments at both sides (right and left) was the same. However, this success is only true in the high SNP density area (peak of the distribution) and when we shifted the causal mutation in our model to one side (one tail was longer than the other), SDM was not able to sort the contigs in the tails properly. Even though the contigs located in the peak were those in which the mutation was defined, the algorithm was not able to classify the low density contigs as belonging to the right or left tail and the distribution peak appeared moved, giving rise to a high deviation from the defined peak. 

To fix the problem, we delimited a threshold value based on the ratio of homozygous to heterozygous SNPs to discard contigs located further away from the causative mutation. We excluded those contigs with a ratio below a given percentage (1%, 5%, 10% or 20%) of the maximum ratio. Therefore, only those contigs with a high ratio are sorted. Even though the exact position in the genome cannot be determined by this approach, we can assess the contigs in which the mutation is more likely to be found, dismissing a great part of the genome that is hiding the causative mutation. To test the influence of the threshold we used the whole chromosome I from *Arabdidopsis* as a model genome [(**Fig. 3**)](Fig3/ratios_5percent.png). The high density peak in the ratio distribution matched the expected when aproximately a 80-90% of the genome is discarded. In this case, the SNP density was high (1 SNP every 3000 bp) and the distribution peak was narrow. However, we cannot establish a standard threshold, since it will depend on the peak deviation on each case. To avoid lossing interesting mutations by being too strict with the filtering, we suggest using 1-5% of the maximum ratio to obtain optimal results. 


###3.3. Confirmation of the high SNP density peaks in several bulk segregant analysis using Illumina sequencing and Arabidopsis as a reference genome 

We selected different sets of data of bulk segregant analysis of a mutation segregating in an out-cross [@Galvao:2012], [@Uchida:2014] or back-cross [@Allen:2013], [@Monaghan:2014] population. We performed conventional genome alignment to the reference genome using the reads provided in the 4 mapping-by-sequencing experiments. The techniques used to identify the mutations were different in every case so we took advantage of this fact to confirm the reproducibility of the available methodology.  We aligned the Illumina paired-end reads to the *Arabidopsis thaliana* reference genome. Then, we used VarScan for variant calling. After plotting the SNP densitiy (**Additional file 4**), we analysed the homozygous SNPs distribution in each chromosome and the ratio of homozygous to heterozygous SNPs to confirm the genomic region where the mutations were described. 


In the first out-cross experiment we analysed (OCF2), Galvão et al identified the mutation causing late flowering which lied on chromosome 2, specifically on gene _SOC1_ (18807538..18811047) **[@Galvao. 2012]** . In the second study (BCF2) Allen at al analised the mutant individuals showing leaf hyponasty to identify a gene involved in the Arabidopsis microRNA pathway [@Allen et al. 2013]. They identified the causal SNP mutation in _HASTY_, a gene on chromosome 3 (1401271..1408197). Also, we used the reads from a forward screen done in the immune-deficient bak1-5 background aim identify new components involved in plant immunity. Monaghan et al found 2 causative mutations in the gene encoding the calcium-dependent protein kinase CPK28 (26456285..26459631) for both bak1-5 mob1 and bak1-5 mob2 [@Monaghan:2014]. In the last mapping-by-sequencing study we used, Uchida et al reported that the majority of SNPs detected on chromosome 4 were homozygous and they identified the sup#1 mutation on the _SGT1b_ gene (6851277..6853860) [@Uchida:2014].

+[DM 9] Often it is fine to use names IE 'Galvao et al', rather then 'they' 

Once we obtained the homozygous SNP densities, we proceed to plot the homozygous and heterozygous SNP densities. For all the forward genetics screens under analysis we confirmed that there was a high homozygous SNP density peak in the genomic area where the causal SNP was previously described (**Fig. 3**). These results corroborate the idea of linkage of homozygous SNPs to the phenotype-altering SNP in the region where recombination events are unlikely. 

The high homozygous density peaks were unique in the genome after filtering in all the studies except for the out-crossed sup#1 mutant,  where a high density peak was also found in chromosome I. This was expected and described in the original report [@Uchida:2014].


###3.4. Filtering background SNPs and centromeres unmasks the high homozygous SNP density peak 


We analysed the total number of homozygous SNPs in the chromosome where the causative mutation was located. As expected, when the mutant individual is out-crossed to a distant mapping line (OCF2 and sup#1), the SNP density is up to 20 times higher than in the case of back-crossing to the parental line (BCF2 and mob mutants). 
In the back-crossed populations, we identified approximately 1700 homozygous SNPs. That gives an overall density of 1 SNP every 15000 bp before filtering. We identified 9200 homozygoys SNPs in the chromosome of interest in the first out-crossed population (OCF2) and 27000 SNPs in the second out-crossed population (sup#1). The overall density was of 1 SNP every 2500 bp for OCF2 and 1 SNP every 700 bp for sup#1. 

Therefore, the filtering steps were specially crucial in the out-cross populations due to the starting high SNP density. Parental filtering was fundamental to reduce the SNP density. In the back-cross studies, the absolute homozygous SNP number was reduced up to 9 times **(Fig 7)** after parental filtering.  The total number of homozygous SNPs was reduced 3 times in out-crossed populations. Even though the centromere removal did not reduce the total number of SNPs in the same proportion as parental filtering did, it was essential to unmask the normal distribution around the causative mutation. The high variability in the few hundred of bp of centromere generate a high SNP density peak which hide the peak of interest. 

We filtered the background SNPs to reduce the complexity of the distribution and improve the degree of correlation to a bell curve. The parental reads were subjected to the same variant calling approach and those SNPs that were present in both parental and mutant samples were removed from the mutant SNP list (**Fig. 3B**) [DM 13]. The usefulness of removing non-unique SNPs is not new, and all the  mapping-by-sequencing  experiments we have chosen here did the same filtering to some extent. ([@Galvao:2012], [@Uchida:2014]], [@Allen:2013], [@Monaghan:2014])

SDM accuracy was improved when we removed SNPs concentrated around the centromeric regions (**Additional fig. 3**). Many studies have shown the centromeres peculiarity, characterised by  high repeat abundance (often >10,000 copies per chromosome) [@Melters:2013aa]. 

By filtering the background SNPs, we 

------
**NEW part about SNP density in back and out and the filtering**

The expected SNP density in the out-crosses (OCF2 and sup#1) is much higher than in back-crosses 

-----


###3.5. Homozygous SNPs in forward genetics screens are normally distributed around the causative mutation 

After running the standardised variant calling approach with the different data sets, we showed a unique peak in the SNP distribution around the causative mutation (**Fig. 3**). The next step was to analyse the correlation of the SNP distribution to a theoretical probability distribution. For this aim, we built probability plots or Q-Q plots with the homozygous SNP densities in the back-cross and out-cross experiments (**Fig. 4A**). Our results indicate that there is a good correlation between the homozygous SNP frequencies and a normal distribution. We further validated the correlation between the sample values and the predicted values by a simple linear regression (r<sup>2</sup> >0.9). The standard deviation, although variable between samples, oscillated between 3 and 7 Mb (**Table 1**). [DM 11] 
+
+[DM 11] So this is the evidence why 15 Mb is enough sequence to use! For this SNP density...!  

+We also analysed the shape of the distributions by measuring the kurtosis (**Table 1**). 4 of the 5 distributions were platykurtic [DM 12], as they showed a negative kurtosis and consequently a lower, wider peak around the mean and thinner tails. Only one (sup#1) was leptokurtic (positive kurtosis). We also measured the skewness; this value implies that the distribution of the data is skewed to the left (negatively skewed) or to the right (positively skewed). The skewness will depend on the location of the causal mutation in the chromosome, so as expected, we did not see any conserved tendency among the data (**Table 1**). 
+
+[DM 12] Nice stats words! Don't understand the signifcance of the observation (just a negative result - ie, no consistent bias, but then where is the centromere. Is it kurtotic in the direction of the centromere?)


###3.6. SDM identifies the genomic region carrying the causal mutation previously described by other methods

+As a final proof-of-concept, we used the SNP densities obtained from OCF2, BCF2, mob1, mob2 and sup#1 datasets and using the chromosomes where the mutations were described we split them into fragments of standard contig size [DM 15].
+
+[DM 15] As described in... Still not got a clear concept of how you would decide contig size.
+
+We regained the normal distribution for all the datasets after shuffling the contig order and running SDM (**Additional fig. 4**) [DM 16]. The correct contig order and real ratio distribution are known, so we created a plot comparing the hypothetical ratio distribution after SDM and the real one to test the performance of SDM (**Fig. 6B**). 
+
+[DM 16] There isnt an Additional Figure 4

+The causal mutation estimation by SDM was more accurate in back-crosses (bak1-5 mutants and BCF2) than in out-crosses (OCF2 and sup#1). The number of segregating SNPs is lower in back-cross experiments (1 SNP every 65,000 bp) compared to out-crosses (1 SNP every 900 bp) [@Etherington:2014]. The large number of segregating SNPs in out-crosses complicated the assignation of a position in the normal distribution to a contig. For example, if more than 2 contigs contain 4 SNPs [DM 17], there is no reliable way to discriminate between them and the problem gets worse when the number of contigs with the same number of SNPs increases. Hence, we added a feature to SDM to specify the type of cross before defining the candidate mutations.
+ 
+[DM 17] Unless the contigs are of different lengths so you have the higher rates in shorter contigs or the HOM/HET ratio is different

As expected, the number of candidate positions in back-cross experiments oscillates between 4 and 10 (**Table 2**) [DM 18].  SDM identified the causal mutation position in OCF2 (**Table 2**) even though the number of candidates was greater compared to the back-crosses. However, more than 100 candidate mutations out of several thousand SNPs were proposed for sup#1 in a very small region of the chromosome (100 kb) and the actual causal SNP was not in that list (**Table 2**). Therefore, out-crosses to a reference line would need more filtering steps to reduce the number of SNPs as they did in the original report [Uchida:2014]. We can conclude that SDM is a rapid and precise method to perform bulk segregant linkage analysis from back-crossed populations without relying on the disponibility of a reference genome, but we need to be cautious when dealing with out-cross experiments. [DM 19]

+[DM 18] Positions or contigs? And why expect 4 - 10? Not seen a justification for this. 
+[DM 19] Why is this happening? How are the distributions of SNPs different in the out-cross? Is it simply the mess of centromeric stuff? Too much het variation, so does providing a different score cut-off improve things. I miss the differences between the two.
+[DM 20] Figures are hard to follow. Didn't see a reference to Figure 5...


Conclusions
===

Forward genetic screens are very useful to identify genes responsible for particular phenotypes. Thanks to the advances in HTS technologies, mutant genomes sequencing has become quick and unexpensive. However, the mapping-by-sequencing methods available present certain limitations, complicating the mutation identification especially in non-sequenced species. To target this problem, we proposed a fast, reference genome independent method to identify causative mutations. We showed that homozygous SNPs are normally distributed in the mutant genome of back-cross and out-crossed individuals. Based on that idea, we defined a theoretical SNP distribution used by SDM to identify the genomic region where the causative mutation was located. We conclude that SDM is especially sucessful for analysing mutants obtained from a back-cross population. The increase in the number of SNPs in out-cross experiments complicated the genetic analysis and the mutation estimation. Ideally, over the next few years, sequencing costs will decrease and this will allow to sequence every mutant individual from a forward genetic screen. Therefore, we need fast and reliable methods to identify variants bypassing the reference genome assembly step. We now aim to improve and apply SDM in forward genetics screens of species where a reference genome is not yet available. We plan to develop an accessible software that will speed up gene finding in non-sequenced organisms. 


