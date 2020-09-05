#!/bin/sh

#Letra A
tar -xf l1e4.tar.gz

#Letra B
rm -rf error*.txt  

#Letra C
echo "feito" >> *.txt

#Letra D
# for number in $(seq 1 40); do
#   tar -czvf mesmos_numeros.tar.gz $number*
# done

#Letra E
# for letter in {A..J}; do
#   mkdir $letter
  
#   #Letra F
#   mv *$letter.txt $letter
  
#   #LetraG
#   for file in *.txt; do
#     mv "$file" "${file//$letter/${letter,,}}"
#   done
# done

#Letra H
mkdir backup
for letter in {A..J}; do
  cp -r $letter backup
done

#Letra I
sed '/^feito/i backup' *.txt  