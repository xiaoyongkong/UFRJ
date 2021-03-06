# Lista 2 Parte 2 Questão 1

import numpy as np

#############################################################  Letra a #############################################################
# Leia o arquivo array.dat usando o comando np.loadtxt() e armazene o mesmo como “array_original”
array_original = np.loadtxt("array.dat")
####################################################################################################################################

#############################################################  Letra b #############################################################
# Defina um novo array como sendo igual a 3a coluna do array_original, e um outro array como sendo a 5a linha do array_original.
novo_array = array_original[:,2]
outro_array = array_original[4]
####################################################################################################################################

#############################################################  Letra c #############################################################
# Defina um novo array com com as colunas pares do array_ogirinal
colunas_pares = array_original[:,1::2]
####################################################################################################################################

#############################################################  Letra d #############################################################
# Defina um novo array com as linhas impares do array_original
linhas_impares = array_original[0::2]
####################################################################################################################################

#############################################################  Letra e #############################################################
# Defina um novo array com os números múltiplos de 5 do array_original.
multiplos_5 = array_original[array_original%5==0];
####################################################################################################################################

#############################################################  Letra f #############################################################
# Defina um array com apenas os números positivos do array_original.
maior_5 = array_original[array_original > 0]
####################################################################################################################################

#############################################################  Letra g #############################################################
# Defina um novo array como sendo a transposta do array_original
transposta = np.transpose(array_original)
####################################################################################################################################

#############################################################  Letra h #############################################################
# Defina um novo array como sendo um array achatado (apenas uma linha) do array_original usando reshape , ravel ou flatten 
# (olhe na documentação do numpy imbutida nos links anteriores)
achatado = array_original.flatten()
####################################################################################################################################

#############################################################  Letra i #############################################################
# Utilizando reshape sobre o array do item anterior, gere um array final com 12 linhas e 10 colunas
reshape = np.reshape(array_original, (12,10))
####################################################################################################################################
