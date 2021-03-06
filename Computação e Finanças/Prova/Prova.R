# Prova �nica de Computa��o e finan�as
# Xiao Yong Kong - 114176987

#Install Packages
install.packages("tseries", dependencies = TRUE)
install.packages("tseries", repos=c("http://rstudio.org/_packages", "http://cran.rstudio.com"))
install.packages("PerformanceAnalytics")
install.packages("readxl")
install.packages("FinCovRegularization")

#imports
source('portfolio.r')
library(zoo)
library(tseries)
library(readxl)
library(quadprog)



###################################### Quest�o 1 #######################################
# Para fins de compara��o, trace a fronteira da bala de Markowitz para os ativos na
# carteira do E2M, se posi��es short fossem permitidas. Voc� pode usar as fun��es no
# arquivo portfolio.r se quiser. 

# lendo dados
getwd()
closeDF = read_excel(path = "close.xlsx", sheet = "close")
close.df = data.frame(closeDF)
close.df[1] <- NULL
close.df

# pega simples
ret.df = apply(log(close.df), 2, diff)
ret.df = exp(ret.df) 
ret.df = ret.df -1
ret.df = data.frame(ret.df)
ret.df

# valor esperado dos retornos mensais
mu.vec = apply(ret.df, 2, mean)
mu.vec

# a matriz de covariancia amostral
sigma.mat = cov(ret.df)
sigma.mat

# determina a fronteira eficiente com o ???acote do zivot
# com shorts
ef = efficient.frontier(er = mu.vec, cov.mat = sigma.mat, nport = 30,
                        shorts=TRUE, alpha.min = -2, alpha.max = 2) 
#hora de plotar
plot(ef,plot.assets = T, col='blue')

###################################### Quest�o 2 #######################################
# No mesmo gr�fico anterior, trace agora a fronteira da bala de Markowitz quando
# posi��es short n�o s�o permitidas.

ef2 = efficient.frontier(er = mu.vec, cov.mat = sigma.mat, nport = 30,shorts=FALSE, alpha.min = -2, alpha.max = 2)

plot(ef, col='blue', pch = 16)
points(ef2$sd, ef2$er, col='black')

###################################### Quest�o 3 #######################################
# Determine os pesos das a��es no portf�lio de vari�ncia m�nima global (GMVP) sem
# posi��es short. Marque a posi��o do GMVP no mesmo gr�fico dos itens anteriores.

gmvp = globalMin.portfolio(er = mu.vec, cov.mat = sigma.mat, shorts = FALSE)
gmvp$weights

plot(ef, col='blue', pch = 16)
points(ef2$sd, ef2$er, col='black')
points(gmvp$sd, gmvp$er, col = 'pink', pch = 16)
text(gmvp$sd, gmvp$er,labels = 'gmvp')

###################################### Quest�o 4 #######################################
# Determine os pesos das a��es no portf�lio tangente sem posi��es short. Marque a
# posi��o do portf�lio tangente no mesmo gr�fico dos itens anteriores.

rf = 0.0
tan.port = tangency.portfolio(er = mu.vec, cov.mat = sigma.mat, risk.free = rf, shorts = F)
print("pesos")
tan.port$weights

plot(ef, col='blue', pch = 16)
points(ef2$sd, ef2$er, col='black')
points(gmvp$sd, gmvp$er, col = 'pink', pch = 16)
text(gmvp$sd, gmvp$er,labels = 'gmvp')
points(tan.port$sd, tan.port$er, col='red',pch=16)
text(tan.port$sd, tan.port$er, labels = 'ptan')

###################################### Quest�o 5 #######################################
# No mesmo gr�fico dos itens anteriores, trace a reta dos investimentos eficientes, isto �,
# a reta que passa pelo ativo livre de risco (o caixa do fundo) e o portf�lio tangente.

closeDF = read_excel(path = "close.xlsx", sheet = "close")
close.df = data.frame(closeDF)
close.df
# close.df[1] <- NULL
ret.df = apply(log(close.df[2:13]), 2, diff)
ret.df = exp(ret.df) 
ret.df = ret.df -1
ret.df = data.frame(ret.df)
mu.vec = apply(ret.df, 2, mean)
mu.vec

rf = 0
mu.vec
sigma.mat
tan.port = tangency.portfolio(er = mu.vec, cov.mat = sigma.mat, risk.free = rf, shorts = F)
tan.port

# tra�a a reta dos investimentos eficientes
sr.tan = (tan.port$er - rf)/tan.port$sd
plot(ef$sd, ef$er, pch = 16, xlim=c(-0.01,0.21), ylim=c(-0.01,0.07))
points(ef2$sd, ef2$er, col='black')
points(gmvp$sd, gmvp$er, col = 'pink', pch = 16)
text(gmvp$sd, gmvp$er,labels = 'gmvp')
points(tan.port$sd, tan.port$er, col='red',pch=16)
text(tan.port$sd, tan.port$er, labels = 'ptan')
abline(a = rf, b = sr.tan, col = 'green', lwd = 2)

