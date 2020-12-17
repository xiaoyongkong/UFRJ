Considere o seguinte programa Prolog
parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
parent(bob,pat).
parent(pat,jim).
female(pam).
female(liz).
female(ann).
female(pat).
male(tom).
male(bob).
male(jim).
father(X,Y) - male(X), parent(X,Y).
mother(X,Y) - female(X), parent(X,Y).

Defina uma regra Prolog para relação irmaos(X,Y) que representa que X é irmãoirmã de Y. Caso seja necessário, você pode definir outros predicados para auxiliar na tarefa. Considere que os irmãos tem o mesmo pai e a mesma mãe.

Entregue sua resposta em um arquivo SEU_NOME.pl.