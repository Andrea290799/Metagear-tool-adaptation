
rm(list=ls())

# Install packages if necessary and load libraries:
if(!require(easyPubMed)){
  install.packages("easyPubMed")
  library(easyPubMed)
}

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(kableExtra)){
  install.packages("kableExtra")
  library(kableExtra)
}


# Build up the query and get PubMed IDs
my_query <- "(((Regulatory T lymphocytes[Text Word] OR Interleukin-10[Text Word] OR Transforming Growth Factor beta[Text Word] OR FOXP3[Text Word] OR CTLA4[Text Word] OR LAG3[Text Word] OR TIM3[Text Word] OR Interleukin-35[Text Word] OR GITR[Text Word] OR OX40[Text Word] OR CD40L[Text Word]) AND (allerg*[Text Word] OR atop*[Text Word] OR asthm*[Text Word] OR allergic,rhinitis[Text Word]) AND (GWAS[Text Word] OR Exome[Text Word] OR genome[Text Word] OR SNPs[Text Word] OR polimorphism[Text Word] OR mutation[Text Word]) AND humans[MeSH Terms]) NOT review*[Publication Type]) AND English[Language])"
my_query_IDs <- get_pubmed_ids(my_query)

# Fetch data (6000 results)
my_abstracts_xml <- fetch_pubmed_data(my_query_IDs, retmax = 6000, format = "xml", encoding = "UTF8")

# Store Pubmed Records as elements of a list
all_xml <- articles_to_list(my_abstracts_xml)

# Perform operation (use lapply here, no further parameters)
final_df <- do.call(rbind, lapply(all_xml, article_to_df,
                                  max_chars = -1, getAuthors = FALSE))

# Show an excerpt of the results
final_df[,c("pmid", "doi", "year", "abstract")]  %>%
  head() %>% kable() %>% kable_styling(bootstrap_options = 'striped')

write_delim(final_df,"allergy_final_new_list.txt") #, sep = "\t", row.names = TRUE, col.names = NA)
