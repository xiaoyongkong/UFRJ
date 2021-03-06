# Lista 1 de Computa��o e finan�as
# Xiao Yong Kong - 114176987

#EDP Energias do Brasil SA
enbr3.sa_ac <- read.csv(file="ENBR3.SA.AC.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)

#Sul America SA Brazilian Units
sula11.sa_ac <- read.csv(file="SULA11.SA.AC.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)

head(enbr3.sa_ac)
head(sula11.sa_ac)

###################################### Quest�o 1 #######################################
# Quais s�o os principais tipos de a��es negociadas na B3. Explique o que significam os
# n�meros 3, 4, 5, 6 e 11 nos nomes de a��es sendo negociadas na B3.

# R: A��o 3 � para A��es Ordin�rias Nominativas.
# A��o 4, 5 e 6 s�o �ra A��es Preferenciais Nominativas, onde 4 � para classe A, 5 para B e 6 para classe C.
# N�o h� uma regra espec�fica para a a��o negociada com o n�mero 11. Geralmente este n�mero representa os 
# recibos de a��es de empresas estrangeiras negociadas na bolsa brasileira, os chamados 
# BDRs (Brazilian Deposits Receipts). Al�m disso, o 11 tamb�m representa as Units, que s�o ativos 
# compostos por mais de um tipo de a��o, bem como os fundos de �ndices, conhecido como ETFs - Exchange Traded Funds.

###################################### Quest�o 2 #######################################

# Qual � o retorno simples no m�s de julho calculado entre 01 de julho de 2010 e 01 de 
# agosto de 2010 em cada um dos ativos

# Retorno simples da EDP energias Brasil
# formula do retorno simples
# Rt = Pt - Pt-1 / Pt-1

MesdeJulho <- enbr3.sa_ac[1,2]
MesdeJulho
RS.enbr3 <- ((enbr3.sa_ac[2, 2] - enbr3.sa_ac[1, 2])/enbr3.sa_ac[1, 2])

RS.enbr3 


RS.sula11 <-((sula11.sa_ac[2, 2] - sula11.sa_ac[1, 2])/sula11.sa_ac[1, 2])
RS.sula11

###################################### Quest�o 3 #######################################

# Se voc� possu�a um capital de R$ 20,000.00 e investiu 50% em cada um dos ativos em 01 de julho de 2010, 
# quanto o seu capital total valer� em 01 de agosto de 2010?

V <- 20000

#preco da enbr3 em julho
enbr3.sa_ac.jul <- enbr3.sa_ac[1, 2]

#preco da sula11 em julho
sula11.sa_ac.jul <- sula11.sa_ac[1, 2]

qtde_enbr3 <- 10000/enbr3.sa_ac.jul
qtde_sula11 <- 10000/sula11.sa_ac.jul

V.initial <- enbr3.sa_ac.jul*qtde_enbr3 + sula11.sa_ac.jul*qtde_sula11
#participacao no portfolio

x.enbr3 <- (enbr3.sa_ac.jul*qtde_enbr3)/V.initial
x.sula11 <- (sula11.sa_ac.jul*qtde_sula11)/V.initial

#precos ao fim de agosto
enbr3.sa_ac.ago <- enbr3.sa_ac[2, 2]
sula11.sa_ac.ago <- sula11.sa_ac[2, 2]

# Valor final do portfolio
V.final <- (x.enbr3 * RS.enbr3) + (x.sula11*RS.sula11)
V.final <- V.initial * (1 + V.final)
V.final


###################################### Quest�o 4 #######################################
# Qual foi o retorno simples obtido para o total do investimento?
  
  
RS.V <- (V.final - V.initial) /V.initial
RS.V

###################################### Quest�o 5 #######################################
# Qual � o retorno continuamente composto mensal entre 01 de julho de 2010 e 01 de agosto de 2010 em 
# cada um dos ativos?
  
  rt = log(pt) - log(pt-1)

r.t =  log(enbr3.sa_ac.ago) - log(enbr3.sa_ac.jul)
r.t

###################################### Quest�o 6 #######################################
# Converta estes retornos continuamente compostos para retornos simples. Note que voc� deve 
# obter a mesma resposta que a da quest�o anterior.

R = exp(r) - 1

r.s = exp(r.t) -1
r.s

###################################### Quest�o 7 #######################################
# Qual � o retorno anual simples de cada um dos ativos entre 01 de julho de 2010 e 01 de julho de 2011?
  

RSAnual.enbr3 <- ((enbr3.sa_ac[13, 2] - enbr3.sa_ac[1, 2])/enbr3.sa_ac[1, 2])
RSAnual.enbr3 
# AGORA COM SULA11
RSAnual.sula11 <- ((sula11.sa_ac[13, 2] -sula11.sa_ac[1, 2])/sula11.sa_ac[1, 2])

RSAnual.sula11 

###################################### Quest�o 8 #######################################
#Se voc� possu�a um capital de R$ 20,000.00 e investiu R$10,000.00 em cada um dos
# ativos em 01 de julho de 2010, quanto o seu capital total valer� em 01 de julho de 2011?



# Valor final do portfolio
V.final <- (x.enbr3 * RSAnual.enbr3) + (x.sula11*RSAnual.sula11)
V.final <- V.initial * (1 + V.final)
V.final


###################################### Quest�o 9 #######################################
# Qual foi o retorno simples obtido para o total do investimento?
  
RSA.V <- (V.final - V.initial) /V.initial
RSA.V

###################################### Quest�o 10 #######################################
# Calcule os retornos mensais simples dos dois ativos entre 01 de julho de 2010 e 01 de julho de 2019.


RSMensal.enbr3 <- ((enbr3.sa_ac[2:109, 2] - enbr3.sa_ac[1:108, 2])/enbr3.sa_ac[1:108, 2])
RSMensal.enbr3

RSMensal.sula11 <- ((sula11.sa_ac[2:109, 2] - sula11.sa_ac[1:108, 2])/sula11.sa_ac[1:108, 2])
RSMensal.sula11

###################################### Quest�o 11 #######################################
# Fa�a um gr�fico destes retornos mensais simples dos dois ativos. Coloque-os no mesmo gr�fico 
# e coloque t�tulos e r�tulos informativos.

plot(RSMensal.enbr3)

plot(RSMensal.sula11, type = "l", col = "blue", lwd = 2, ylab = "Return",
     main = "Monthly Returns on SBUX")
plot(RSMensal.enbr3, RSMensal.sula11)

###################################### Quest�o 12 #######################################
# Para cada um dos ativos calcule a m�dia (??) dos retornos mensais simples e o desvio padr�o (??) 
# dos retornos ao longo do per�odo.

mean(RSMensal.enbr3)
sd(RSMensal.enbr3)
print("Valores para SULA11")
print("media: ")
mean(RSMensal.sula11)
sd(RSMensal.sula11)

###################################### Quest�o 13 #######################################
# Considere que voc� investiu R$ 1.00 em cada um dos ativos em 01 de julho de 2010.
# Fa�a um gr�fico da evolu��o deste valor at� 01 de julho de 2019.

grenbr3 <- 1 + RSMensal.enbr3

fv_enbr3 <- cumprod(grenbr3)
fv_enbr3
plot(fv_enbr3, type = "l", col = "yellow", lwd = 1, ylab = "Reais",
     main = "Retorno para 1 Real investido na  ENBR3 De 2010 at� 2019")

sula11 <- 1 + RSMensal.sula11

fv_sula11 <- cumprod(sula11)
fv_sula11
plot(fv_sula11, type = "l", col = "blue", lwd = 1, ylab = "Reais", 
     main = "Retorno para 1 1 Real investido na SULA11 De 2010 at� 2019")

####################################### Quest�o 14 #######################################
# Comente os gr�ficos e os resultados das m�dias e desvios padr�o. H� alguma rela��o entre eles.
