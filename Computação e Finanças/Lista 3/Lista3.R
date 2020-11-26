# Lista 3 de Computação e finanças
# Xiao Yong Kong - 114176987

# COLETANDO OS DADOS
install.packages("zoo")
install.packages("tseries")
install.packages("quantmod")
install.packages("PerformanceAnalytics")
install.packages("mvtnorm")
library(zoo)
library(quantmod)
library(tseries)
library(PerformanceAnalytics)
library(mvtnorm)

START = "2015-06-01"
END = "2018-06-01"
codigos = c("PETR4", "VALE3", "ITUB4", "BBAS3")

close.zoo = zoo()
index(close.zoo) = as.yearmon(index(close.zoo)) 

for(codigo in codigos) {
  aux = get.hist.quote(instrument=paste(codigo, "SA", sep='.'), 
                       start=START, end=END, 
                       quote="AdjClose", 
                       provider="yahoo", 
                       compression = "m",
                       retclass="zoo", 
                       quiet=TRUE)
  index(aux) = as.yearmon(index(aux)) 
  close.zoo = merge(close.zoo, aux)
}

## MONTECARLOS
ret.df = apply(log(close.df), 2, diff)
n.obs = nrow(ret.df)
n.sim = 1e4
mu.vec = apply(ret.df, 2, mean)
sigma.mat = cov(ret.df)
conta1 = 0
conta2 = 0
conta3 = 0
conta4 = 0
conta5 = 0
P0 = c(126, 250, 378, 502, 629, 753)
for (i in 1:1e6) {
  ret.sim = rmvnorm(n =1000, mean = mu.vec, sigma = sigma.mat)
  rownames(ret.sim) = rownames(ret.df)
  ret.sim = data.frame(ret.sim)
  pf = P0*exp(cumsum(ret.sim))
  if (pf[6] > P0) {
    conta1 = conta1 + 1
  } else if (pf[12] > P0) {
    conta2 = conta2 + 1
  } else if (pf[18] > P0) {
    conta3 = conta3 + 1
  } else if (pf[24] > P0) {
    conta4 = conta4 + 1
  } else {
    conta5 = conta5 + 1
  }
}
conta1/1e4
conta2/1e4
conta3/1e4
conta4/1e4
conta5/1e4
