#!/usr/bin/python2
# -*- coding: cp1252 -*-

#Segundo Trabalho de Cálculo Numérico
#Professor Paulo Bordoni
#Turma EE1-9718

#Alunos:
#Victor Ribeiro Pires - 113051532
#Xiao Yong Kong - 114176987

import numpy as np
import random
import sys

np.set_printoptions(precision=5)
def solucaoLinear(X, y):   
    Xy = np.hstack([X, y.reshape(-1, 1)])
    n = len(y)
    for i in range(n):
        
        x = Xy[i]
        
        for j in range(i + 1, n):
            y = Xy[j]
            m = x[i] / y[i]
            Xy[j] = x - m * y

    for i in range(n - 1, -1, -1):
        Xy[i] = Xy[i] / Xy[i, i]
        x = Xy[i]

        for j in range(i - 1, -1, -1):
            y = Xy[j]
            m = x[i] / y[i]
            Xy[j] = x - m * y

    a = Xy[:, n]
    return a

def main():

    matrix_pag10 = np.loadtxt("arq_tabela_1.txt")
    matrix_pag21 = np.loadtxt("arq_tabela_2.txt")

    mp10 = matrix_pag10[:33,:16] 
    mp21 = matrix_pag21[:33,:16] 

    prod = mp10.dot(mp21.transpose())
    prod =  prod * 1/10

    #---------------------maxP
    p_max = np.amax(prod)
    print p_max
    m_random = []
    for x in range(0, 3):
        m_random.append( random.random()* p_max )
    m_random.sort()
    print m_random

    #---------------Cria matriz M
    #m0 = 12.5
    #m1 = 23.2
    #m2 = 24.7
    M = ( m_random[0] - m_random[1] ) * np.random.random_sample((33,33)) + m_random[2]
    print M
    # Mx=b  
    b = prod.diagonal()
    print "b = ", b

    #-----Obter vetor xsp ( gauss sem pivo ) e xcp ( gauss com pivo )
    xsp = solucaoLinear(M,b)
    print "Sem o uso do pivotemaneto teremos, xsp :"
    print xsp
    xcp = np.linalg.solve(M,b)
    print "Com o uso do pivotemaneto teremos, xcp :"
    print xcp
    
    
    bsp = M.dot(xsp)
    print "bsp="
    print bsp
    
    bcp = M.dot(xcp)

    print "bsp="
    print bcp

    #--------Matriz inversa
    mInvi = np.linalg.inv(M)
    print "Aqui teremos a Matriz Inversa: "
    print mInvi

    identidade = mInvi.dot(M)
    
    print "Matriz Identidade: "
    print identidade

    id2  = M.dot(mInvi)
    print "Matriz Identidade com a ordem trocada:"
    print id2

    print "xsp = "
    print xsp
    print "xcp = "
    print xcp
    xinvi = mInvi.dot(b)
    print "xinvi = "
    print xinvi

    
main()



