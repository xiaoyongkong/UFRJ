#!/bin/bash 

read -p "Digite p para mudar o prefixo e s para mudar s sufixo: " PS

if [[ $PS == "p" ]] ; then
	read -p "Digite o texto que será excluído: " OUT1
	read -p "Digite o texto que será inserido: " IN1
	read -p "Digite o local do arquivo: " LOCAL
	rename "s/$OUT1/$IN1/" $LOCAL/$OUT1*

elif [[ $PS == "s" ]] ; then
	read -p "Digite o texto que será excluído: " OUT2
	read -p "Digite o texto que será inserido: " IN2
	read -p "Digite o local do arquivo: " LOCAL
	rename "s/$OUT2/$IN2/" $LOCAL/*$OUT2
else
	printf "Comando não reconhecido"

fi
