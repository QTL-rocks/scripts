# resources:
# Installation: https://asreml.kb.vsni.co.uk/wp-content/uploads/sites/3/ASReml-R-4-all-OS-Installation-Guide.pdf
# 1. Youtube chanel: VSN International (search for ASReml-R)
# 2. ASReml-R Reference Manual (https://asreml.kb.vsni.co.uk/wp-content/uploads/sites/3/2018/02/ASReml-R-Reference-Manual-4.pdf)

setwd("~/Desktop/JiayiQu/UCD_PhD/RRM/ASREML-R")
library(asreml)

### GBLUP using ASReml-R
# Read phenotypic data
datag = read.table("./data/PhenotApple.txt", header = T, na.strings = "NA")

# defining factors
datag$INDIV = as.factor(datag$INDIV)
str(datag)

# reading AHAT inverse (sparse format)
ginv = read.table("./data/G-Inv.txt", header = T)
head(ginv)

# preparing Ginverse(s)
attr(ginv, "rowNames") = as.character(datag$INDIV)
attr(ginv,"colNames") = as.character(datag$INDIV)
attr(ginv,"INVERSE") = TRUE
head(ginv)

#fitting a GBLUP model 
modelGBLUP = asreml(fixed = JUI_MOT~1,
                    random = ~vm(INDIV,ginv),
                    workspace = 128e06,
                    data = datag)

help(vm)
plot(modelGBLUP)
summary(modelGBLUP)$varcomp
h2 = vpredict(modelGBLUP,h2~V1/(V1+V2))
h2

#obtaining predictions - BLUP
BLUP = summary(modelGBLUP, coef=T)$coef.random
BLUP
cor(datag$JUI_MOT, BLUP, method = "pearson", use = "complete.obs")

## Repeated Measures in ASReml-R 

library(ggplot2)

head(grassUV) 
tail(grassUV)
ggplot(data = grassUV, aes(x = Time, y = y, group = Plant, color = Plant)) + geom_line() + facet_grid(.~Tmt)

grass #### Uniform Model

# Uniform Model
grassUV.uniform = asreml(y ~ Tmt + Time + Tmt:Time, 
                         residual = ~ Plant:cor(Time), 
                         data = grassUV)
summary(grassUV.uniform)$bic

# Multivariate 
grass.uniform = asreml(cbind(y1,y3,y5,y7,y10) ~ trait + Tmt + trait:Tmt, 
                       residual = ~ Plant:cor(trait), 
                       data = grass)
summary(grass.uniform)$bic

### Power Model
# conver to univariate

grassConvert = reshape(grass, direction = "long", varying = 3:7, sep = "")
grassConvert = grassConvert[order(grassConvert$Plant, grassConvert$time), ]
grassConvert$time = factor(grassConvert$time)

#Univariate 
grassUV.power = asreml(y ~ Tmt + Time + Tmt:Time, 
                       residual = ~ Plant:exp(Time), 
                       data = grassUV)
summary(grassUV.power)$bic
plot(grassUV$Time, grassUV.power$resid)

### Heterogeneous Power Model
grassUV.hetpower = grassUV.power = asreml(y ~ Tmt + Time + Tmt:Time, 
                                          residual = ~ Plant:exph(Time), 
                                          data = grassUV)
summary(grassUV.hetpower)$bic


### Antedependence Model of order 1

#Univariate

grassUV.ante = asreml(y ~ Tmt + Time + Tmt:Time, 
                      residual = ~Plant:ante(Time),
                      data = grassUV)
summary(grassUV.ante)$bic

#Multivariate
grass.ante = asreml(cbind(y1,y3,y5,y7,y10) ~ trait + Tmt + trait:Tmt,
                    residual = ~Plant:ante(trait),
                    data = grass)
summary(grass.ante)$bic


### Unstructured Model 

#Univariate

grassUV.us = asreml(y ~ Tmt + Time + Tmt:Time, 
                      residual = ~Plant:us(Time),
                      data = grassUV)
summary(grassUV.us)$bic

#Multivariate
grass.us = asreml(cbind(y1,y3,y5,y7,y10) ~ trait + Tmt + trait:Tmt,
                    residual = ~Plant:us(trait),
                    data = grass)
summary(grass.us)$bic

### BICs
summary(grassUV.uniform)$bic
summary(grassUV.power)$bic
summary(grassUV.hetpower)$bic
summary(grassUV.ante)$bic
summary(grassUV.us)$bic

### Wald tests for chosen model (fixed effects)
# Univariate 
wald(grassUV.ante)

# Multivariate
wald(grass.ante)

### Predicted treatment by time means
# Univariate 
predict(grassUV.ante, classify = "Tmt:Time")

# Multivariate 
predict(grass.ante, classify = "Tmt:trait")


### Split Plot Design  using ASReml-R

data(oats)
View(oats)
str(oats)

# split plot design analysis model 
oats.asr = asreml(fixed = yield ~ Variety + Nitrogen + Variety:Nitrogen,
                  random = ~ Blocks + Blocks:Wplots, # or Blocks/Wplots
                 data = oats) 
# look at the residuals
plot(oats.asr)
# summarise the variance components
summary(oats.asr)$varcomp
# fixed (or random) effects 
summary(oats.asr, coef = T)$coef.fixed
summary(oats.asr,coef = T)$coef.random
# Incremental Wald F tests
# denDF = "none" and ssType = "invremental" (the defaults)
wald(oats.asr, denDF = "default")

# Prediction
oatsN.pv = predict(oats.asr, classify = "Nitrogen", sed = T)
str(oatsN.pv)

# predicted means
oatsN.pv$pvals
# full matrix of SEDs
oatsN.pv$sed
# minimum, mean and maximum SED
oatsN.pv$avsed


