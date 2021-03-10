
f([], _, []).

f([Head | Tail], R, [Head | L1]) :-
    not(member(Head, R))
    f(Tail, R, L1).

f([Head | Tail], R, L1) :-
    member(Head, R),
    f(Tail, R, L1).
