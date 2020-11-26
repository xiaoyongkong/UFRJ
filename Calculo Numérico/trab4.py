# -*- coding: cp1252 -*-
#Quarto Trabalho de C�lculo Num�rico
#Professor Paulo Bordoni
#Turma EE1-9718

#Alunos: (Grupo 10)
#Victor Ribeiro Pires - 113051532
#Xiao Yong Kong - 114176987

# 1 - Devemos informar quantas ra�zes reais a equa��o possui
# 2 - Determinar todas as r�izes no intervalo [a,b] especificado ao grupo;
# 3 - Dever�o ser utilizados (um por raiz) os m�todos do scipy
#   a) brentq()
#   b) bisect()
#   c) newton() e secant()

# GR 10 - (2 - cosh(x))*(x� - x - 0.9) - [-2 , 2]

import math
from scipy import optimize

def function(x):
    return (2 - math.cosh(x))*(x**3 - x - 0.9)

#Brentq para achar as ra�zes
rootBrent = optimize.brentq(function, -2, 2)
print("Raiz real do Brent: ", rootBrent )

#bisect para achar as ra�zes
rootBisect = optimize.bisect(function, -2, 2)
print("Raiz real do Bisect : ", rootBisect)

#newton para achar as ra�zes
rootNewton1 = optimize.newton(function, -2)
rootNewton2 = optimize.newton(function, -2)
print("Raiz real do Newton com a raiz -2: ", rootNewton1)
print("Raiz real do Newton com a raiz 2: ", rootNewton2)

#secant para achar as ra�zes
rootSecant = optimize.root_scalar(function, method='secant',x0=-2,x1=2)
print("Raiz real do Secant : ", rootSecant.root)
