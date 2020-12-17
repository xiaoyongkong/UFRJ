% Faça um programa Prolog que recebe um número X e uma lista ordenada de forma crescente 
% L1, e retorna a lista ordenada L2 que é obtida acrescentando X a L1. Você não pode usar 
% nenhum predicado pré-definido do swipl.

% lista(X,L,[X|L]) isso aqui funciona mas nao retorna em ordem

lista(X,[H/T],L):-
    X > 0,
    H =< X.
    % lista(X,[X|L1],[L2]):- lista(X,L1,L2).

% Faça um programa Prolog que dado um número qualquer X maior ou igual a zero, 
% retorna em uma lista L, todos os múltiplos de 4 que são menores ou iguais a X.
mult4(X,[H|T], L]):-
    X >= 0.
