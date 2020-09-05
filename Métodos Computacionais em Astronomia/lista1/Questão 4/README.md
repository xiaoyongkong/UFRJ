# Questão 4 da Lista 1

Faça um script bash que faça os seguintes procedimentos: a) Descompacte o arquivo do
exercício (l1e4.tar.gz). b) Remova os arquivos do tipo txt que começam com o nome “error”. c)
escreva “feito” dentro dos arquivos restantes. d) Faça um arquivo mesmos_numeros.tar.gz
juntando todos os arquivos iniciados com um mesmo numero (loop for variando de 1 até 40
usando seq e tar -czvf). e) Crie os diretórios com os nomes A, B, C, D, E, F, G, H, I, J (use um
loop for em uma lista de valores, no caso as letras). f) Mova os arquivos para pastas com as
mesmas letras do final nome do arquivo. g) Renomeie os arquivos alterando as letras maiúsculas
para minusculas h) Copie todas as pastas A, B, C ... para uma pasta chamada backup (que deve
ser criada)(use um loop for em uma lista). i) escreva “backup” uma linha antes de “feito” nos
arquivos da pasta backup (use o comando sed). j) Comprima a pasta backup em um arquivo
tar.gz. h) Existe alguma vantagem em executar este código de forma paralela (i.e usando vários
núcleos/operações simultâneas)? Justifique.