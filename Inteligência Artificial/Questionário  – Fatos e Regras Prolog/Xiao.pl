parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
parent(bob,pat).
parent(pat,jim).
parent(jim, karl).
female(pam).
female(liz).
female(ann).
female(pat).
male(tom).
male(bob).
male(jim).
father(X,Y) :- male(X), parent(X,Y).
mother(X,Y) :- female(X), parent(X,Y).

grandparent(X, Z) :- parent(X, Y), parent(Y, Z).
brother(X, Y):- parent(Z, X), parent(Z, Y), X\=Y.
2_children(X) :- parent(X, Y), parent(X, Z), Y\=Z.

ancestral(X, Z) :- parent(X, Z).
ancestral(X, Z) :- parent(X, Y), ancestral(Y, Z).

ancestral_2(X, Z) :- parent(X, Y), ancestral_2(Y, Z).
ancestral_2(X, Z) :- parent(X, Z).

ancestral_3(X, Z) :- parent(X, Z).
ancestral_3(X, Z) :- ancestral_3(Y, Z), parent(X, Y).

ancestral_4(X, Z) :- ancestral4(Y, Z), parent(X, Y).
ancestral_4(X, Z) :- parent(X, Z).



