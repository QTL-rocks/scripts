# Simulation

* [random mating](#random)


### random mating, LD
<div id="random" />

```julia
using XSim, DataFrames, Distributions

srand(314);

chrLength= 0.1 #length of each chromosome 
numChr   = 3   #number of chromosomes
nmarkers = 100 #number of loci for each chromosome
nQTL     = 1   #number of QTL for each chromosomefects,mutRate);

build_genome(numChr,chrLength,nmarkers,nQTL)

popSizeFounder = 500
sires = sampleFounders(popSizeFounder);
dams  = sampleFounders(popSizeFounder);

ngen,popSize=500,500
sires1,dams1,gen1=sampleRan(popSize,ngen,sires,dams);

ngen,popSize=5,8000
sires2,dams2,gen2=sampleRan(popSize,ngen,sires1,dams1);

animals=concatCohorts(sires2,dams2);

M = getOurGenotypes(animals);


nQTL=10
qtl1 = sample(1:100,nQTL,replace=false)
qtl2 = sample(101:200,nQTL,replace=false)
qtl3 = sample(201:300,nQTL,replace=false)
chr1 =M[:,qtl1]*randn(nQTL)
chr2 =M[:,qtl2]*randn(nQTL);
chr3 =M[:,qtl3]*rand(MvNormal([1.0 0.5;0.5 1.0]), nQTL)';

maf=vec(mean(M,1)/2);
select1=0.01.<maf.<0.99;
fixed=vec(var(M,1));
select2 = fixed.!=0;
select = select1 .& select2
M=M[:,select];

geno1=chr1+chr3[:,1]
geno2=chr2+chr3[:,2];

# scaling breeding values to have variance 25.0
v = var(geno1)
genVar = 1.0
geno1 *= sqrt(genVar/v)
# scaling breeding values to have variance 25.0
v = var(geno2)
genVar = 1.0
geno2 *= sqrt(genVar/v)

# formatted printing
@printf "genetic variances for t1 and t2       = %8.2f  %8.2f \n" var(geno1) var(geno2)
@printf "genetic correlation between t1 and t2 = %8.2f \n" cor(geno1,geno2)

n=8000
resVar1 = 4.0
resStd1 = sqrt(resVar1)
resVar2 = 0.25
resStd2 = sqrt(resVar2)

e1 = randn(n)*resStd1
e2 = randn(n)*resStd2

pheno1=geno1+e1
pheno2=geno2+e2
@printf "phenotypic variance for 1 and 2 = %8.2f %8.2f \n" var(pheno1) var(pheno2)

phenotypes=names!(convert(DataFrame,[pheno1 pheno2 geno1 geno2]),[:gall,:rustbin,:g_bv,:r_bv]);

writetable("phenotypes_sim.csv",phenotypes)
writedlm("genotype_sim.csv",M)
```
