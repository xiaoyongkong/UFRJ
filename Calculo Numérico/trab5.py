# -*- coding: cp1252 -*-

#Quinto Trabalho de Cálculo Numérico
#Professor Paulo Bordoni
#Turma EE1-9718

#Alunos: (Grupo 10)
#Victor Ribeiro Pires - 113051532
#Xiao Yong Kong - 114176987

#Os grupos deverão resolver o PVI pelo métodos de Euler, Heun
#e Runge-Kutta de 4º ordem e o odeint() no intervalo [to, tf]

#Deverão ser apresentados:

# 1 - Uma tabela com 5 colunas(t, Euler, Heun, RK4 odeint) com
#   as soluções para 11 valores igualmente espaçados em t em [t0, tf].

# 2 - O gráfico comparativo das 4 soluções de forma a poder visualizar
#   cada uma delas para os 11 valores igualmente espaçados.

# 3 - O gráfico comparativo das 4 soluções de forma a poder visualizar
#   cada uma delas para 101 valores igualmente espaçados.

#Intervalo é [t0, t0+2]
#GR 10 ||   y' = x * ((y)**(1/2))  ||  y(0) = 4


import numpy as np
from scipy.integrate import solve_ivp, odeint
from numpy import linspace, zeros, exp
import matplotlib.pyplot as plot

from scipy import optimize

#Função do grupo 10
def function(x, y):
    return x * ( (y)**(1/2) )

#Método de Euler
def Euler(x1,y0):
    U = np.zeros_like(x1)
    for k in range(Nt):
        xk = x1[k]
        U[k] = y0
        yk = y0 + h*function(y0,xk)
        y0 = yk
    return U

#Metodo de Heun
def Heun(x1,y0):
    U = np.zeros_like(x1)
    yk1 = y0
    for k in range(Nt):
        xk = x1[k]
        U[k] = yk1    
        yk = y0 + h*function(y0,xk)
        yk_e = yk + h*function(xk,yk)
        yk1 = yk + (h*(function(xk,yk)+function(xk+h, yk_e)))/2    
        y_0 = yk
    return U


#Runge Kutta de 4 ordem
def RK4(f, T_l, y_0):
    U = np.zeros_like(T_l)
    U[0] = y_0
    for k in range(Nt):
        yk = y_0
        tk = T_l[k]
        Ak = f(yk,tk)
        Bk = f(yk + h*Ak/2, tk + h/2 )
        Ck = f(yk + h*Bk/2, tk + h/2 )
        Dk = f(yk + h*Ck, tk + h )
        U[k] = yk
        y_0 = yk + h*(Ak + 2*Bk + 2*Ck + Dk)/6
    return U

#Odeint
#Odeint = odeint(function, y0, T)

#Início dos dados para plotagem

fig = plot.figure(frameon=True, facecolor='w')
ax = fig.gca()
trs = 30*'-'
igs = 30*'='
e = 2.220446

#Intervalo dado
t0 = 4
tf = 6
y0 = 4

Nt = 11
T,h = np.linspace(t0,tf,Nt, retstep=True)
print 2*trs, '\nO passo temporal é h = ',h
fg_h = (tf - t0)*0.05

W = Euler(T, y0) 

X = Heun(T, y0)
    
Y = RK4(function, T, y0)
    
# odeint
Z = odeint(function, y0, T)

print 2*igs,'''\nTabela comparativa:
    T[k] --> tempo
    W[k] --> Euler
    X[k] --> Heun
    Y[k] --> Runge-Kutta Ordem 4
    Z[k] --> odeint( ) \n''', igs
print 'T[k] --> W[k] -- X[k] -- Y[k] -- Z[k]\n',2*trs
for k in range(Nt):
    print '%4.2f --> %6.4f -- %6.4f -- %6.4f -- %6.4f'%(T[k], W[k], X[k], Y[k], Z[k])
print 2*igs,'\nGráfico para 11 valores igualmente espaçados.'

Ym = min(np.amin(Y),0.)
YM = np.amax(Y)
fg_v = (YM  - Ym)*0.05
plot.plot(T,W,'y-',linewidth=2,label=' Euler')
plot.plot(T,X,'g--',linewidth=2,label=' Hens')
plot.plot(T,Y,'b.',label=' RK4')
plot.plot(T,Z,'r-',linewidth=2,label='odeint( )')
plot.xlim(t0-fg_h,tf+fg_h)
plot.ylim(Ym-fg_v,YM+fg_h)
plot.title('Graficos comparativos')
ax.grid(True)
ax.axhline(y=0., color='k')
ax.axvline(x=0., color='k')
ax.grid(True)
plot.legend(loc='best')
ax.axis([t0-fg_h,tf+fg_h, Ym-fg_v, YM+fg_v])
plot.show()

Nt = 101
T,h = np.linspace(t0,tf,Nt, retstep=True)
print '\nGráfico para 101 valores igualmente espaçados.'
fg_h = (tf - t0)*0.05

W = Euler(T, y0) 

X = Heun(T, y0)
    
Y = RK4(function, T, y0)
    
# odeint
Z = odeint(function, y0, T)
#######

Ym = min(np.amin(Y),0.)
YM = np.amax(Y)
fg_v = (YM  - Ym)*0.05
plot.plot(T,W,'y-',linewidth=2,label=' Euler')
plot.plot(T,X,'g--',linewidth=2,label=' Hens')
plot.plot(T,Y,'b.',label=' RK4')
plot.plot(T,Z,'r-',linewidth=2,label='odeint( )')
plot.xlim(t0-fg_h,tf+fg_h)
plot.ylim(Ym-fg_v,YM+fg_h)
plot.title('Graficos comparativos')
ax.grid(True)
ax.axhline(y=0., color='k')
ax.axvline(x=0., color='k')
ax.grid(True)
plot.legend(loc='best')
ax.axis([t0-fg_h,tf+fg_h, Ym-fg_v, YM+fg_v])
plot.show()
