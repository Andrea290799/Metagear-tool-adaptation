
rm(list=ls())

# Install packages if necessary and load libraries:

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

if(!require(svDialogs)){
  install.packages("svDialogs")
  library(svDialogs)
}

if(!require(BiocManager)){
  install.packages("BiocManager")
  library(BiocManager)
}

if(!require(metagear)){
  BiocManager::install("EBImage", force = TRUE )
  install.packages("metagear")
  library(metagear)
}


d <- read_delim("allergy_final_new_list.txt") %>% dplyr::select(doi, title, abstract, year, journal) %>% select_if(~sum(!is.na(.)) > 0)
f1 <- read_delim("allergy_final_new_list.txt") %>% dplyr::select(doi, title, abstract, year, journal) %>% select_if(~sum(!is.na(.)) > 0)

# %>% dplyr::select(-1)   %>% dplyr::select(pmid, doi, title, abstract, year, journal)

f2 <- read_tsv("savedrecs.txt") %>% select_if(~sum(!is.na(.)) > 0) %>% dplyr::rename(doi=DI, title = TI, abstract = AB, year = PY, journal = SO) %>% dplyr::select(doi, title, abstract, year, journal)

# %>% dplyr::select(-c(BE, PT, AU, SE, CT, CY, CL, SP, AF, RI, OI, SN, EI, PD))

# Paste both tables in one by rows, sort by PMID and remove non distinct rows by PMID and DOI
unique_union_merged <- f1 %>% bind_rows(f2) %>% arrange(doi) %>% distinct(doi, .keep_all = TRUE)
# Save the merged tables in a CSV file
write_csv(unique_union_merged, "allergy_unique_union.csv")

# Recall the unique united file of PubMed and WoS
unique_union <- read_csv("allergy_unique_union.csv")



