#! /bin/bash  
while read line 
do 
echo "face/$line">>face_list.txt 
done <image_id.txt
