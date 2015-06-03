[Abstract.md](https://github.com/pilarcormo/Preprint/blob/master/Abstract.md)

#Identification of genomic regions carrying a causal mutation in unordered genomes.

Whole genome sequencing using Next-Generation Sequencing (NGS) technologies offers a unique opportunity to study genetic variations. However, mapping the mutations responsible for phenotypes is generally a tedious and time-consuming process. In the last few years, researchers have developed user-friendly tools for mapping-by-sequencing, yet they are not applicable to organisms with non-sequenced genomes.

We introduced SDM (SNP Distribution Method), a reference independent method for rapid discovery of mutagen-induced homozygous mutations in forward genetics screens. For our purpose, a mutant individual is crossed to a non-mutant line followed by one generation of backcrossing of the heterozygous F1 samples.The offspring of this second cross gives rise to a recombinant population that will segregate for the mutant phenotype. SDM relies on the normal distribution of homozygous SNPs that are linked to the phenotype-altering SNP in a non-recombinant region. Consequently, the homozygous/heterozygous SNP ratio will be higher in this area where the SNP of interest is located.

First, to emulate real data, we created model genomes with the expected SNP density based on *Arabidopsis thaliana* chromosome I. We split it into fragments that imitate contigs assembled from NGS reads. SDM groups the contigs by their normalised homozygous SNP density and then arranges them so that they follow the expected SNP distribution. Then, as a proof-of-concept, we analysed the SNP distribution in recent out-cross [@Galvão et al. 2012], [@Uchida et al. 2014] and back-cross experiments [@Allen et al. 2013], [@Monaghan et al. 2014] in *Arabidopsis thaliana* backgrounds. In all the examples we analysed, homozygous SNPs were normally distributed around the causal mutation. We used the real SNP densities obtained from these experiments to prove the efficiency and accuracy of SDM. It succeed in the identification of the genomic regions (10-100 kb) containing the causative mutations. We now aim to apply this method in a species without a reference genome available.

[Background.md](https://github.com/pilarcormo/Preprint/blob/master/Background.md)

Background 
===

Forward genetic screens have been a fundamental strategy to find  genes involved in biological pathways in model species. Probably the most widely used mutagenesis strategy is the induction of guanine-to-adenine substitutions using ethylmethane sulfonate (EMS) [@Page:2002]. Genetic screens generally rely on the same basic principles. First, an individual with a phenotype of interest is isolated from a mutagenized population. Then, a recombinant mapping population is created by back-crossing to the parental line or out-crossing to a polymorphic ecotype [@Etherington:2014]. The recombinant population obtained from that cross will segregate for the mutant phenotype and individuals showing the mutant phenotype will carry the causal mutation, even if the genomic location is unknown. The recombination frequency between the causal mutation and nearby genetic markers is low, so the alleles of these linked genetic markers will co-segregate with the phenotype-altering mutation while the remaining unlinked makers segregate randomly in the genome [@Schneeberger:2014aa]. Hence, the allele distribution analysis can unhide these low recombinant regions to identify the location of the causal mutation. This process of genetic analysis is often referred to as bulk segregant analysis (BSA) [@Michelmore:1991aa].

However, traditional genetic mapping is a tedious and time-consuming process. Recent advances in deep sequencing have greatly accelerated the identification of mutations underlying mutant phenotypes in forward genetic screens.  Several methods as SHOREmap [@Schneeberger:2009], [@Sun:2015], NGM [@Austin:2011] or CandiSNP [@Etherington:2014] based on bulked-segregant analysis of F2 progeny have succeed in the mutant identification in *Arabidopsis thaliana*. However, all these methods depend on a first mapping step to a reference genome. This requirement makes these methods not applicable to species for wich a reference genome is not yet available. Alternative solutions as using reference sequences of related species have been proposed [@Wurtzel:2010], [@Livaja:2013aa]. However, the need for low sequence divergence and high levels of synteny between the mutant reads and the related reference sequence have restained the application of this approach [@Schneeberger:2014aa],[@Nordstrom:2013aa].

Currently, a great effort is being made to obtain reference sequences for the major species. Yet, even with a reference sequence available, the mutant screening approach present certain limitations. Fast-evolving genes such as disease resistance genes [@Song:2003aa] might be absent or divergent from the reference genome or it might be difficult to define a single reference sequence in metagenomic studies [@Fonseca:2010aa]. Also, reference genomes in higher eukaryotes have gaps what can lead to an incorrect mapping.  The development of de novo assembly technologies based on PacBio or Illumina long-read sequencing have reduced the computational time required to obtain a draft genome and allow the obtention of data to close gaps and address low quality regions in existing genome assemblies [@Koren:2015aa, @Kim:2014aa]. With these technologies, the N50 contig length may reach several kilobases, so we hope these draft genomes can speed up bulk segregant analysis based on sequencing.

In the last few years, several reference-free methods for mutation identification have been proposed [Iqbal:2012aa], [Nordstrom:2013aa], [@Minevich:2012aa], [@Abe:2012] to solve the reference sequence restriction. For example, NIKS  relies on the analysis of k-mers, which are defined as sub-sequences of length k within the NGS data of different samples. By using these short-read assemblies, the mutant reads pool and the wild-type pool (or a second mutant pool) can be compared to select fixed differences among them [@Nordstrom:2013aa]. In the case of Mutmap, mutant identifcation is independent of recombination or genetic crosses. It also relies on a comparison between different mutant reads. When independent mutant alleles of the same gene are found, this gene is prioritized as the putative causative gene [@Abe:2012], [@Takagi:2015aa], [@Schneeberger:2014aa]. Even if these methodologies are promising, they are restricted to certain types of crosses and are computationally complex [@Etherington:2014]. 

Here we propose a fast mutant identification method based on a simple reference-free contig assembly that allows the detection of SNPs. Instead of relying on a genome comparison, we focus on the SNP linkage around the causal mutation. We analysed the SNP distribution to identify the chromosome area where the putative mutated gene is located. SDM does not rely on previously known genetic markers and it does not need a reference genome, instead it sorts the contigs by their SNP density. 

We recently selected different datasets from previous studies in which a mutated gene was identified in a out-cross or back-cross population [@Galvao:2012], [@Allen:2013], [@Monaghan:2014], [@Uchida:2014]. These studies confirmed by different methods the gene responsible for the mutant phenotype so they were a good starting point to avoid taking shots in the dark. SDM was proven to be fast and accurate and opens up many possibilities for forward genetic screens in those species for which a reference sequence is not available. 

[Methods.md](https://github.com/pilarcormo/Preprint/blob/master/Methods.md)

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

[Results.md](https://github.com/pilarcormo/Preprint/blob/master/Results.md)
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

**Additional file 3**. Comparison of density plots before and after removing the background SNPs and the centromere. 

**Additional file 4** Density plots after SDM

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


#References
1. Page DR, Grossniklaus U: The art and design of genetic screens: Arabidopsis thaliana. Nat Rev Genet 2002, 3:124–36.

2. Etherington GJ, Monaghan J, Zipfel C, MacLean D: Mapping mutations in plant genomes with the user-friendly web application candiSNP. Plant Methods 2014, 10:41.

3. Schneeberger K: Using next-generation sequencing to isolate mutant genes from forward genetic screens. Nat Rev Genet 2014, 15:662–76.

4. Michelmore RW, Paran I, Kesseli RV: Identification of markers linked to disease-resistance genes by bulked segregant analysis: A rapid method to detect markers in specific genomic regions by using segregating populations. Proc Natl Acad Sci U S A 1991, 88:9828–32.

5. Schneeberger K, Ossowski S, Lanz C, Juul T, Petersen AH, Nielsen KL, Jørgensen J-E, Weigel D, Andersen SU: SHOREmap: Simultaneous mapping and mutation identification by deep sequencing. Nat Methods 2009, 6:550–1.

6. Sun H, Schneeberger K: SHOREmap v3.0: Fast and accurate identification of causal mutations from forward genetic screens. Methods Mol Biol 2015, 1284:381–95.

7. Austin RS, Vidaurre D, Stamatiou G, Breit R, Provart NJ, Bonetta D, Zhang J, Fung P, Gong Y, Wang PW, McCourt P, Guttman DS: Next-generation mapping of arabidopsis genes. Plant J 2011, 67:715–25.

8. Wurtzel O, Dori-Bachash M, Pietrokovski S, Jurkevitch E, Sorek R: Mutation detection with next-generation resequencing through a mediator genome. PLoS One 2010, 5:e15628.

9. Livaja M, Wang Y, Wieckhorst S, Haseneyer G, Seidel M, Hahn V, Knapp SJ, Taudien S, Schön C-C, Bauer E: BSTA: A targeted approach combines bulked segregant analysis with next- generation sequencing and de novo transcriptome assembly for sNP discovery in sunflower. BMC Genomics 2013, 14:628.

10. Nordström KJV, Albani MC, James GV, Gutjahr C, Hartwig B, Turck F, Paszkowski U, Coupland G, Schneeberger K: Mutation identification by direct comparison of whole-genome sequencing data from mutant and wild-type individuals using k-mers. Nat Biotechnol 2013, 31:325–30.

11. Song J, Bradeen JM, Naess SK, Raasch JA, Wielgus SM, Haberlach GT, Liu J, Kuang H, Austin-Phillips S, Buell CR, Helgeson JP, Jiang J: Gene rB cloned from solanum bulbocastanum confers broad spectrum resistance to potato late blight. Proc Natl Acad Sci U S A 2003, 100:9128–33.

12. Fonseca VG, Carvalho GR, Sung W, Johnson HF, Power DM, Neill SP, Packer M, Blaxter ML, Lambshead PJD, Thomas WK, Creer S: Second-generation environmental sequencing unmasks marine metazoan biodiversity. Nat Commun 2010, 1:98.

13. Koren S, Phillippy AM: One chromosome, one contig: Complete microbial genomes from long-read sequencing and assembly. Curr Opin Microbiol 2015, 23:110–20.

14. Kim KE, Peluso P, Babayan P, Yeadon PJ, Yu C, Fisher WW, Chin C-S, Rapicavoli NA, Rank DR, Li J, Catcheside DEA, Celniker SE, Phillippy AM, Bergman CM, Landolin JM: Long-read, whole-genome shotgun sequence data for five model organisms. Sci Data 2014, 1:140045.

15. Minevich G, Park DS, Blankenberg D, Poole RJ, Hobert O: CloudMap: A cloud-based pipeline for analysis of mutant genome sequences. Genetics 2012, 192:1249–69.

16. Abe A, Kosugi S, Yoshida K, Natsume S, Takagi H, Kanzaki H, Matsumura H, Yoshida K, Mitsuoka C, Tamiru M, Innan H, Cano L, Kamoun S, Terauchi R: Genome sequencing reveals agronomically important loci in rice using mutMap. Nat Biotechnol 2012, 30:174–8.

17. Takagi H, Tamiru M, Abe A, Yoshida K, Uemura A, Yaegashi H, Obara T, Oikawa K, Utsushi H, Kanzaki E, Mitsuoka C, Natsume S, Kosugi S, Kanzaki H, Matsumura H, Urasaki N, Kamoun S, Terauchi R: MutMap accelerates breeding of a salt-tolerant rice cultivar. Nat Biotechnol 2015, 33:445–9.

18. Galvão VC, Nordström KJV, Lanz C, Sulz P, Mathieu J, Posé D, Schmid M, Weigel D, Schneeberger K: Synteny-based mapping-by-sequencing enabled by targeted enrichment. Plant J 2012, 71:517–26.

19. Allen RS, Nakasugi K, Doran RL, Millar AA, Waterhouse PM: Facile mutant identification via a single parental backcross method and application of whole genome sequencing based mapping pipelines. Front Plant Sci 2013, 4:362.

20. Monaghan J, Matschi S, Shorinola O, Rovenich H, Matei A, Segonzac C, Malinovsky FG, Rathjen JP, MacLean D, Romeis T, Zipfel C: The calcium-dependent protein kinase cPK28 buffers plant immunity and regulates bIK1 turnover. Cell Host Microbe 2014, 16:605–15.

21. Uchida N, Sakamoto T, Tasaka M, Kurata T: Identification of eMS-induced causal mutations in arabidopsis thaliana by next-generation sequencing. Methods Mol Biol 2014, 1062:259–70.

22. Bolger AM, Lohse M, Usadel B: Trimmomatic: A flexible trimmer for illumina sequence data. Bioinformatics 2014, 30:2114–20.

23. Li H, Durbin R: Fast and accurate long-read alignment with burrows-wheeler transform. Bioinformatics 2010, 26:589–95.

24. Koboldt DC, Zhang Q, Larson DE, Shen D, McLellan MD, Lin L, Miller CA, Mardis ER, Ding L, Wilson RK: VarScan 2: Somatic mutation and copy number alteration discovery in cancer by exome sequencing. Genome Res 2012, 22:568–76.

25. Koboldt DC, Chen K, Wylie T, Larson DE, McLellan MD, Mardis ER, Weinstock GM, Wilson RK, Ding L: VarScan: Variant detection in massively parallel sequencing of individual and pooled samples. Bioinformatics 2009, 25:2283–5.

26. Team RDC: R: A Language and Environment for Statistical Computing. Vienna, Austria: R Foundation for Statistical Computing; 2011.

27. Komsta L, Novomestky F: Moments, Cumulants, Skewness, Kurtosis and Related Tests. 2015.

28. Lamesch P, Berardini TZ, Li D, Swarbreck D, Wilks C, Sasidharan R, Muller R, Dreher K, Alexander DL, Garcia-Hernandez M, Karthikeyan AS, Lee CH, Nelson WD, Ploetz L, Singh S, Wensel A, Huala E: The arabidopsis information resource (tAIR): Improved gene annotation and new tools. Nucleic Acids Res 2012, 40(Database issue):D1202–10.

29. DePristo MA, Banks E, Poplin R, Garimella KV, Maguire JR, Hartl C, Philippakis AA, Angel G del, Rivas MA, Hanna M, McKenna A, Fennell TJ, Kernytsky AM, Sivachenko AY, Cibulskis K, Gabriel SB, Altshuler D, Daly MJ: A framework for variation discovery and genotyping using next-generation dNA sequencing data. Nat Genet 2011, 43:491–8.

30. Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R, 1000 Genome Project Data Processing Subgroup: The sequence alignment/Map format and sAMtools. Bioinformatics 2009, 25:2078–9.

31. Melters DP, Bradnam KR, Young HA, Telis N, May MR, Ruby JG, Sebra R, Peluso P, Eid J, Rank D, Garcia JF, DeRisi JL, Smith T, Tobias C, Ross-Ibarra J, Korf I, Chan SWL: Comparative analysis of tandem repeats from hundreds of species reveals unique insights into centromere evolution. Genome Biol 2013, 14:R10.


Tables1.md


<table>
  <tr><th>Sample <th>Number of homozygous SNPs</th><th>Chromosome</th><th>Correlation with normal distribution (r<sup>2</sup>)</th><th>Standard deviation (Mb)</th><th>Kurtosis</th><th>Skewness</th></tr>
  
  <tr><td> OCF2</th> <td>151</th> <td>2</th><td>0.949<td>6.01</th><td>1.85</th><td>-0.392</th>
  
  <tr><td> BCF2</th>  <td>15</th><td>3</th><td>0.959<td>3.20</th><td>2.02</th><td>0.201</th>
  
  <tr><td> bak1-5 mob1</td>  <td>25</th><td> 5</th><td>0.944<td>7.20 </th><td>2.69</th><td>-0.240</th>
  
  <tr><td>bak1-5 mob2 </td> <td>41</th> <td> 5</th><td>0.894<td>3.71</th><td>2.37</th><td>0.445</th>  
   
  <tr><td> sup#1</th>  <td>4633</th><td>4</th><td>0.976<td>3.66</th><td>3.50</th><td>0.370</th>
  
</table>


**Table 1**. Measurement of the correlation between the homozygous SNP density in several out-cross and back-cross experiments and a theoretical normal distribution. Analysis of variance and distribution shape. 

<table>
  <tr><th>Sample <th>Type of cross</th><th>Chromosome</th><th>Mutated gene and position</th><th>Number of candidate mutations</th><th>Hypothetical candidate mutations from SDM</tr></th>

 <tr><td> OCF2</td> <td> Out-cross</td> <td> 2</td><td>SOC1 (18807538..18811047)<td>28  <td> 9773,
 22178,
 23681,
 33496,
 55086,
 112447,
 11857798,
 11905532,
 11905533,
 11910437,
 11958727,
 17312141,
 17360989,
 17363726,
 17418367,
 17421593,
 17435968,
 18774111,
 18779106,
 18808927,
 18816626,
 18908972,
 18946473,
 19181359,
 19237195,
 19308373,
 19309911,
 19352435 </td>  
   <tr><td> BCF2</td> <td> Back-cross</td> <td> 3</td><td>HASTY (1401271..1408197)<td> 4 <td> 1405085, 4919240, 6035523, 10163762</td>  
  <tr><td> bak1-5 mob1</td><td> Back-cross</td>  <td> 5</td><td>CPK28 (26456285..26459631)<td> 9 <td>11186761,
 11202828,
 11211636,
 11218614,
 18036595,
 18155812,
 26457834,
 26458077,
 26474069</td>  
  <tr><td> bak1-5 mob2</td><td> Back-cross</td>  <td> 5</td><td>CPK28 (26456285..26459631)<td> 10 <td>18143387,
 18218877,
 18251689,
 18261108,
 22049050,
 22066915,
 26560691,
 26626055,
 26710709,
 26716839
 </td>  
   <tr><td> sup#1</td> <td> Out-cross</td> <td> 4</td><td>SGT1b (6851277..6853860)<td>151<td> 7910430..8076837</td>    
</table>

**Table 2**. Hypothetical candidate mutations obtained by SDM in out-cross and back-cross experiments and real mutation positions. (For simplicity, the 151 candidate positions predicted for sup#1 were not itemised here).