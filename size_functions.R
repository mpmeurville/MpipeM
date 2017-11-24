
#Subset + cleaning of data. Only files with same names and different sizes 
#@ df, dataframe with cols size and file for 2 different dates, early AND late. 

subset_diff_files <- function (df)
{
  
  different_files= df[df$sizelate == '|',]
  names(different_files)<- c('sizeearly', 'fileearly', '|', 'sizelate', 'filelate')
  
  
  #### Formating sizes of files:10^3 = K, 10^6 = M, 10^9 = G in different_files dataframe
  
  different_files$sizeearly=gsub('K', 'e3', different_files$sizeearly)
  different_files$sizelate=gsub('K', 'e3', different_files$sizelate)
  
  different_files$sizeearly=gsub('M', 'e6', different_files$sizeearly)
  different_files$sizelate=gsub('M', 'e6', different_files$sizelate)
  
  
  different_files$sizeearly=gsub('G', 'e9', different_files$sizeearly)
  different_files$sizelate=gsub('G', 'e9', different_files$sizelate)
  
  
  different_files$sizeearly=as.numeric(different_files$sizeearly)
  different_files$sizelate=as.numeric(different_files$sizelate)
  
  #### Deletion of folders (late and early with their overall size) that are identical: we have already files inside these folder, so idenical folders were redundant
  different_files= different_files[with(different_files, grepl('.+\\....$', filelate)),]
  
  #### Deletion of .log files (added when untar), and .tar files
  different_files=different_files[!grepl('\\.log', different_files$filelate),]
  different_files=different_files[!grepl('\\.log', different_files$fileearly),]
  different_files=different_files[!grepl('\\.tar', different_files$filelate),]
  different_files=different_files[!grepl('\\.tar', different_files$fileearly),]
 different_files=different_files[!grepl('\\.sql', different_files$filelate),]
  different_files=different_files[!grepl('\\.sql', different_files$fileearly),]

  
  #### Deletion of useless cols, with signs, or empty cases
  different_files=different_files[, c(1,2,4,5)]
  
  #### Deletion of rows with empty cases
  different_files=different_files[complete.cases(different_files),]
  
  return (different_files)
  
}

#returns a table with files only present in early folder. Log files have been deleted. 
#@df, data frame with file early and size early

subset_unique_filesInearly <- function (df){
  
  unique_filesInearly= subset(df, sizelate=='<')
  names(unique_filesInearly)<- c('sizeearly', 'fileearly', '<', 'junk', 'junk')
  
  #### Formating sizes of files:10^3 = K, 10^6 = M, 10^9 = G in unique_filesInearly dataframe
  unique_filesInearly$sizeearly=gsub('K', 'e3', unique_filesInearly$sizeearly)
  unique_filesInearly$sizeearly=gsub('M', 'e6', unique_filesInearly$sizeearly)
  unique_filesInearly$sizeearly=gsub('G', 'e9', unique_filesInearly$sizeearly)
  
  unique_filesInearly$sizeearly=as.numeric(unique_filesInearly$sizeearly)
  
  #### Deletion of useless cols, with signs, or empty cases
  unique_filesInearly=unique_filesInearly[, c(1,2)]
  unique_filesInearly=unique_filesInearly[complete.cases(unique_filesInearly),]
  
  #### Deletion of .log files (added when untar), and .tar files
  unique_filesInearly=unique_filesInearly[!grepl('\\.log', unique_filesInearly$fileearly),]
  unique_filesInearly=unique_filesInearly[!grepl('\\.tar', unique_filesInearly$fileearly),]
    unique_filesInearly=unique_filesInearly[!grepl('\\.sql', unique_filesInearly$fileearly),]

  
  #### Deletion of folders (late and early with their overall size) that are only in early folder: we have already files inside these folder, so idenical folders were redundant
  unique_filesInearly= unique_filesInearly[with(unique_filesInearly, grepl('.+\\....$', fileearly)),]
  
  return (unique_filesInearly)
}

#returns a table with files only present in late folder. Log files have been deleted. 
#@df, data frame with file late and size late


