# -*- coding: cp1252 -*-
#Quarto Trabalho de Cálculo Numérico
#Professor Paulo Bordoni
#Turma EE1-9718

#Alunos: (Grupo 10)
#Victor Ribeiro Pires - 113051532
#Xiao Yong Kong - 114176987

# 1 - Devemos informar quantas raízes reais a equação possui
# 2 - Determinar todas as ráizes no intervalo [a,b] especificado ao grupo;
# 3 - Deverão ser utilizados (um por raiz) os métodos do scipy
#   a) brentq()
#   b) bisect()
#   c) newton() e secant()

# GR 10 - (2 - cosh(x))*(x³ - x - 0.9) - [-2 , 2]

import math
from scipy import optimize

def function(x):
    return (2 - math.cosh(x))*(x**3 - x - 0.9)

#Brentq para achar as raízes
rootBrent = optimize.brentq(function, -2, 2)
print("Raiz real do Brent: ", rootBrent )

#bisect para achar as raízes
rootBisect = optimize.bisect(function, -2, 2)
print("Raiz real do Bisect : ", rootBisect)

#newton para achar as raízes
rootNewton1 = optimize.newton(function, -2)
rootNewton2 = optimize.newton(function, -2)
print("Raiz real do Newton com a raiz -2: ", rootNewton1)
print("Raiz real do Newton com a raiz 2: ", rootNewton2)

#secant para achar as raízes
rootSecant = optimize.root_scalar(function, method='secant',x0=-2,x1=2)
print("Raiz real do Secant : ", rootSecant.root)
