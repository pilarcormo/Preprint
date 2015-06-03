
Background 
===

~700 words

Forward genetic screens have been a fundamental strategy to find  genes involved in biological pathways in model species. Probably the most widely used mutagenesis strategy is the induction of guanine-to-adenine substitutions using ethylmethane sulfonate (EMS) [@Page:2002]. Genetic screens generally rely on the same basic principles. First, an individual with a phenotype of interest is isolated from a mutagenized population. Then, a recombinant mapping population is created by back-crossing to the parental line or out-crossing to a polymorphic ecotype [@Etherington:2014]. The recombinant population obtained from that cross will segregate for the mutant phenotype and individuals showing the mutant phenotype will carry the causal mutation, even if the genomic location is unknown. The recombination frequency between the causal mutation and nearby genetic markers is low, so the alleles of these linked genetic markers will co-segregate with the phenotype-altering mutation while the remaining unlinked makers segregate randomly in the genome [@Schneeberger:2014aa]. Hence, the allele distribution analysis can unhide these low recombinant regions to identify the location of the causal mutation. This process of genetic analysis is often referred to as bulk segregant analysis (BSA) [@Michelmore:1991aa].

However, traditional genetic mapping is a tedious and time-consuming process. Recent advances in deep sequencing have greatly accelerated the identification of mutations underlying mutant phenotypes in forward genetic screens.  Several methods as SHOREmap [@Schneeberger:2009], [@Sun:2015], NGM [@Austin:2011] or CandiSNP [@Etherington:2014] based on bulked-segregant analysis of F2 progeny have succeed in the mutant identification in *Arabidopsis thaliana*. However, all these methods depend on a first mapping step to a reference genome. This requirement makes these methods not applicable to species for wich a reference genome is not yet available. Alternative solutions as using reference sequences of related species have been proposed [@Wurtzel:2010], [@Livaja:2013aa]. However, the need for low sequence divergence and high levels of synteny between the mutant reads and the related reference sequence have restained the application of this approach [@Schneeberger:2014aa],[@Nordstrom:2013aa].

Currently, a great effort is being made to obtain reference sequences for the major species. Yet, even with a reference sequence available, the mutant screening approach present certain limitations. Fast-evolving genes such as disease resistance genes [@Song:2003aa] might be absent or divergent from the reference genome or it might be difficult to define a single reference sequence in metagenomic studies [@Fonseca:2010aa]. Also, reference genomes in higher eukaryotes have gaps what can lead to an incorrect mapping.  The development of de novo assembly technologies based on PacBio or Illumina long-read sequencing have reduced the computational time required to obtain a draft genome and allow the obtention of data to close gaps and address low quality regions in existing genome assemblies [@Koren:2015aa, @Kim:2014aa]. With these technologies, the N50 contig length may reach several kilobases, so we hope these draft genomes can speed up bulk segregant analysis based on sequencing.

In the last few years, several reference-free methods for mutation identification have been proposed [Iqbal:2012aa], [Nordstrom:2013aa], [@Minevich:2012aa], [@Abe:2012] to solve the reference sequence restriction. For example, NIKS  relies on the analysis of k-mers, which are defined as sub-sequences of length k within the NGS data of different samples. By using these short-read assemblies, the mutant reads pool and the wild-type pool (or a second mutant pool) can be compared to select fixed differences among them [@Nordstrom:2013aa]. In the case of Mutmap, mutant identifcation is independent of recombination or genetic crosses. It also relies on a comparison between different mutant reads. When independent mutant alleles of the same gene are found, this gene is prioritized as the putative causative gene [@Abe:2012], [@Takagi:2015aa], [@Schneeberger:2014aa]. Even if these methodologies are promising, they are restricted to certain types of crosses and are computationally complex [@Etherington:2014]. 

Here we propose a fast mutant identification method based on a simple reference-free contig assembly that allows the detection of SNPs. Instead of relying on a genome comparison, we focus on the SNP linkage around the causal mutation. We analysed the SNP distribution to identify the chromosome area where the putative mutated gene is located. SDM does not rely on previously known genetic markers and it does not need a reference genome, instead it sorts the contigs by their SNP density. 

We recently selected different datasets from previous studies in which a mutated gene was identified in a out-cross or back-cross population [@Galvao:2012], [@Allen:2013], [@Monaghan:2014], [@Uchida:2014]. These studies confirmed by different methods the gene responsible for the mutant phenotype so they were a good starting point to avoid taking shots in the dark. SDM was proven to be fast and accurate and opens up many possibilities for forward genetic screens in those species for which a reference sequence is not available. 

####Version with references

