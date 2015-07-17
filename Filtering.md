
Additonal 2. Workflow for parental SNP filtering in forward genetic screens
===

###mob mutants
####mob 1

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/m_mutants B.vcf B_chromosome$i $i cutting_vcf ; done
for i in {1..5} ; do ruby manage_vcf.rb Reads/m_mutants B_chromosome$i/chromosome$i.vcf interesting_$i $i filter_vcf parent/parent.vcf ;done
```
####mob2

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/m_mutants C.vcf C_chromosome$i $i cutting_vcf; done
for i in {1..5} ; do ruby manage_vcf.rb Reads/m_mutants C_chromosome$i/chromosome$i.vcf interesting_$i $i filter_vcf parent/parent.vcf ; done
``


###BCF2

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/BCF2 BCF2.vcf BCF2_chromosome$i $i cutting_vcf; done
for i in {1..5} ; do ruby manage_vcf.rb Reads/BCF2B CF2_chromosome$i/chromosome$i.vcf interesting_$i $i filter_vcf BCF2_parent/BCF2_parent.vcf; done
```

###OCF2

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/OCF2 OC_output.vcf OCF2_chromosome$i $i cutting_vcf; done
for i in {1..5} ; do ruby manage_vcf.rb Reads/OCF2 OCF2_chromosome$i/chromosome$i.vcf Interesting_$i $i filter_vcf Ler/OC_parent.vcf; done
```
###sup1

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/Aw_sup1-2/Variant_calling sup1.vcf sup1_chromosome$i $i cutting_vcf; done
mkdir sup1_beforefiltering
mv sup1_chromosome* /sup1_beforefiltering
```
######Filtering using Col-T 
	
```	
for i in {1..5} ; do ruby manage_vcf.rb Reads/Aw_sup1-2/Variant_calling sup1_beforefiltering/sup1_chromosome$i/chromosome$i.vcf sup1_Interesting_$i $i filter_vcf Parents/ColT.vcf; done
```

######Filtering using Ws-0

```
for i in {1..5} ; do ruby manage_vcf.rb Reads/Aw_sup1-2/Variant_calling sup1_afterCol_filtering/sup1_Interesting_$i/chromosome$I_interesting.vcf  interesting_$i $i filter_vcf Parents/ColT.vcf; done
```
