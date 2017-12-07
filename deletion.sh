#!/bin/bash

cat $1 | while read -r line; do 

cp -R "/archive/cig/fankhauser/plantgrowth/Lemnatec/Databases/$line" ./Backups

done
