
#separates files from same .tar folder that are onls in early 

unique_bytesInearly= function (df)
  
{
  
  
  unique_bytesInearly=df[is.na(df$cksumlate),]

  return(unique_bytesInearly)
  
  
}


#separates files that are only in late 

unique_bytesInlate= function (df)
  
{
  
  
  unique_bytesInlate=df[is.na(df$cksumearly),]

  return(unique_bytesInlate)
  
  
}

#separates files that are the same in md5sum between early and late. 

same_bytes <- function (df)
{
 df[complete.cases(df), ]
 
  same_bytes= df[df$cksumearly == df$cksumlate,]

  
  return(same_bytes)
  
  
}

#separates files that differ in size between early and late. 

diff_bytes <- function (df)
{
df[complete.cases(df), ]
  diff_bytes= subset(df, df$cksumearly != df$cksumlate)

  
  
  return(diff_bytes)
  
  
}