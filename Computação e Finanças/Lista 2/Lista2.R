# Lista 2 de Computação e finanças
# Xiao Yong Kong - 114176987

#install.packages("tseries")
library(tseries)
library(zoo)
library(PerformanceAnalytics)
library(rstudioapi)
library(quantmod)

START = "2010-09-30"
END = "2019-09-30"

resultados = c("^BVSP", "PETR3","ABEV3","BRFS3","EMBR3","RADL3","CIEL3")

# Preenche valores faltantes com valores interpolados
ibov.m.zoo = na.approx(ibov.m.zoo)

head(ibov.m.zoo)

index(ibov.m.zoo) = as.yearmon(index(ibov.m.zoo)) 

# close.m.zoo dados fechamento ajustado compressao mensal
close.m.zoo = ibov.m.zoo

# acrescenta os demais ativos
for(i in 2:length(resultados)) {
  aux.zoo = get.hist.quote(instrument=paste(resultados[i], "SA", sep='.'), start=START, end=END, quote="AdjClose",provider="yahoo", origin="1970-01-01",compression="m", retclass="zoo", quiet=TRUE)
  aux.zoo = na.approx(aux.zoo)
  index(aux.zoo) = as.yearmon(index(aux.zoo)) 
  close.m.zoo = merge(close.m.zoo, aux.zoo)
}
head(close.m.zoo)

# close.m.df dados fechamento ajustando em formato dataframe compressao mensal
# transforma o objeto zoo em um dataframe e d??? nomes ???s colunas
close.m.df = data.frame(close.m.zoo)
colnames(close.m.df) = resultados
head(close.m.df)
tail(close.m.df)

###################################### Questão 1 #######################################

# Trace gráficos separados para os retornos continuamente compostos de todos os ativos/
# índice listados acima. Para facilitar a comparação entre os índices use a mesma escala no eixo
# y de todos os gráficos.

# calcula retornos continuamente composto mensais
n = nrow(close.m.df)

# ret.cc.m.df = retornos cc compressao mensal dataframe
ret.cc.m.df = log(close.m.df[2:n,]/close.m.df[1:n-1,])
head(ret.cc.m.df)

ano = seq(as.Date("2010/09/30"), by = "month", length.out = n-1)
layout(mat = c(1, 2))
plot(ano, ret.cc.m.df[, '^BVSP'], type = 'l', lwd = 2, ylab = 'BVSP', ylim=c(-1,1), main="Retornos Mensais CC BVSP")
plot(ano, ret.cc.m.df[, 'PETR3'], type = 'l', lwd = 2, ylab = 'PETR3',ylim=c(-1,1), main="Retornos Mensais CC PETR3")
plot(ano, ret.cc.m.df[, 'ABEV3'], type = 'l', lwd = 2, ylab = 'ABEV3',ylim=c(-1,1), main="Retornos Mensais CC ABEV3")
plot(ano, ret.cc.m.df[, 'BRFS3'], type = 'l', lwd = 2, ylab = 'BRFS3',ylim=c(-1,1), main="Retornos Mensais CC BRFS3")
plot(ano, ret.cc.m.df[, 'EMBR3'], type = 'l', lwd = 2, ylab = 'EMBR3',ylim=c(-1,1), main="Retornos Mensais CC EMBR3")
plot(ano, ret.cc.m.df[, 'RADL3'], type = 'l', lwd = 2, ylab = 'RADL3',ylim=c(-1,1), main="Retornos Mensais CC RADL3")
plot(ano, ret.cc.m.df[, 'CIEL3'], type = 'l', lwd = 2, ylab = 'CIEL3',ylim=c(-1,1), main="Retornos Mensais CC CIEL3")

layout(1)

###################################### Questão 2 #######################################

#Para cada um dos ativos trace o gráfico do retorno simples mensal acumulado ao longo
#do período considerado. Para traçar o gráfico considere que investiu R$ 1,00 no início do
#período e calcule como cada investimento evoluiu. Todos os gráficos dever ser superpostos no
#mesmo gráfico. Lembre-se que para traçar estes gráficos você deve usar retornos simples
#mensal.

n = nrow(close.m.df)
ret.simples = ((close.m.df[2:n,] - close.m.df[1:(n-1),])/close.m.df[1:n-1,])
r.simples = exp(ret.cc.m.df) -1 

