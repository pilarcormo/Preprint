Supplementary Figure 1. Method workflow 
===

####Quality filtering for paired-end reads

```
FastQC/fastqc reads_R1.fq
FastQC/fastqc reads_R2.fq
```

```
java -jar Trimmomatic-0.33/trimmomatic-0.33.jar PE reads_R1.fq reads_R2.fq paired_R1.fq unpaired_R1.fq paired_R2.fq unpaired_R2.fq  SLIDINGWINDOW:4:20 MINLEN:70"
```

####Command line parameters used for paired-end read mapping and SNP calling

The reference genome was indexed before running the alingment and SNP calling pipeline. 

```
bwa index TAIR10.fa
```

```
desc "Align using bwa"
task :bwa  do
      sh 'bwa mem TAIR10.fa paired_R1.fq paired_R2.fq > alignment.sam'
end
```
```
desc "Convert sam to bam file"
task :bam => ["bwa"] do
    sh 'samtools view -bS alignment.sam | samtools sort -m 30000000000 - alignment'
end
```
```
desc "Write pileup file"
task :pileup => ["bam"] do
        sh 'samtools mpileup -B -f TAIR10.fa alignment.bam > SNPs.pileup'
end
```
```
desc "run VarScan"
task :varscan  => ["pileup"] do 
        sh 'java -jar VarScan.v2.3.7.jar mpileup2snp SNPs.pileup --output-vcf 1 > SNPs.vcf'
end
```


Supplementary Methods

SDM pipeline calculates the ratio hom/het for each contig and then uses this value as a threshold to discard the contigs located far from the causal mutation. 
The ratio of homozygous to heterozygous SNPs on a contig n is defined as the sum homozygous SNPs on n plus 1 divided by the sum of heterozygous SNPs plus 1. An allele frequency of 0.8 or larger is required for homozygous SNPs:

$Ratio_{n} = \frac{(\sum Hom) + 1}{(\sum Het) + 1}$

If the filtering step is required, the threshold astringency is provided as an integer (1, 5, 10, 20). Each integer represents the percentage of the maximum ratio below which a contig will be discarded. In example, if 1 is specified, SDM will discard those contigs with a ratio falling below 1% of the maximum ratio while a value of 20 is more astringent  will discard those contigs with a ratio falling below 20% of the maximum ratio.





$Score_{n} = \frac{\sum Hom}{length_{n}}$

Contigs that fall below a certain percentage of the maximum ratio. 


Options

>1% maximum ratio
>2% maximum ratio
>10% maximum ratio
>20% maximum ratio



$Deviation = \frac{|Candidate - Causal|}{Length}$
