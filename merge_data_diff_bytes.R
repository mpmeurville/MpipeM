
#returns a string saying how much file in each folder (names in vec) are in df
#@df, dataframe with file as colname
#@vec, vector with strings which are names of the file

subset_by_folder_bytes <- function(df, vec)
 
  
{
  
  results= matrix(ncol=2, nrow=length(vec))
  
  for (i in c(1:length(vec))){
    
    results[i,1]=vec[i]
    results[i,2]=nrow(df[with(df, grepl(vec[i], file )),])
    
  }
  
  
  
  resultdf=as.data.frame(results)
  return (resultdf)
}


#returns a df with col filename and number of files much file in each folder (names in vec) are in df
#@df, dataframe with fileearly or filelate colums
#@ec, vector with strings which are names of the files

#the vector must be define from ALL SUBFOLDERS NAMES BEFORE !!

subset_by_folder <- function(df, vec)
  
{
  results= matrix(ncol=2, nrow=7)
  
  for (header in length(colnames(df)))
  {
    
    if (colnames(df)[header] == 'filelate' )
    {
      
      for (i in c(1:length(vec))){
        
        results[i,1]=vec[i]
        results[i,2]=nrow(df[with(df, grepl(vec[i], filelate )),])# dirname sur la colonne filelate, et ajouter $ à la fin du vec[i]
        
      }
      
      
      #var = paste (vec[1], PDBF,vec[2], DB, vec[3],HC, vec[4], Post, vec[5], PDB, vec[6], LTS)
      
    }
    else
      #if (colnames(df)[header] == 'fileearly') 
    {
      
      for (i in c(1:length(vec))){
        
        results[i,1]=vec[i]
        results[i,2]=nrow(df[with(df, grepl(vec[i], fileearly )),])
        
      }
      
      #var = paste (vec[1], PDBF,vec[2], DB, vec[3],HC, vec[4], Post, vec[5], PDB, vec[6], LTS)
      
      
    }
  }
  resultdf=as.data.frame(results)
  return (resultdf)
}






#the aim here is o create a table from the outputsof 2 other scripts. 
final_table= function (df1,df2,df3, df4, vec, df5, df6, df7, df8){
  
 print('A')

#### Creation of subtables with only one type of files, depending on their size differences
  folder_diff= subset_by_folder(df1, vec)
    write.table(folder_diff, file ='folder_diff.csv', sep=';', col.names = TRUE, row.names = FALSE)

  colnames(folder_diff) =c('FileName', 'Same name but different sizes')
  
  folder_same=subset_by_folder(df2, vec)
    write.table(folder_same, file ='folder_same.csv', sep=';', col.names = TRUE, row.names = FALSE)

  colnames(folder_same) =c('FileName', 'Same name and same sizes')
  
  folder_uniqueInearly=subset_by_folder(df3, vec)
    write.table(folder_uniqueInearly, file ='folder_uniqueInearly.csv', sep=';', col.names = TRUE, row.names = FALSE)

  colnames(folder_uniqueInearly) =c('FileName', 'Files only in early')
  
  folder_uniqueInlate=subset_by_folder(df4, vec)
    write.table(folder_uniqueInlate, file ='folder_uniqueInlate.csv', sep=';', col.names = TRUE, row.names = FALSE)

  colnames(folder_uniqueInlate) =c('FileName', 'Files only in late')
  write.table(unique_bytesInearly_table, file ='unique_bytesInearly.csv', sep=';', col.names = TRUE, row.names = FALSE)

print('B')

  finalSameDiff= merge(folder_same, folder_diff, by='FileName')
  finale20132105=merge(folder_uniqueInearly, folder_uniqueInlate, by='FileName')
  final_table_size=merge(finalSameDiff, finale20132105, by = 'FileName')

print('C')
folder_same_bytes=subset_by_folder_bytes(df6, vec)#must rename the headers here, and merge these df with the ones from the size comp, and it's done!!
colnames(folder_same_bytes) =c('FileName', 'Same name and same cksum')

print('D')
folder_diff_bytes=subset_by_folder_bytes(df5, vec)
  colnames(folder_diff_bytes) =c('FileName', 'Same name but different cksum')

print('E')
 folder_uniquelate_bytes=subset_by_folder_bytes(df7, vec)
  colnames(folder_uniquelate_bytes) =c('FileName', 'Files only in late folder (cksum)')

print('F')
folder_uniqueearly_bytes=subset_by_folder_bytes(df8, vec)
  colnames(folder_uniqueearly_bytes) =c('FileName', 'Files only in early folder (cksum)')

print('G')

  finalSameDiffBytes= merge(folder_same_bytes, folder_diff_bytes, by='FileName')
  finaleearlylateBytes=merge(folder_uniqueearly_bytes, folder_uniquelate_bytes, by='FileName')
  final_table_bytes=merge(finalSameDiffBytes, finaleearlylateBytes, by = 'FileName')
  
  
  final_table=merge(final_table_size, final_table_bytes, by='FileName')
  
  return(final_table)
}
