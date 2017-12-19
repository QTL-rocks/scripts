# code tasks

* [remove leading spaces](#remove_leading_spaces)
* [check number of columns (same)](#check_number_of_columns)
* [subtract phenotypes](#subtract_phenotypes)
* [recode genotypes](#recode_genotypes)
* [associated array](#associated_array)
* [bash for Julia scripts](#bash_for_Julia_scripts)


### remove leading spaces
<div id="remove_leading_spaces" />

```awk
#file (leading space before a,b,c)
# a 1 2
# b 1 0
# c 1 1

awk 'BEGIN{OFS=" "}{$1=$1;print}' file
```

### check number of columns (same)
<div id="check_number_of_columns" />

```awk
#check number of columns
awk '{print NF;exit}' file

#check whether number of columns same
awk -F"|" -v expectFldCnt=2 '{
  if (NF==expectFldCnt) { print ":everything OK" ; }
   else { print "ERR: " NF "!=" expectFldCnt  ":" $0 > "errorFile" }
   }' \
map.txt relation.txt
```

### subtract phenotypes
<div id="subtract_phenotypes" />

```awk
#PHENOTYPE, PEDIGREE AND FIXED EFFECTS
phenotypeFile="phens_eblup.csv"
awk 'BEGIN{FS=","};NR>1{print $1,$2,$3,$5,$8}' $phenotypeFile > pheno.out 
awk 'BEGIN{FS=","};NR==1{print $1,$2,$3,$5,$8}' $phenotypeFile > pheno.header 
```

### recode genotypes
<div id="recode_genotypes" />

```shell
#/bin/bash/

#GENOTYPE
genotypeFile="1234"

#replace 0,1,2 with -1,0,1 // regular format //remove header
sed -e 's/0/-1/g' -e 's/\ 1/\ 0/g' -e 's/2/1/g' $genotypeFile|awk 'BEGIN{OFS=" "}{$1=$1;print}' |awk 'NR>1{print $0}'  > geno.out

echo "Genotypes have been coded as -1,0,1."
echo "Header of the genotype file has been removed."
```

### associated array
<div id="associated_array" />

```awk
#print match lines without sorting link
#http://stackoverflow.com/questions/15065818/compare-files-with-awk

awk 'NR==FNR{a[$1];next} ($1 in a) {print $1}' file1 file2

#It is same as(but confusing)
awk 'FNR==NR{a[$1]++;next}a[$1]'  file1 file2

#show frequency of elements in an array
awk '{a[$1]+=1}END{for (key in a)print key,a[key]}' data.txt
```

### bash for Julia scripts
<div id="bash_for_Julia_scripts" />

```shell
#!/bin/bash

RunName=BayesC0
for tr in BFT CWT EMA MAR
do
        Gen=`grep ${tr} refVC | awk '{print $2}'`
        Res=`grep ${tr} refVC | awk '{print $3}'`
        if [ ${tr} == "BFT" ]
          then
           PPI=$"0.95"
        elif [ ${tr} == "CWT" ]
          then
           PPI=$"0.98"
        elif [ ${tr} == "EMA" ]
          then
           PPI=$"0.95"
        else
           PPI=$"0.8"
        fi
        echo ${tr} $Gen $Res
        [[ ! -d ${tr} ]] && mkdir ${tr}
        cd ${tr}
        for vn in {1..5}
        do
                [[ ! -d v${vn} ]] && mkdir v${vn}
                cd v${vn}
                echo "Creating Julia Scripts for ${RunName} trait : ${tr} validation No. : ${vn}"
                echo "using JWAS" > ${RunName}_${tr}${vn}.jl
                echo "myOption=Dict()"  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["run"]           = \"BayesC\""  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["seed"]          = 314"  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["chainLength"]   = 5000"  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["probFixed"]     = 0.95"  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["estimatePi"]    = \"no\""  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["estimateScale"] = \"no\""  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["varGenotypic"]  = ${Gen}"  >> ${RunName}_${tr}${vn}.jl
                echo "myOption["varResidual"]   = ${Res}"  >> ${RunName}_${tr}${vn}.jl
                echo "PhenoFile  =\"../../../01_Data/forValidation/${tr}/${tr}t.${vn}\"" >> ${RunName}_${tr}${vn}.jl
                echo "y = map(Float64,readdlm(phenoFile)[2:end,2])" >> ${RunName}_${tr}${vn}.jl
                echo "GenoFile   =\"../../../01_Data/forValidation/\"" >> ${RunName}_${tr}${vn}.jl
                echo "X = map(Float64,readdlm(GenoFile)[2:end,2])" >> ${RunName}_${tr}${vn}.jl

                echo "output = runJWAS(myOption,X,y)"  >> ${RunName}_${tr}${vn}.jl
                echo "Validation =\"../../../01_Data/forValidation/${tr}/${tr}v${vn}\"" >> ${RunName}_${tr}${vn}.jl
                echo "df = readtable(Validation, eltypes =[UTF8String, Float64], separator = ' ',header=false,names=[:ID,:EBV]);" >> ${RunName}_${tr}${vn}.jl
                echo "comp=join(out,df,on=:ID);" >> ${RunName}_${tr}${vn}.jl
                echo "PHEBVcorr=cor(comp[:EBV],comp[:EBV_1])" >> ${RunName}_${tr}${vn}.jl
                echo "writedlm(\"PHEBVcorr_${RunName}_${tr}${vn}\",PHEBVcorr)" >> ${RunName}_${tr}${vn}.jl
                cd ..
        done 
        cd ..
done

```