ret.simples
r.simples
ano = seq(as.Date("2010/09/30"), by = "month", length.out = n-1)
layout(mat = c(1, 2))
plot(ano, ret.simples[, '^BVSP'], type = 'l', lwd = 2, ylab = 'BVSP', ylim=c(-1,1), main="Retornos Mensais CC BVSP")
plot(ano, ret.simples[, 'PETR3'], type = 'l', lwd = 2, ylab = 'PETR3',ylim=c(-1,1), main="Retornos Mensais CC PETR3")
plot(ano, ret.simples[, 'ABEV3'], type = 'l', lwd = 2, ylab = 'ABEV3',ylim=c(-1,1), main="Retornos Mensais CC ABEV3")
plot(ano, ret.simples[, 'BRFS3'], type = 'l', lwd = 2, ylab = 'BRFS3',ylim=c(-1,1), main="Retornos Mensais CC BRFS3")
plot(ano, ret.simples[, 'EMBR3'], type = 'l', lwd = 2, ylab = 'EMBR3',ylim=c(-1,1), main="Retornos Mensais CC EMBR3")
plot(ano, ret.simples[, 'RADL3'], type = 'l', lwd = 2, ylab = 'RADL3',ylim=c(-1,1), main="Retornos Mensais CC RADL3")
plot(ano, ret.simples[, 'CIEL3'], type = 'l', lwd = 2, ylab = 'CIEL3',ylim=c(-1,1), main="Retornos Mensais CC CIEL3")

layout(1)

# Compute gross returns
ret.simples <- 1 + ret.simples

# Compute future values
ret._fv <- cumprod(ret.simples)
ret._fv
# Plot the evolution of the $1 invested in SBUX as a function of time
plot(ano,ret._fv[,'PETR3'], type = "l", col = "blue", lwd = 2,ylim=c(-1,12), ylab = "Dollars",main = "FV of $1 invested in SBUX")
lines(ano,ret._fv[,'ABEV3'], type = "l", col = "red",lwd = 2)
lines(ano,ret._fv[,'^BVSP'], type = "l", col = "green",lwd = 2)
lines(ano,ret._fv[,'BRFS3'], type = "l", col = "yellow",lwd = 2)
lines(ano,ret._fv[,'EMBR3'], type = "l", col = "purple",lwd = 2)
lines(ano,ret._fv[,'RADL3'], type = "l", col = "brown",lwd = 2)
lines(ano,ret._fv[,'CIEL3'], type = "l", col = "black",lwd = 2)

###################################### Questão 3 #######################################

# Para os retornos continuamente compostos de cada ativo trace um gráfico com quatro
# painéis contendo um histograma, um plot da densidade, um boxplot e um gráfico QQ.

plot(ano, ret.cc.m.df[, '^BVSP'], type = 'l', lwd = 2, ylab = 'BVSP', ylim=c(-1,1), main="Retornos Mensais CC BVSP")
boxplot(ret.cc.m.df[, '^BVSP'], col = 'slateblue1',
        ylab = 'retorno mensal cc',
        main = 'Boxplot dos retornos mensais cc da Bovespa')
BVSP.m.density = density(ret.cc.m.df[, '^BVSP'])
plot(BVSP.m.density, type = 'l', xlab = 'retornos mensais',
     ylab = 'densidade estimada', 
     main = 'Histograma suavizado para os retornos mensais cc de BVSP',
     col = 'orange', lwd = 2)
hist(ret.cc.m.df[, '^BVSP'], 
     main = 'Histograma dos retornos mensais cc em ^BVSP', 
     col = 'slateblue1')
qqnorm(ret.cc.m.df[, '^BVSP'], main = 'BVSP')
qqline(ret.cc.m.df[, '^BVSP'])

