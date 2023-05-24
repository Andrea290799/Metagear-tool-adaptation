rm(list=ls())
#install.packages("readxl")
library(readxl)
#install.packages("BiocManager")
#BiocManager::install("EBImage")
#install.packages("metagear")
library(metagear)
#install.packages("BiocManager"); 
#BiocManager::install("EBImage")


f1 <- read.delim('savedrecs.txt', header=TRUE, sep="\,") # tab delimited file provides one txt file from Web of science results
#f1 <- read_excel('Libro2.xls') #it can be asked in xls file

f1$REVIEWERS = 'Mery'
f1$INCLUDE = "not vetted"
names(f1)[which(names(f1)=='title')] = 'title'
names(f1)[which(names(f1)=='abstract')] = 'abstract'
write.csv(f1,'to_screen.csv')

abstract_screener(file=("to_screen.csv"),aReviewer='Mery', abstractColumnName ='abstract', titleColumnName ='title')



