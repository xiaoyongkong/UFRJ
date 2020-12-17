% Faça um programa Prolog que recebe um número X e uma lista ordenada de forma crescente 
% L1, e retorna a lista ordenada L2 que é obtida acrescentando X a L1. Você não pode usar 
% nenhum predicado pré-definido do swipl.

% lista(X,L,[X|L]) isso aqui funciona mas nao retorna em ordem

lista(X,[H/T],L):-
    X > 0,
    H =< X.
    % lista(X,[X|L1],[L2]):- lista(X,L1,L2).

% Faça um programa Prolog que dado um número qualquer X maior ou igual a zero, 
% retorna em uma lista L, todos os multiplos de 4 que são menores ou iguais a x
mult4(X, L) :-
	X >= 0,
  operation(X, L).

% Caso base
operation(1, []).

% regra para X multiplo de 4
operation(Xa, [X|L]) :-
  Y is Xa mod 4,
  Y = 0,
  X is Xa - 1
	operation(X, L).

% regra para X que não é multiplo de 4
operation(Xa, L):-
  Y is Xa mod 4,
  Y =\= 0,
  X is Xa - 1,
  X > 0,
  operation(X,L).
