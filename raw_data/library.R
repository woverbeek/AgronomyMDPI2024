# Librairie
## Base
if (!"devtools" %in% installed.packages()[, "Package"]) {install.packages("devtools")}
if (!"BiocManager" %in% installed.packages()[, "Package"]) {install.packages("BiocManager")}

## BiocManager
if (!"phyloseq" %in% installed.packages()[, "Package"]) {BiocManager::install("phyloseq")}
if (!"DESeq2" %in% installed.packages()[, "Package"]) {BiocManager::install("DESeq2")}
if (!"Biostrings" %in% installed.packages()[, "Package"]) {BiocManager::install("Biostrings")}
if (!"biomformat" %in% installed.packages()[, "Package"]) {BiocManager::install("biomformat")}

## devtools
if (!"ampvis2" %in% installed.packages()[, "Package"]) {devtools::install_github("MadsAlbertsen/ampvis2")}
if (!"pairwiseAdonis" %in% installed.packages()[, "Package"]) {devtools::install_github("pmartinezarbizu/pairwiseAdonis/pairwiseAdonis")}
if (!"qiime2R" %in% installed.packages()[, "Package"]) {devtools::install_github("jbisanz/qiime2R")}

## CRAN
if (!"officer" %in% installed.packages()[, "Package"]) {install.packages("officer")}
if (!"vegan" %in% installed.packages()[, "Package"]) {install.packages("vegan")}
if (!"lme4" %in% installed.packages()[, "Package"]) {install.packages("lme4")}
if (!"nlme" %in% installed.packages()[, "Package"]) {install.packages("nlme")}
if (!"AICcmodavg" %in% installed.packages()[, "Package"]) {install.packages("AICcmodavg")}
if (!"VennDiagram" %in% installed.packages()[, "Package"]) {install.packages("VennDiagram")}
if (!"vegan" %in% installed.packages()[, "Package"]) {install.packages("vegan")}
if (!"MuMIn" %in% installed.packages()[, "Package"]) {install.packages("MuMIn")}
if (!"lmerTest" %in% installed.packages()[, "Package"]) {install.packages("lmerTest")}
if (!"compositions" %in% installed.packages()[, "Package"]) {install.packages("compositions")}
if (!"emmeans" %in% installed.packages()[, "Package"]) {install.packages("emmeans")}

# ipak function: install and load multiple R packages. source: https://gist.github.com/stevenworthington/3178163
# check to see if packages are installed. Install them if they are not, then load them into the R session.

ipak <- function(){
  pkg <- c("ggplot2", "phyloseq", "RColorBrewer", "ggpubr", "tidyverse", "multcompView", 
           "data.table", "scales", "ggforce", "DESeq2", "grid", "gridExtra", "lattice", 
           "concaveman", "ampvis2", "MASS", "nlme", "lme4", "AICcmodavg", "VennDiagram",
           "vegan", "MuMIn", "lmerTest", "compositions", "emmeans")
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) {install.packages(new.pkg, dependencies = TRUE)}
  sapply(pkg, require, character.only = TRUE)
}