plot(ano, ret.cc.m.df[, 'PETR3'], type = 'l', lwd = 2, ylab = 'PETR3',ylim=c(-1,1), main="Retornos Mensais CC PETR3")
plot(ano, ret.cc.m.df[, 'ABEV3'], type = 'l', lwd = 2, ylab = 'ABEV3',ylim=c(-1,1), main="Retornos Mensais CC ABEV3")
plot(ano, ret.cc.m.df[, 'BRFS3'], type = 'l', lwd = 2, ylab = 'BRFS3',ylim=c(-1,1), main="Retornos Mensais CC BRFS3")
plot(ano, ret.cc.m.df[, 'EMBR3'], type = 'l', lwd = 2, ylab = 'EMBR3',ylim=c(-1,1), main="Retornos Mensais CC EMBR3")
plot(ano, ret.cc.m.df[, 'RADL3'], type = 'l', lwd = 2, ylab = 'RADL3',ylim=c(-1,1), main="Retornos Mensais CC RADL3")
plot(ano, ret.cc.m.df[, 'CIEL3'], type = 'l', lwd = 2, ylab = 'CIEL3',ylim=c(-1,1), main="Retornos Mensais CC CIEL3")

###################################### Questão 4 #######################################

# Aplique as funções do R summary(), mean(), var(), sd(), skewness()
# e kurtosis() aos retornos continuamente compostos de cada um dos ativos. Coloque em
# ordem do mais arriscado para o mais seguro usando o desvio padrão como medida de risco.
# Coloque também em ordem do mais rentável para o menos rentável, usando a média do valor
# esperado. Use as funções kurtosis e skewness da biblioteca
# PerformanceAnalytics. Compare a ordem dos ativos nos dois resultados ordenados.

desvios = c()
for(resultado in resultados) {
  print(resultado)
  print(mean(ret.cc.m.df[,resultado]))
  print(var(ret.cc.m.df[,resultado]))
  print(sd(ret.cc.m.df[,resultado]))
  print(skewness(ret.cc.m.df[,resultado]))
  print(kurtosis(ret.cc.m.df[,resultado]))
  print(summary(ret.cc.m.df[,resultado]))
  aux = c(sd(ret.cc.m.df[,resultado]))
  desvios =  c(teste,aux)    
  
}
desvios

#ordenando
print("do mais seguro ao mais arriscado")
for (i in order(teste)) {
  print(resultados[i])
}


###################################### Questão 5 #######################################

# Para cada um dos ativos calcule os quantis empíricos 1% e 5% dos retornos
# continuamente compostos (use a função quantile()). Usando estes resultados calcule o
# valor em risco a 1% e 5% baseado em um investimento inicial de R$ 100.000,00. Comente e
# compare com os resultados do exercício anterior.

apply(retornos, 2, quantile, probrs = c(0.01,0.05))
100 * .Last.value[2,] #valor em risco (com probabilidade = 5%)

###################################### Questão 6 #######################################

# Use a função pairs() para gerar gráficos de dispersão dos retornos continuamente
# compostos mensais de todos os pares de ativos. Comente se há alguma relação entre pares de
# ativos.

pairs(retornos)

###################################### Questão 7 #######################################

# Use as funções corrplot() e corrplot.mixed() do pacote corrplot para
# obter uma visualização gráfica da matriz de correlações dos retornos dos ativos.

library(corrplot)
corrplot(cor(retornos))
corrplot.mixed(cor(retornos))

###################################### Questão 8 #######################################

# Use a função Acf do pacote forecast para calcular e traçar gráficos das auto
# correlações amostrais dos retornos continuamente compostos de cada ativo. Comente os
# resultados.
for(resultado in resultados){
  acf(retornos[,resultado],main = resultado)
}

###################################### Questão 9 #######################################

# Vamos assumir que criaremos um portfólio com todos os ativos e mais o índice IBOV.
# Como temos 7 itens no portfólio considere um peso igual para cada ativo, ou seja cada ativo
# terá uma participação igual a 1/7. Calcule os seguintes itens.

#### 1 - Retorno do portfólio.

last = tail(ret._fv, 1)
last
ultret = as.matrix(sapply( last, as.numeric)) -1
retorno = t(participacao) %*% ultret
retorno

#### 2 - Matriz de covariância do portfólio.

cov = cov(ret.cc.m.df)
cov

#### 3 - Variância do portfólio.

var_port = t(participacao) %*% cov %*% participacao
var_port

#### 4 - Desvio padrão do portfólio.

dv = sqrt(var_port)
dv

###################################### Questão 10 #######################################

# Compare e comente os valores do retorno e do desvio padrão do portfólio com o retorno
# e desvio padrão de cada ativo que participa portfólio.

# O retorno do portfolio foi maior que o retorno cada uma das acoes
# ao mesmo tempo que o desvio padrao do portfolio tambem foi bem menor que o desvio padrao 
# de cada acao
