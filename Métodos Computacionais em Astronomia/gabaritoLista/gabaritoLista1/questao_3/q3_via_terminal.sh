#!/bin/bash 

if [[ $1 == "p" ]] ; then
	rename "s/$2/$3/" $4/$2*
elif [[ $1 == "s" ]] ; then
	rename "s/$2/$3/" $4/*$2
elif [[ $1 == "-h" ]] || [[ $1 == "-help" ]] || [[ $1 == "--help" ]] ; then
	echo "1o argumento: p ou s (para sufixo ou prefixo)"
	echo "2o argumento: padrão a ser substituido"
	echo "3o argumento: o que será colocado on lugar fo 2o argumento"
	echo "4o argumento: local do(s) arquivo(s)"
else
	printf "Comando não reconhecido"
fi