Forward genetic screens have been a fundamental strategy to find genes involved in biological pathways in model species. Probably the most widely used mutagenesis strategy is the induction of guanine-to-adenine substitutions using ethylmethane sulfonate (EMS) [1]. Genetic screens generally rely on the same basic principles. First, an individual with a phenotype of interest is isolated from a mutagenized population. Then, a recombinant mapping population is created by back-crossing to the parental line or out-crossing to a polymorphic ecotype [2]. The recombinant population obtained from that cross will segregate for the mutant phenotype and individuals showing the mutant phenotype will carry the causal mutation, even if the genomic location is unknown. The recombination frequency between the causal mutation and nearby genetic markers is low, so the alleles of these linked genetic markers will co-segregate with the phenotype-altering mutation while the remaining unlinked makers segregate randomly in the genome [3]. Hence, the allele distribution analysis can unhide these low recombinant regions to identify the location of the causal mutation. This process of genetic analysis is often referred to as bulk segregant analysis (BSA) [4].

However, traditional genetic mapping is a tedious and time-consuming process. Recent advances in deep sequencing have greatly accelerated the identification of mutations underlying mutant phenotypes in forward genetic screens. Several methods as SHOREmap [5, 6], NGM [7] or CandiSNP [2] based on bulked-segregant analysis of F2 progeny have succeed in the mutant identification in Arabidopsis thaliana. However, all these methods depend on a first mapping step to a reference genome. This requierement limits its application to species for wich a reference genome is not yet available. Alternative solutions as using references sequences of related species have been proposed [8, 9]. However, the need of low sequence divergence and high levels of synteny between the mutant reads and the related reference sequence have restained the application of this approach.

Currently, a great effort is being made to obtain reference sequences for the major species. Yet, even with a reference sequence available, the mutant screening approach present certain limitations. Fast-evolving genes such as disease resistance genes [10] might be absent or divergent from the reference genome or it might be difficult to define a single reference sequence in metagenomic studies [11]. Also, reference genomes in higher eukaryotes have gaps what can lead to an incorrect mapping. The development of de novo assembly technologies based on PacBio or Illumina long-read sequencing have reduced the computational time required to obtain a draft genome and allow the obtention of data to close gaps and address low quality regions in existing genome assemblies [12]. With these technologies, the N50 contig length may reach several kilobases, so we hope these draft genomes can speed up bulk segregant analysis based on sequencing.

In the last few years, several reference-free methods for mutation identification have been proposed [14, 15, 16, 17] to solve the reference sequence restriction by different approaches. For example, NIKS relies on the analysis of k-mers, which are defined as sub-sequences of length k within the NGS data of different samples. By using these short-read assemblies, the mutant reads pool and the wild-type pool (or a second mutant pool) can be compared to select fixed differences among them [15]. In the case of Mutmap, mutant identifcation is independent of recombination or genetic crosses. It also relies on a comparison between different mutant reads. When independent mutant alleles of the same gene are found, this gene is prioritized as the putative causative gene [3, 17, 18]. Even if these methodologies are promising, they are restricted to certain types of crosses and are computationally complex [2].

Following the same kind of idea, we propose a fast mutant identification method based on a simple reference-free contig assembly that allows the detection of genetic variants. Instead of relying on a genome comparison, we focus on the SNP linkage around the causal mutation in bulk segregant analysis. We analysed the SNP distribution to identify the chromosome area where the putative mutated gene is located. The SNP Distribution Method (SDM) first calculates the homozygous SNPs to heterozygous SNPs (Hom/het) ratio. Ideally, due to the marker linkage to the causal mutation, the ratio will be higher in the low recombinant genomic region. Then, after analysing the homozygous SNP distribution in different bulk segregant analysis, we could define a standard expected SNP distrbution. Based on it, SDM sorts the contigs that have a high Hom/het ratio so that they approach the expected distribution. It does not rely on previously known genetic markers and it does not need a reference genome. It gives an estimation of the expected order of homozygous SNPs in the area where the linkage to the causal mutation occurs.

As a proof-of-concept to test SDM accuracy, we recently selected different datasets from previous studies in which a mutated gene was identified in a out-cross or back-cross population [19, 20, 21, 22]. These studies confirmed by different methods the gene responsible for the mutant phenotype so they were a good starting point to avoid taking shots in the dark. SDM was proven to be fast and accurate and opens up many possibilities for forward genetic screens in those species for which a reference sequence is not available. Over the next few years, sequencing costs will go down and this will allow us to sequence every mutant individual from a forward genetic screen.

#####References

1. Page DR, Grossniklaus U: The art and design of genetic screens: Arabidopsis thaliana. Nat Rev Genet 2002, 3:124–36.

2. Etherington GJ, Monaghan J, Zipfel C, MacLean D: Mapping mutations in plant genomes with the user-friendly web application candiSNP. Plant Methods 2014, 10:41.

3. Schneeberger K: Using next-generation sequencing to isolate mutant genes from forward genetic screens. Nat Rev Genet 2014, 15:662–76.

4. Michelmore RW, Paran I, Kesseli RV: Identification of markers linked to disease-resistance genes by bulked segregant analysis: A rapid method to detect markers in specific genomic regions by using segregating populations. Proc Natl Acad Sci U S A 1991, 88:9828–32.

