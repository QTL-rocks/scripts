# BLMM

* [replications](#rep)

### replications
<div id="rep" />

```awk
using DataFrames, JWAS

srand(314);

input="400"
PATH="."


p=200
train_size=parse(Int64,input)

p_chromosome = Int64(p/2)

M=readdlm(PATH*"/genotype_sim.csv");
data=readtable(PATH*"/phenotypes_sim.csv");

geno_test=M[(end-499):end,:]
pheno_test=data[(end-499):end,:];
bv1=pheno_test[:,3]
bv2=pheno_test[:,4];

trainpool=collect(1:7500);

#srand(314)

niter=10
res=zeros(2,niter);


for i=1:niter
    #file_marker_effects="marker_"*string(train_size)*"_"*string(i)*".txt"
    
    println("validation ",i)
    train = sample(trainpool,train_size, replace=true)

    R=[4.0 0;0 0.25]
    model_equations = "gall = intercept;
                       rustbin = intercept";
    model = build_model(model_equations,R);

    G=[0.01 0;0 0.01]



    #add_markers(model,M[train,:],G,header=false,G_is_marker_variance=true);
    
    maf=vec(mean(M[train,:],1)/2);
    select1=0.01.<maf.<0.99;
    fixed=vec(var(M[train,:],1));
    select2 = fixed.!=0;
    select = select1 & select2
    Mtrain=M[train,select];

    add_markers(model,Mtrain,G,header=false,G_is_marker_variance=true);

    Pi=Dict([1.0; 1.0]=>0.0,[1.0; 0.0]=>0.995,[0.0; 1.0]=>0.005,[0.0; 0.0]=>0.0)
    @time out=runMCMC(model,data[train,:],Pi=Pi,estimatePi=true,chain_length=10000,
    printout_frequency=10005,printout_MCMCinfo=false,methods="BayesC");

    #writedlm(file_marker_effects,out["Posterior mean of marker effects"][1]')
    #writedlm(file_marker_effects,out["Posterior mean of marker effects"][2]')
    ebv1= geno_test[:,select]*out["Posterior mean of marker effects"][1]
    ebv2= geno_test[:,select]*out["Posterior mean of marker effects"][2]
    @printf "accuracies for trait 1 and 2 = %8.2f %8.2f \n\n\n" cor(bv1,ebv1) cor(bv2,ebv2)
    res[1,i]=cor(bv1,ebv1)
    res[2,i]=cor(bv2,ebv2)
end
writedlm(PATH*"/BayesC"*input*".txt",res)

```
