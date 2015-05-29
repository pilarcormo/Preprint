
#Identification of genomic regions carrying a causal mutation in unordered genomes.
#####*Pilar Corredor-Moreno*

Whole genome sequencing using Next-Generation Sequencing (NGS) technologies offers a unique opportunity to study genetic variations. However, mapping the mutations responsible for phenotypes is generally a tedious and time-consuming process. In the last few years, researchers have developed user-friendly tools for mapping-by-sequencing, yet they are not applicable to organisms with non-sequenced genomes.

We introduced SDM (SNP Distribution Method), a reference-free algorithm for rapid discovery of mutagen-induced homozygous mutations in forward genetics screens. For our purpose, a mutant individual is crossed to a non-mutant line followed by one generation of backcrossing of the heterozygous F1 samples.The offspring of this second cross gives rise to a recombinant population that will segregate for the mutant phenotype. SDM relies on the normal distribution of homozygous SNPs that are linked to the phenotype-altering SNP in a non-recombinant region. Consequently, the homozygous/heterozygous SNP ratio will be higher in this area where the SNP of interest is located.

First, to emulate real data, I created a model genome with the expected SNP density based on *Arabidopsis thaliana* chromosome I. I split it into fragments that imitate contigs assembled from NGS reads. SDM groups the contigs by their normalised homozygous SNP density and then arranges them so that they follow the expected SNP distribution. Then, as a proof-of-concept, I analysed the SNP distribution in recent outcross (Galvão et al. 2012; Uchida et al. 2014) and backcross experiments (Allen et al. 2013; Monaghan et al. 2014) in *Arabidopsis thaliana* backgrounds. In all the examples under analysis, homozygous SNPs are normally distributed around the causal mutation with a constant standard deviation. I used the real SNP densities obtained from these experiments to prove the efficiency and accuracy of SDM. It identified the genomic regions (10-100 kb) containing the causative mutations. We now aim to apply this method in a species without a reference genome available.

####References

Galvão, Vinicius C; Karl J V Nordström, Christa Lanz, Patric Sulz, Johannes Mathieu, David Posé, Markus Schmid, Detlef Weigel, and Korbinian Schneeberger. 2012. “Synteny-Based Mapping-by-Sequencing Enabled by Targeted Enrichment.” Plant J 71 (3): 517–26. doi:[10.1111/j.1365-313X.2012.04993.x.](http://dx.doi.org/10.1111/j.1365-313X.2012.04993.x)

Uchida, Naoyuki; Tomoaki Sakamoto, Masao Tasaka, and Tetsuya Kurata. 2014. “Identification of EMS-Induced Causal Mutations in Arabidopsis Thaliana by Next-Generation Sequencing.” Methods Mol Biol 1062: 259–70. doi:[10.1007/978-1-62703-580-4_14.](http://dx.doi.org/10.1007/978-1-62703-580-4_14)

Allen, Robert S; Kenlee Nakasugi, Rachel L Doran, Anthony A Millar, and Peter M Waterhouse. 2013. “Facile Mutant Identification via a Single Parental Backcross Method and Application of Whole Genome Sequencing Based Mapping Pipelines.” Front Plant Sci 4: 362. doi:[10.3389/fpls.2013.00362.](http://dx.doi.org/10.3389/fpls.2013.00362)

Monaghan, Jacqueline; Susanne Matschi, Oluwaseyi Shorinola, Hanna Rovenich, Alexandra Matei, Cécile Segonzac, Frederikke Gro Malinovsky, et al. 2014. “The Calcium-Dependent Protein Kinase CPK28 Buffers Plant Immunity and Regulates BIK1 Turnover.” Cell Host Microbe 16 (5): 605–15. doi:[10.1016/j.chom.2014.10.007.](http://dx.doi.org/10.1016/j.chom.2014.10.007)

