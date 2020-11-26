# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import math
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint

# Euler
def Euler(T_l,y_0):
    U = np.zeros_like(T_l)
    for k in range(Nt):
        tk = T_l[k]
        U[k] = y_0
        yk = y_0 + h*f(y_0,tk)
        y_0 = yk
    return U
#######
    
# Henn
def Heun(T_l,y_0):
    U = np.zeros_like(T_l)
    yk1 = y_0
    for k in range(Nt):
        tk = T_l[k]
        U[k] = yk1    
        yk = y_0 + h*f(y_0,tk)
        yk_e = yk + h*f(tk,yk)
        yk1 = yk + (h*(f(tk,yk)+f(tk+h, yk_e)))/2    
        y_0 = yk
    return U
########
    
# RK4
def rk4(T_l, y_0):
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
#######
    

fig = plt.figure(frameon=True, facecolor='w')
ax = fig.gca()
trs = 30*'-'
igs = 30*'='

e = 2.220446

def f(y,t):
    return (math.exp(t)) + (2*y)

t0 = 1

tf = 3

y0 = 0


Nt = 11
T,h = np.linspace(t0,tf,Nt, retstep=True)
print 2*trs, '\nO passo temporal é h = ',h
fg_h = (tf - t0)*0.05

W = Euler(T, y0) 

X = Heun(T, y0)
    
Y = rk4(T, y0)
    
# odeint
Z = odeint(f, y0, T)
#######
    
print 2*igs,'''\nTabela comparativa:
    T[k] --> tempo
    W[k] --> Euler
    X[k] --> Heun
    Y[k] --> Runge-Kutta
    Z[k] --> odeint( ) \n''', igs
print 'T[k] --> W[k] -- X[k] -- Y[k] -- Z[k]\n',2*trs
for k in range(Nt):
    print '%4.2f --> %6.4f -- %6.4f -- %6.4f -- %6.4f'%(T[k], W[k], X[k], Y[k], Z[k])
print 2*igs,'\nGráfico para 11 valores igualmente espaçados.'

Ym = min(np.amin(Y),0.)
YM = np.amax(Y)
fg_v = (YM  - Ym)*0.05
plt.plot(T,W,'y-',linewidth=2,label=' Euler')
plt.plot(T,X,'g--',linewidth=2,label=' Hens')
plt.plot(T,Y,'b.',label=' RK4')
plt.plot(T,Z,'r-',linewidth=2,label='odeint( )')
plt.xlim(t0-fg_h,tf+fg_h)
plt.ylim(Ym-fg_v,YM+fg_h)
plt.title('Graficos comparativos')
ax.grid(True)
ax.axhline(y=0., color='k')
ax.axvline(x=0., color='k')
ax.grid(True)
plt.legend(loc='best')
ax.axis([t0-fg_h,tf+fg_h, Ym-fg_v, YM+fg_v])
plt.show()

Nt = 101
T,h = np.linspace(t0,tf,Nt, retstep=True)
print '\nGráfico para 101 valores igualmente espaçados.'
fg_h = (tf - t0)*0.05

W = Euler(T, y0) 

X = Heun(T, y0)
    
Y = rk4(T, y0)
    
# odeint
Z = odeint(f, y0, T)
#######

Ym = min(np.amin(Y),0.)
YM = np.amax(Y)
fg_v = (YM  - Ym)*0.05
plt.plot(T,W,'y-',linewidth=2,label=' Euler')
plt.plot(T,X,'g--',linewidth=2,label=' Hens')
plt.plot(T,Y,'b.',label=' RK4')
plt.plot(T,Z,'r-',linewidth=2,label='odeint( )')
plt.xlim(t0-fg_h,tf+fg_h)
plt.ylim(Ym-fg_v,YM+fg_h)
plt.title('Graficos comparativos')
ax.grid(True)
ax.axhline(y=0., color='k')
ax.axvline(x=0., color='k')
ax.grid(True)
plt.legend(loc='best')
ax.axis([t0-fg_h,tf+fg_h, Ym-fg_v, YM+fg_v])
plt.show()