5. Schneeberger K, Ossowski S, Lanz C, Juul T, Petersen AH, Nielsen KL, Jørgensen J-E, Weigel D, Andersen SU: SHOREmap: Simultaneous mapping and mutation identification by deep sequencing. Nat Methods 2009, 6:550–1.

6. Sun H, Schneeberger K: SHOREmap v3.0: Fast and accurate identification of causal mutations from forward genetic screens. Methods Mol Biol 2015, 1284:381–95.

7. Austin RS, Vidaurre D, Stamatiou G, Breit R, Provart NJ, Bonetta D, Zhang J, Fung P, Gong Y, Wang PW, McCourt P, Guttman DS: Next-generation mapping of arabidopsis genes. Plant J 2011, 67:715–25.

8. Wurtzel O, Dori-Bachash M, Pietrokovski S, Jurkevitch E, Sorek R: Mutation detection with next-generation resequencing through a mediator genome. PLoS One 2010, 5:e15628.

9. Livaja M, Wang Y, Wieckhorst S, Haseneyer G, Seidel M, Hahn V, Knapp SJ, Taudien S, Schön C-C, Bauer E: BSTA: A targeted approach combines bulked segregant analysis with next- generation sequencing and de novo transcriptome assembly for sNP discovery in sunflower. BMC Genomics 2013, 14:628.

10. Song J, Bradeen JM, Naess SK, Raasch JA, Wielgus SM, Haberlach GT, Liu J, Kuang H, Austin-Phillips S, Buell CR, Helgeson JP, Jiang J: Gene rB cloned from solanum bulbocastanum confers broad spectrum resistance to potato late blight. Proc Natl Acad Sci U S A 2003, 100:9128–33.

11. Fonseca VG, Carvalho GR, Sung W, Johnson HF, Power DM, Neill SP, Packer M, Blaxter ML, Lambshead PJD, Thomas WK, Creer S: Second-generation environmental sequencing unmasks marine metazoan biodiversity. Nat Commun 2010, 1:98.

12. Koren S, Phillippy AM: One chromosome, one contig: Complete microbial genomes from long-read sequencing and assembly. Curr Opin Microbiol 2015, 23:110–20.

13. Kim KE, Peluso P, Babayan P, Yeadon PJ, Yu C, Fisher WW, Chin C-S, Rapicavoli NA, Rank DR, Li J, Catcheside DEA, Celniker SE, Phillippy AM, Bergman CM, Landolin JM: Long-read, whole-genome shotgun sequence data for five model organisms. Sci Data 2014, 1:140045.

14. Iqbal Z, Caccamo M, Turner I, Flicek P, McVean G: De novo assembly and genotyping of variants using colored de bruijn graphs. Nat Genet 2012, 44:226–32.

15. Nordström KJV, Albani MC, James GV, Gutjahr C, Hartwig B, Turck F, Paszkowski U, Coupland G, Schneeberger K: Mutation identification by direct comparison of whole-genome sequencing data from mutant and wild-type individuals using k-mers. Nat Biotechnol 2013, 31:325–30.

16. Minevich G, Park DS, Blankenberg D, Poole RJ, Hobert O: CloudMap: A cloud-based pipeline for analysis of mutant genome sequences. Genetics 2012, 192:1249–69.

17. Abe A, Kosugi S, Yoshida K, Natsume S, Takagi H, Kanzaki H, Matsumura H, Yoshida K, Mitsuoka C, Tamiru M, Innan H, Cano L, Kamoun S, Terauchi R: Genome sequencing reveals agronomically important loci in rice using mutMap. Nat Biotechnol 2012, 30:174–8.

18. Takagi H, Tamiru M, Abe A, Yoshida K, Uemura A, Yaegashi H, Obara T, Oikawa K, Utsushi H, Kanzaki E, Mitsuoka C, Natsume S, Kosugi S, Kanzaki H, Matsumura H, Urasaki N, Kamoun S, Terauchi R: MutMap accelerates breeding of a salt-tolerant rice cultivar. Nat Biotechnol 2015, 33:445–9.

19. Galvão VC, Nordström KJV, Lanz C, Sulz P, Mathieu J, Posé D, Schmid M, Weigel D, Schneeberger K: Synteny-based mapping-by-sequencing enabled by targeted enrichment. Plant J 2012, 71:517–26.

20. Allen RS, Nakasugi K, Doran RL, Millar AA, Waterhouse PM: Facile mutant identification via a single parental backcross method and application of whole genome sequencing based mapping pipelines. Front Plant Sci 2013, 4:362.

21. Monaghan J, Matschi S, Shorinola O, Rovenich H, Matei A, Segonzac C, Malinovsky FG, Rathjen JP, MacLean D, Romeis T, Zipfel C: The calcium-dependent protein kinase cPK28 buffers plant immunity and regulates bIK1 turnover. Cell Host Microbe 2014, 16:605–15.

22. Uchida N, Sakamoto T, Tasaka M, Kurata T: Identification of eMS-induced causal mutations in arabidopsis thaliana by next-generation sequencing. Methods Mol Biol 2014, 1062:259–70.