subset_unique_filesInlate <- function (df)
{
  
  unique_filesInlate= subset(df, sizeearly=='>')
  names(unique_filesInlate)<- c('>', 'sizelate', 'filelate', 'junk', 'junk')
  
  
  #### Formating sizes of files:10^3 = K, 10^6 = M, 10^9 = G in unique_filesInlate dataframe
  unique_filesInlate$sizelate=gsub('K', 'e3', unique_filesInlate$sizelate)
  unique_filesInlate$sizeearly=gsub('M', 'e6', unique_filesInlate$sizelate)
  unique_filesInlate$sizelate=gsub('G', 'e9', unique_filesInlate$sizelate)
  
  unique_filesInlate$sizelate=as.numeric(unique_filesInlate$sizelate)
  
  #### Deletion of rows with empty cases
  nique_filesInlate=unique_filesInlate[complete.cases(unique_filesInlate),]
  
  #### Deletion of .log files (added when untar), and .tar files
  unique_filesInlate=unique_filesInlate[!grepl('\\.log', unique_filesInlate$filelate),]
  unique_filesInlate=unique_filesInlate[!grepl('\\.tar', unique_filesInlate$filelate),]
  unique_filesInlate=unique_filesInlate[!grepl('\\.sql', unique_filesInlate$filelate),]

  
  #### Deletion of folders (late and early with their overall size) that are only in early folder: we have already files inside these folder, so idenical folders were redundant
  unique_filesInlate= unique_filesInlate[with(unique_filesInlate, grepl('.+\\....$', filelate)),]
  
  #### Deletion of useless cols, with signs, or empty cases
  unique_filesInlate=unique_filesInlate[, c(2,3)]
  
  return (unique_filesInlate)

}

#creates a dataframe in which we have all the files in common between folders early and late. basically, avery file in this dataframe is assumed to be in double.
#@df, dataframe with columns size and file early and size and file late


subset_same_files <- function (df)
{
  #Creation of a subset with all homologues files that have the same size:
  same_file_size= subset(df, sizelate=sizeearly)
  
  #### Formating sizes of files:10^3 = K, 10^6 = M, 10^9 = G in unique_filesInlate dataframe
  
  same_file_size$sizeearly=gsub('K', 'e3', same_file_size$sizeearly)
  same_file_size$sizelate=gsub('K', 'e3', same_file_size$sizelate)
  
  same_file_size$sizeearly=gsub('M', 'e6', same_file_size$sizeearly)
  same_file_size$sizelate=gsub('M', 'e6', same_file_size$sizelate)
  
  
  same_file_size$sizeearly=gsub('G', 'e9', same_file_size$sizeearly)
  same_file_size$sizelate=gsub('G', 'e9', same_file_size$sizelate)
  
  
  same_file_size$sizeearly=as.numeric(same_file_size$sizeearly)
  same_file_size$sizelate=as.numeric(same_file_size$sizelate)
  
  #### Deletion of useless cols, with signs, or empty cases
  same_file_size=same_file_size[, 1:4]
  
  #### Deletion of rows with empty cases
  same_file_size= same_file_size[complete.cases(same_file_size),] #deletes rows with NAs (date is indicated in cols)
  
  #### Deletion of .log files (added when untar), and .tar files
  same_file_size=same_file_size[!grepl('\\.log', same_file_size$filelate),]
  same_file_size=same_file_size[!grepl('\\.log', same_file_size$fileearly),]
  same_file_size=same_file_size[!grepl('\\.tar', same_file_size$filelate),]
  same_file_size=same_file_size[!grepl('\\.tar', same_file_size$fileearly),]
  same_file_size=same_file_size[!grepl('\\.sql', same_file_size$filelate),]
  same_file_size=same_file_size[!grepl('\\.sql', same_file_size$fileearly),]

  
  #### Deletion of folders (late and early with their overall size) that are only in early folder: we have already files inside these folder, so idenical folders were redundant
  same_file_size= same_file_size[with(same_file_size, grepl('.+\\....$', filelate)),]
  same_file_size= same_file_size[with(same_file_size, grepl('.+\\....$', fileearly)),]
  
  return(same_file_size)
  
}