###################################### Quest�o 6 #######################################
# No mesmo gr�fico dos itens anteriores marque a posi��o no plano do portf�lio
# selecionado pelo gestor do E2M.

pesosE2M = read_excel(path = "close.xlsx", sheet = "x.vec", col_names = FALSE  )
pesosE2M
pesos.e2m = data.frame(pesosE2M)
head(pesos.e2m)
t(pesosE2M[2])
pesos = pesos.e2m
e2m = getPortfolio(er = mu.vec, cov.mat = sigma.mat, weights = t(pesos.e2m[2]))
e2m
plot(ef$sd, ef$er, pch = 16, xlim=c(0.0,0.2), ylim=c(-0.01,0.06))
points(ef2$sd, ef2$er, col='black')
points(gmvp$sd, gmvp$er, col = 'pink', pch = 16)
text(gmvp$sd, gmvp$er,labels = 'gmvp')
points(tan.port$sd, tan.port$er, col='red',pch=16)
text(tan.port$sd, tan.port$er, labels = 'ptan')
points(e2m$sd, e2m$er, col = 'yellow', pch = 16, cex = 2)
text(e2m$sd, e2m$er, labels = 'e2m')
abline(a = rf, b = sr.tan, col = 'green', lwd = 2)

e2m
y = efficient.portfolio(er = mu.vec, cov.mat = sigma.mat,target.return = e2m$er, shorts = F)
y
plot(ef$sd, ef$er, pch = 16, xlim=c(0.0,0.2), ylim=c(-0.01,0.06) )
points(ef2$sd, ef2$er, col='blue', pch = 16)
points(gmvp$sd, gmvp$er, col = 'green', pch = 16)
points(tan.port$sd, tan.port$er, col = 'pink', pch = 16)
points(e2m$sd, e2m$er, col = 'yellow', pch = 16)
points(y$sd,y$er,col="orange",pch=16)
abline(a = rf, b = sr.tan, col = 'green', lwd = 2)

###################################### Quest�o 7 #######################################
# Determine os pesos das a��es no portf�lio eficiente (um portf�lio sobre a reta dos
# portf�lios eficientes) que tem a mesma volatilidade do portf�lio do E2M. Trace esse
# ponto no gr�fico.

rf = 0
# peso do portfolio tangente
x.t = (e2m$sd -rf)/( tan.port$sd- rf)

x.f = 1 - x.t

mu.p.e = rf + x.t*(tan.port$sd - rf)

sig.p.e = x.t*e2m$er

x.t*tan.port$weights

eff = getPortfolio(er = mu.vec, cov.mat = sigma.mat, weights = x.t*tan.port$weights)

plot(ef$sd, ef$er, xlim=c(0.0,0.2), ylim=c(-0.01,0.06) )
points(ef2$sd, ef2$er, col='blue', pch = 16)
points(gmvp$sd, gmvp$er, col = 'green', pch = 16)
points(tan.port$sd, tan.port$er, col = 'pink', pch = 16)
points(e2m$sd, e2m$er, col = 'yellow', pch = 16)
text(e2m$sd, e2m$er, labels="E2M")
points(y$sd,y$er,col="orange",pch=16)
abline(a = rf, b = sr.tan, col = 'green', lwd = 2)
points(eff$sd ,eff$er, col="red", pch=16)
#points(x =  pesosE2M, y =)
text(eff$sd ,eff$er, labels = 'ef', pos = 2)

###################################### Quest�o 8 #######################################
# Usando a fun��o charts.PerformanceSummary() do pacote
# PerformanceAnalytics, obtenha os gr�ficos do retorno acumulado e m�ximo
# drawdown para o portf�lio do gestor do E2M

closeDF = read_excel(path = "close.xlsx", sheet = "close")
close.df = data.frame(closeDF)

close.df
close2.df <- close.df[,-1]
rownames(close2.df) <-close.df[,1]
head(close2.df)
tail(close2.df)
close2.df
ret.df = apply(log(close2.df), 2, diff)
ret.df = exp(ret.df) 
ret.df = ret.df -1
typeof(ret.df)
# ret.df  do tipo matrix. Convertendo para um data.frame:
ret.df = data.frame(ret.df)
ret.df
kpop  = matrix(c(e2m$weights),nrow = 12,ncol = 1)
Jungkook  = data.matrix(ret.df)
jhope = Jungkook %*% kpop
charts.PerformanceSummary(R = jhope, Rf=0)
