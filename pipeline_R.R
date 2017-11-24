#!/usr/bin/env Rscript

library("optparse", lib.loc="~/local/R_lib")

option_list = list(
make_option(c("-e", "--folderearly"), type="character", default=NULL,
                help="name of folder early"),
make_option(c("-l", "--folderlate"), type="character", default=NULL,
                help="name of folder late"),
make_option(c("-o", "--count"), type="character", default=NULL,
                help="name of file count_files_datearlylate.csv"),
#make_option(c("-d", "--diff"), type="character", default=NULL,
#                help="name of file diff_files_sizes_earlylate"),
make_option(c("-c", "--cksum"), type="character", default=NULL,
                help="name of file bytes_counsearlylate.txt")
#make_option(c("-V", "--vecearly"), type="character", default=NULL,
#                help="vector with types of files in folder early"),
#make_option(c("-v", "--veclate"), type="character", default=NULL,
#                help="vector with types of files in folder late")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

#diff_file <- opt$diff
diff_cksum <- opt$cksum
count_dat_files <- opt$count
folderearly <- opt$folderearly
folderlate <- opt$folderlate
#vec1 <- opt$vecearly
#vec2 <- opt$veclate

vec1=scan("vecearly.txt", what="character", sep=NULL) #transforming the input .txt content into string vectors. 
vec2=scan("veclate.txt", what="character", sep=NULL)

#source ("/scratch/beegfs/monthly/mmeurvil/db/MpipeM/size_functions.R")
source ("/scratch/beegfs/monthly/mmeurvil/db/MpipeM/bytes_functions.R")
source ("/scratch/beegfs/monthly/mmeurvil/db/MpipeM/merge_data_diff_bytes.R")

path_abs=getwd()
#diff_file=paste(path_abs, '/', diff_file, sep = "")

            #### SIZE COMPARISON
#print(diff_file)
#print(diff_cksum)
#print(folderearly)
#print(vec1)
#print(vec2)
#getwd()


#files_size <- read.table(diff_file, fill=T, header = F) #reads the text file and creates a dataframe with data
#names(files_size)<- c('sizeearly', 'fileearly', 'sizelate', 'filelate', 'junk') #labeling headers
#    write.table(files_size, file ='files_size.csv', sep=';', col.names = TRUE, row.names = FALSE)

#### Creation of subtables containing the files that have similar or different sizes, and that are unique in early or late folder

#diff_files= subset_diff_files(files_size) #creates a data frame with only files that differ in size but have the same name
#    write.table(diff_files, file ='diff_files_size.csv', sep=';', col.names = TRUE, row.names = FALSE)

#unique_filesInearly= subset_unique_filesInearly(files_size) #creates a dataframe wih files that are only in early1229 folder
#    write.table(unique_filesInearly, file ='unique_filesInearly_size.csv', sep=';', col.names = TRUE, row.names = FALSE)

#unique_filesInlate= subset_unique_filesInlate(files_size)#creates a dataframe with files that are only in late0102 folder
#    write.table(unique_filesInlate, file ='unique_filesInlate_size.csv', sep=';', col.names = TRUE, row.names = FALSE)

#same_files= subset_same_files(files_size)#creates a datframe of files that have the same name and same size in both folders.
#    write.table(same_files, file ='same_files_size.csv', sep=';', col.names = TRUE, row.names = FALSE)




            #### CKSUM COMPARISON

bytes_raw=read.table(diff_cksum) #Est ce que ca joue quand on appelle un fichier comme ca depuis R dans bash?
names(bytes_raw)<-c('cksum', 'size', 'file')


#### Creates two subtables containing data for early and late folders
bytesearly=bytes_raw[grepl(folderearly, bytes_raw$file),]
names(bytesearly)=c('cksumearly', 'sizeearly', 'file')
    write.table(bytesearly, file ='bytes_early.csv', sep=';', col.names = TRUE, row.names = FALSE)


byteslate=bytes_raw[grepl(folderlate, bytes_raw$file),]
names(byteslate)=c('cksumlate', 'sizelate', 'file')
    write.table(byteslate, file ='bytes_late.csv', sep=';', col.names = TRUE, row.names = FALSE)


#### Deleting the early and late folders from the path, so we can compare files with same names
bytesearly$file= gsub(paste('./', folderearly, sep=""), '', bytesearly$file)
byteslate$file=gsub(paste('./', folderlate, sep=""), '', byteslate$file)

#### Creation of one df containing all the files from early and late fodlers
bytes= merge(byteslate, bytesearly, by='file', all=TRUE)
    write.table(bytes, file ='bytes.csv', sep=';', col.names = TRUE, row.names = FALSE)


#### Creation of a df containing files with different cksums but same name
diff_bytes_table=diff_bytes(bytes)
names(diff_bytes_table)=c('file', 'cksumlate', 'sizelate', 'cksumearly', 'sizeearly')
      write.table(diff_bytes_table, file ='diff_bytes.csv', sep=';', col.names = TRUE, row.names = FALSE)


#### Creation of a df containing files with same cksums and same name
same_bytes_table=same_bytes(bytes)
names(same_bytes_table)=c('file', 'cksumlate', 'sizelate', 'cksumearly', 'sizeearly')
    write.table(same_bytes_table, file ='same_bytes.csv', sep=';', col.names = TRUE, row.names = FALSE)


#### Creation of a df containing files only in late folder
unique_bytesInlate_table=unique_bytesInlate(bytes)
names(unique_bytesInlate_table)=c('file', 'cksumlate', 'sizelate', 'cksumearly', 'sizeearly')
write.table(unique_bytesInlate_table, file ='unique_bytesInlate.csv', sep=';', col.names = TRUE, row.names = FALSE)


#### Creation of a df containing files only in early folder
unique_bytesInearly_table=unique_bytesInearly(bytes)
names(unique_bytesInearly_table)=c('file', 'cksumlate', 'sizelate', 'cksumearly', 'sizeearly')
  write.table(unique_bytesInearly_table, file ='unique_bytesInearly.csv', sep=';', col.names = TRUE, row.names = FALSE)

#### Creation of a df containing the number of .dat files in every subfolder in late and early directories
count_files_dat <- read.table(count_dat_files) 

            #### CREATION OF A RECAP TABLE
vecint=c(vec1, vec2)
vec=unique(vecint)
vec = paste('/',vec, sep='')
#subset of files in each df in each folder
count_files_table= count_files(count_files_dat, vec, folderearly, folderlate)
final_table_earlylate=final_table(vec, diff_bytes_table, same_bytes_table,unique_bytesInlate_table,unique_bytesInearly_table, count_files_table)
 write.table(final_table_earlylate, file ='final_tableearlylate.csv', sep=';', col.names = TRUE, row.names = FALSE)
