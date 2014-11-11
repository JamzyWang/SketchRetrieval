#! /bin/bash  
while read line 
do 
echo "feature_database/$line">>feature_database_list.txt 
done <feature_database.txt
