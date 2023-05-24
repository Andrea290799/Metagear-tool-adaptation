if(!require(svDialogs)){
  install.packages("svDialogs")
  library(svDialogs)
}

if(!require(metagear)){
  BiocManager::install("EBImage", force = TRUE )
  install.packages("metagear")
  library(metagear)
}


if (file.exists("to_screen_final.csv")){
  
  BD <- read.table("to_screen_final.csv",
                   header = TRUE, sep = ",")
} else{
  
  BD <- read.table(file="to_screen.csv",
                   header = TRUE, sep = ",")
  BD$CHECK <- 0
  
  initial_message <- dlgMessage("Have you read README.docx file?", "yesno")$res
  
  if (initial_message == "no"){
    initial_message <- dlgMessage("Please, read it before starting")$res
    break
  }
  
}

new_info = c("POBLATION","SNPs","NOTES")



for (row in 1:length(BD[,1])){
  
  if (BD$CHECK[row] == 0){
    
    dlgMessage(c("Title:", BD$Title[row], "doi:", BD$doi[row], "Abstract:", BD$Abstract[row]))$res
    
    
    print(noquote("---------------------------------------------------------------------", ))
    print(noquote("Title:"))
    print(noquote(BD$Title[row]))
    print(noquote(" "))
    print(noquote("doi:"))
    print(noquote(BD$doi[row]))
    print(noquote("---------------------------------------------------------------------", ))
    
    dlgMessage("In the console you can find the title and the doi of the paper you are working on, so that you can copy paste them")$res
    
    additional_input = c()
    
    add_yes_no <- NULL
    
    additional_input = rep("-", length(new_info)+3)
    
    mandatory_info = c("DISORDER","GENE","PROTEIN")
    
    for (ai in mandatory_info){
      
      term2 <- NULL
      
      while(length(term2) == 0){
        
        term2 <- dlgInput(paste("Enter the new information in ", ai, " column.", sep = ""), Sys.info()["user"])$res
        
        if (length(term2) != 0){
          additional_input[which(mandatory_info == ai)] = term2
        }
      }
    }
    
    while (is.null(add_yes_no)){
      
      add_yes_no <- dlgMessage("Do you want to add any information in this paper?", "yesno")$res
      
      if (add_yes_no == "no"){
        
        next
        
      } 
      
      else{
        
        
        res <- dlg_list(new_info, multiple = TRUE)$res
        
        if (length(res)) {
          
          for (categorie in res){
            
            term2 <- dlgInput(paste("Enter the new information in ", categorie, " column.", sep = ""), Sys.info()["user"])$res
            
            if (length(term2)){
              additional_input[which(new_info == categorie)+3] = term2
            }else{
              next
            }
            
          }
          
        }
        
      }
      
    }
    
    if (length(additional_input)){ 
      BD$DISORDER[row] <- additional_input[1]
      BD$PROTEIN[row] <- additional_input[2]
      BD$GENE[row] <- additional_input[3]
      
      BD$POBLATION[row] <- additional_input[4]
      BD$SNPs[row] <- additional_input[5]
      BD$NOTES[row] <- additional_input[6]
      BD$CHECK[row] <- 1
    }
    
    exit_yes_no <- dlgMessage(paste("Do you want to continue with the next paper?"), "yesno")$res
    
    if (exit_yes_no == "no"){
      
      break
      
    } 
  }
}

if (length(which(BD$CHECK == 0)) == 0) {
  print("All abstracts have been checked!")
}

write.table(BD,
            file="to_screen_final.csv",
            append = FALSE, sep = ",")