#!/bin/bash
#pipeline allowing to untar subfolders from 2 directories, in an untar folder within each directory.
#Then, diff and cksum are performed on these untared files, outputs are two .txt files
#.txt are ran into R scripts for analysis
#output = final_table, with counts of files similar and different from the two initial folders.

#@$1 = name of the first folders
#@$2 = name of the second folders


	#1.1 Creation of untar subfolder in date folders
cd $1
mkdir -p untar
cd .. 
cd $2
mkdir -p untar
cd .. 
#now I'm in the folder with $1 and $2, in db
	
	#1.2 Creation of subfolders for each .tar file, in untar
cd $1
for f in *.tar;
	do 
	folder=$(echo $f | cut -f 1 -d '.')
	cd untar
	mkdir -p $folder
	cd .. #go back in $1
done
cd untar 
vec1=$(ls -F) 

cd .. #go back in $1

cd .. #go back at $1 $2 lvl

echo $vec1 > vecearly.txt #creates a txt file with values of vec1 in it

cd $2
for f in *.tar;
	do 
	folder=$(echo $f | cut -f 1 -d '.')
	cd untar
	mkdir -p $folder
	cd .. 
done

cd untar 
vec2=$(ls -F)
cd ..

cd .. 
#now we are at the level of $1 and $2 folders, in db 

echo $vec2 > veclate.txt #creates a txt file with values of vec2 in it

	#1.3 Untar .tar folders in newly created folders of same name without .tar, in the untar subfolder.
cd $1
for f in *.tar;
	do 
	folder=$(echo $f | cut -f 1 -d '.')
	tar xvf ${f} -C untar/${folder}
	
done
wait

cd .. #back to db folder, at same level than $1 and $2. 

cd $2
for f in *.tar;
	do 
	folder=$(echo $f | cut -f 1 -d '.')
	tar xvf ${f} -C untar/${folder}
	
done

wait

cd .. #back to db folder, at same level than $1 and $2. 
pwd

#now we are at the level of Date folders, in db. 
echo $vec1
echo $vec2

	#2.1 Using diff on boh folders. 
find . -type f -name '*dat' | diff -yr --report-identical-files <(cd $1 && du -ha --bytes | sort -k2) <(cd $2 && du -ha --bytes | sort -k2) > diff_files_sizes_$1$2.txt

	#2.2 Using cksum on both folders
find . -type f -name '*dat' | xargs cksum > bytes_counts$1$2.txt

wait

module use /software/module/R/
module add 3.1.1
pwd

Rscript pipeline_R.R -e $1 -l $2 -d diff_files_sizes_$1$2.txt -c bytes_counts$1$2.txt

