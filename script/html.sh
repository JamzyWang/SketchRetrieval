#! /bin/bash 
rm demo.html 
echo "<style>" >>demo.html
echo "img{width: 100px;}" >>demo.html
echo "</style>" >>demo.html
while read line 
do 
echo "<img src = $line >" >>demo.html
done <result.txt 
