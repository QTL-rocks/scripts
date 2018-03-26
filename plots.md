# Plots

* [(julia) Comparison of prediction accuracies of two methods with different traing size](#compare1)
* [(R,ggplot2) line plots](#lineplot)


#### Comparison of prediction accuracies of two methods with different traing size
<div id="compare1" />

```julia
#image in Genetics multi-trait paper
using DataFrames,Plots, RDatasets, StatPlots
trait1_C =[0.205615 0.301088 0.397173 0.570569 0.775526 0.866252 0.91152 0.9]'
trait1_CC=[0.193213 0.262757 0.354804 0.448909 0.648098 0.778168 0.854713 0.8]'

trait2_C =[0.430794 0.607342 0.802905 0.921048 0.976198 0.988749 0.994047 0.9]'
trait2_CC=[0.42951 0.586408 0.802252 0.919968 0.973285 0.986361 0.991894 0.9]';

pyplot()
x1=["50","100","200","400","1000","2000","4000","7000"];
#plot size
plot(size=(1200,350),layout=(1,2))

###########
#TRAIT 1
###########
#make plots with defined marker types and colors
plot!(x1,trait1_C,line=(:dash,1),color=:red,marker=(3,0.8),label="MT-BayesC-G",legend = :topleft)#bottomright
plot!(x1,trait1_CC,line=(:dashdot,1),color=:blue,marker=(3,0.8),label="MT-BayesC-R")

#add xaxis,yaxis,title
xaxis!("training-set size",font(12, "Courier"),subplot=1) #grid=false
yaxis!("prediction accuracy",(0.1,1.05),0.1:0.1:1.05,font(12, "Courier"),subplot=1) #name,ylims,yticks,fonts
title!("Trait 1 (heritability=0.2)",titlefont=font(12,"Courier"),subplot=1)

#add annotation
#annotate!([(1.5,trait1_C[2]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(2.5,trait1_C[3]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(3.5,trait1_C[4]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(4.5,trait1_C[5]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(5.5,trait1_C[6]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(6.5,trait1_C[7]+0.02,text("*",16,:red,:center))],subplot=1)
#annotate!([(7.5,trait1_C[8]+0.02,text("*",16,:red,:center))],subplot=1)

###########
#TRAIT 1
###########
#make plots with defined marker types and colors
plot!(x1,trait2_C,line=(:dash,1),color=:red,marker=(3,0.8),label="MT-BayesC-G",legend = :topleft,subplot=2)#bottomright
plot!(x1,trait2_CC,line=(:dashdot,1),color=:blue,marker=(3,0.8),label="MT-BayesC-R",subplot=2)

#add xaxis,yaxis,title
xaxis!("training-set size",font(12, "Courier"),subplot=2) #grid=false
yaxis!("prediction accuracy",(0.4,1.05),0.4:0.1:1.05,font(12, "Courier"),subplot=2) #name,ylims,yticks,fonts
title!("Trait 2 (heritability=0.8)",titlefont=font(12,"Courier"),subplot=2)

#add annotation
#annotate!([(1.5,trait2_C[2]+0.02,text("*",16,:red,:center))],subplot=2)
#annotate!([(4.5,trait2_C[5]+0.02,text("*",16,:red,:center))],subplot=2)
#annotate!([(5.5,trait2_C[6]+0.02,text("*",16,:red,:center))],subplot=2)
#annotate!([(6.5,trait2_C[7]+0.02,text("*",16,:red,:center))],subplot=2)
#annotate!([(7.5,trait2_C[8]+0.02,text("*",16,:red,:center))],subplot=2)
```

#### line plots in ggplot2
<div id="lineplot" />

```R
#line plots
#data
#trait           model           gen             corr            regr            pi             
#eah             BayesCPi        4                0.3286         0.8895         0.944998      
#eah             BayesCPi        5                0.3456         0.9439         0.960500      
#eah             BayesCPi        6                0.3565         1.0356         0.918984       
#eah             BayesB95        4                0.3316         0.6764         0.950000      
#eah             BayesB95        5                0.3323         0.6899         0.950000      
#eah             BayesB95        6                0.3455         0.7769         0.950000       
#

library(ggplot2)
pdf("eah1.pdf",width=8,height=6)
eah = read.table("eah.txt", header=TRUE)
plot = ggplot(subset(eah, model %in% c("QTLmodel","BayesNPi_allin","BayesCPi","BayesNPi","ssGBLUP")), aes(gen, corr, col=model))
plot = plot + stat_summary(fun.y=mean, geom="point",size=3)
plot = plot + stat_summary(fun.y=mean, geom="line",size=1)
#plot = plot + scale_colour_brewer(palette="Set1")
plot = plot + ylab("Correlation between GEBV and Phenotypes\n") + xlab("Number of Pedigree Generations")
plot = plot + theme_bw() + theme(legend.title=element_blank()) + theme(legend.key = element_blank())
plot = plot + scale_color_manual(values=c("#E69F00", "#009E73", "#0072B2", "red", "#CC79A7"))
#plot = plot + theme_set(theme_gray(base_size=2))
plot
dev.off()
```

