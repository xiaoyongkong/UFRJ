# -*- coding: latin -*-
"""
Created on Sat May 11 09:46:37 2019
@author: bordoni
"""
import numpy as np
from tempfile import TemporaryFile
arq_mat = TemporaryFile
np.set_printoptions(precision=5)
ast = 40*'*'
trs = 40*'-'
print 15*' '+'Programa GERAR TABELA A PARTIR DE TEXTO\n',2*ast
minusc = 'abcdefghijklmnopqrstuvxywz'
digitos = '0123456789'
maiusc = minusc.upper()
literais = minusc+maiusc+digitos
print '''O programa pedir� para entrar com o nome de um dos arquivos texto do seu grupo,
na forma:
  --> EPT_Gx_pg_y
  ou
  --> EE1_Gx_pg_y
onde:
  x � o n�mero de seu grupo
  y � o n�mero de uma das p�ginas sorteadas do livro Brave New World
    para o seu grupo.
Em seguida eme mostrar� algumas informa��es e parte do texto do arquivo.
Depois mostrar� uma matriz TAB de dimens�es (N_lin,T_pal) onde:
  N_lin � o n�mero de linhas do texto
  T_pal � o total de palavras da linha com mais palavras
e encerrar� informando as dimens�es (N_lin,T_pal) da matriz TAB'''
print 2*ast,'\nCONFIRAM COM O EXEMPLO A SEGUIR:\n', 2*ast
print'''Entrem com o nome de um dos dois arquivos texto do seu grupo.
(sem a termina��o .txt):'''
nome_do_arq_texto = raw_input(' --> Nome do arq texto: ')
print 2*trs,'\nNo programa, a vari�vel "texto_na_RAM", � uma lista contendo '\
'apenas a string \na seguir, que guarda o conte�do do arquivo texto "%s.txt"'\
' carregado do \ndisco r�gido para a RAM.\n' %nome_do_arq_texto ,2*trs
texto_na_RAM = [line.rstrip('\n') for line in open(nome_do_arq_texto +'.txt')]
print 'As cinco 1�s linhas do texto no arquivo:\n',trs
for linha in texto_na_RAM[:5]:
    print linha
print '... (continua)'
N_lin = np.int32(len(texto_na_RAM))          
Lns = np.array(texto_na_RAM, dtype=object)
Lin_ant = np.array(Lns, dtype=object)
Lin = np.array(Lns, dtype=object)
T_pal_lin = np.zeros((N_lin,), np.int32)
T_pal = -1
for i in range(N_lin):
    Lin[i] = []
    Lin_ant[i] = Lns[i].split()
    cont = 0
    for palavra in Lin_ant[i]:
        for ch in palavra:
            if ch not in literais:
                palavra = palavra.replace(ch,'')
        Lin[i] = np.append(Lin[i],palavra)
        cont += 1  
    T_pal_lin[i] = cont
    T_pal = max(T_pal,T_pal_lin[i])

TAB = np.zeros((N_lin,T_pal), np.int32)
for i in range(N_lin):
    '\n'
    j = 0
    for palavra in Lin[i]:
        TAB[i,j] = len(palavra)
        j += 1
lin_de_mais_col = np.argmax(T_pal_lin)+1
print 2*ast,'''\nOBSERVA��O: Desse texto ser�o retirados sinais como ",.- etc.
Cada linha da matriz TAB mostra o n�mero de letras/d�gitos de suas palavras.
A 1� linha com mais palavras � a %d�, com %d palavras. Assim dim(TAB) = ''' %(
lin_de_mais_col, T_pal), TAB.shape 
print 'Todas as outras linhas possuir�o menos palavras (--> palavras de tamanho = 0).'
print 2*ast,'\nA matriz TAB:\n',2*trs,'\n', TAB
np.savetxt('arq_TAB.txt', TAB, fmt='%4d')
print 2*trs,'\nA matriz TAB foi salva no arquivo texto "arq_TAB"'
print 2*ast, '\nFIM'
