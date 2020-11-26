# -*- coding: utf-8 -*-
"""
Created on Wed May 15 20:34:46 2019
@author: bordoni
"""
import numpy as np
import sys
trs = 30*'-'
igs = 30*'='
from tempfile import TemporaryFile
arq_temp = TemporaryFile
print (10*' '+'''PROGRAMA SORTEAR DE PÁGINA DE LIVRO\n''', 2*igs)

Tentativa = np.genfromtxt('arq_temp.txt',dtype= 'int')
if Tentativa[0] > 3:
    print '''Programa encerrado por mais de 3 execuções.
Sorry!'''
    sys.exit()
print 'Primeira execução (S/N):'
resp = raw_input('Responda S/N:')
if resp in ' sS':
    if Tentativa[0] != Tentativa[1]:
        Tentativa[0] += 1
        print '''Esta foi a %dª execução!
Programa encerrado por tentativa de enganar o Mestre.''' %Tentativa[0]
        np.savetxt('arq_temp.txt',Tentativa,fmt='%2d')
        sys.exit()
    prim_exec = True
    np.savetxt('arq_temp.txt',Tentativa,fmt='%2d')
    Tentativa = np.array([0,0])
elif resp in 'nN':
    prim_exec = False
else:
    print 'Resposta errada, tente novamente'
print '''ATENÇÃO:
Vocês deverão efetuar apenas 3 tentativas de sorteio.'''
print 2*igs,'\nEntrem com os nomes dos componentes do grupo (sem abreviar):'
print 2*trs
Nome_1 = raw_input('1º nome: ')
Nome_2 = raw_input('2º nome: ')
print '''Se houver um 3º componente, entrem com o nome dele (senão
dêem "enter")'''
Nome_3 = raw_input('3º nome: ')
print 2*igs
Tentativa = np.genfromtxt('arq_temp.txt',dtype= 'int')
pag_livro = len(Nome_1 + Nome_2 + Nome_3)
print 'A página do livro sorteada é:', pag_livro

print 2*igs,'''
Agora baixem da Internet o texto completo da página %d do
livro "Brave New World", e salvem-no no formato .txt.
Executem duas vezes o programa "Gerar_matriz", para 
sortear a matriz M do seu grupo e boa sorte!
''' %pag_livro, 2*trs
print '''Este "output" deverá ser anexado ao arquivo a ser enviado 
ao Mestre com os resultados do 2º Trabalho.
''', 2*igs
np.savetxt('arq_temp.txt',(Tentativa[0], Tentativa[1]), fmt='%2d')
print '''ATENÇÃO:
Caso a página sorteada esteja em branco, ou pela metade, ou
de título pegue a 1ª página "cheia" depois dela.
''', 2*igs

'''
Fiódor Dostoiévski
Franz Kafka
'''

'''
if Tentativa[0] == Tentativa[1]:
    np.savetxt('arq_temp.txt',Tentativa,fmt='%2d')
else:
    pass
'''
# np.genfromtxt ou np.loadtxt
