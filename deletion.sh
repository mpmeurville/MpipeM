#!/bin/bash

cat $1 | while read -r line; do 
#new= $line | tr -d '\r'
#echo $new
#echo "/archive/cig/fankhauser/plantgrowth/Lemnatec/Databases/$line"
cp -R "/archive/cig/fankhauser/plantgrowth/Lemnatec/Databases/$line" ./Backups

done
