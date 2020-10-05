#!/bin/sh

if [ -z "$1" ]; then
  echo "Diga qual a pasta que deseje alterar os arquivos, digite '$ ./questao3.sh <folderName>' "
  exit
fi

echo "Como você desejar renomear os arquivos?"
echo "Digita i para colocar o texto no início"
echo "Digita f para colocar no final"
echo "Digita a para ambos"
read position

if [ "$position" = "a" ]; then
  read -p 'Digite o valor a ser colocado no início: ' begin
  read -p 'Digite o valor a ser colocado no final: ' end
  cd $1
  
  for file in *; do
    mv "$file" "$begin$file$end"
  done
fi

if [ "$position" = "i"  -o "$position" = "f" ]; then
  read -p 'Digite o valor a ser colocado: ' value
  cd $1
  if [ "$position" = "i" ]; then
    for file in *; do
      mv "$file" "$value$file"
    done
  else 
    for file in *; do
      mv "$file" "$file$value"
    done
  fi
fi
