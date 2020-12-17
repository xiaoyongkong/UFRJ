fib(1,0).
fib(2,1).

fib(X,N) :-
    X > 2,
    X1 is X-1,
    fib(X1,N1),
    X2 is X-2,
    fib(X2,N2),
    N is N1+N2.