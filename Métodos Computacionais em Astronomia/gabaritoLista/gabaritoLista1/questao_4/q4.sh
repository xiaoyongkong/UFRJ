#!/bin/bash

tar -xzf ./l1e4.tar.gz #a)
echo 'Letra a) feita'

rm error* #b)
echo 'Letra b) feita'

for arquivo in *.txt #c)
do
	echo 'feito' > $arquivo
done
echo 'Letra c) feita'
#
numeros=$(seq 1 40) #d) # É melhor definir uma lista antes do que chamar no for para evitar comandos externos dentro do argumewnto do for
for n in $numeros 
do
	mkdir mesmos_numeros_$n
	cp ${n}_* mesmos_numeros_$n #{$n}_* para EVITAR que por exemplo 1,10,11... ou seja todos os numeros começados com 1 sejam considerados o mesmo numero. Assim como os outros números 2,21,22...
	tar -czf mesmos_numeros_$n.tar.gz mesmos_numeros_$n/
done
echo 'Letra d) feita'
#
for x in {A..J} #e) e f)
do
	mkdir $x
	mv *$x.txt $x
done
echo 'Letrad e) e f) feitas'

for l in {A..J};do #g)
	for arquivo in $(find $l -type f -name "*_$l.txt" | sed "s/.*\///");do # | sed "s/.*\///" é para remover o diretório da lista arquivo (teste o comando find com e sem este trecho).
	mv $l/$arquivo $l/${arquivo,,} 
	done
done
echo 'Letra g) feita'

mkdir backup #h)
for l in {A..J}
do
	cp -r $l backup
done
echo 'Letra h) feita'
#
for l in {A..J} #i
do
	sed -i '1 i\backup' backup/$l/*
done
echo 'Letra i) feita'
#
tar -czf backup.tar.gz backup/ #j)
echo 'Letra j) feita'
echo 'Fim da questão 4'
$SHELL
