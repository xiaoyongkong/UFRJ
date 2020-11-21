import numpy as np

def mmq_reta(observado_y, observado_x, val_inicial, val_final, passos, tolerancia):
  iteracao = 0 
  while (2 * abs((val_inicial-val_final)/(val_inicial+val_final)) > tolerancia):
      mmq_array = np.zeros(passos)
      a_range = np.linspace(val_inicial,val_final,passos)
      for i in range(passos):
          mmq_array[i] = np.sum((observado_y-a_range[i]*observado_x)**2) 
      idx_min = np.argmin(mmq_array)
      val_inicial,ajuste,val_final = a_range[idx_min-1:idx_min+2]
      print('best fit - iter: '+str(iteracao)+' = ', ajuste)
      iteracao += 1
  return ajuste

def chi_quadrado_sen(observado_y,observado_x,erro,val_inicial,val_final,passos,tolerancia):
    iteracao = 0 # para contar quantas iterações fizemos
    while (2*abs((val_inicial-val_final)/(val_inicial+val_final)) > tolerancia):
        chi2_array = np.zeros(passos) # pré-aloca o espaço para os valores do chi2
        w_range = np.linspace(val_inicial,val_final,passos) # gerando valores de teste para o coeficiente
        for i in range(passos):
            chi2_array[i] = np.sum(((observado_y-np.sin(w_range[i]*observado_x))/erro)**2) # calculando os quadrados dos erros para cada teste do coeficiente
        idx_min = np.argmin(chi2_array) # encontrando a posição do mínimo
        val_inicial,ajuste,val_final = w_range[idx_min-1:idx_min+2] # pegando o valor mínimo e seus vizinhos - atualiza para a prox. iteração
        print('best fit - iter: '+str(iteracao)+' - T = ', 2*np.pi/ajuste)
        iteracao += 1
    return ajuste 

# print(mmq_reta(y,x,val_inicial,val_final,passos,tolerancia))
# print(chi_quadrado_sen(observado_y,observado_x,erro,val_inicial,val_final,passos,tolerancia))