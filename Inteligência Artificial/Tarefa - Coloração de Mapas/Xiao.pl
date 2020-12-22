% Faça um programa Prolog que dado um mapa qualquer, define uma coloração para o mapa usando 
% 4 cores de tal forma que nenhuma região adjacente será pintada com a mesma cor.

map('West Europe',
	[portugal: [spain],
	 spain: [portugal, france],
	 belgium: [france, holland, luxembrg, germany],
	 holland: [belgium, germany],
	 luxembrg: [france, belgium, germany],
	 switzerld: [france,germany,austria, italy],
	 italy: [france,switzerld, austria],
	 austria: [germany, switzerld, italy],
	 france: [spain,belgium,luxembrg, germany,switzerld, italy],
	 germany:[holland,belgium,luxembrg,france,switzerld, austria]]).

% Vamos gerar uma lista de cores 

colors([red,green,blue,purple]).

getcolor(X) :- colors(List), member(X,List).
	/*
	| getcolor(X).    
	X = red ? ;
	X = green ? ;
	X = blue ? ;
	X = purple ? ;
	*/

paint(Map, ColoredMap) :-
	map(Map, Countries),
	colors(ColorList),
	arrangecolors(Countries,ColorList,[], ColoredMap).

arrangecolors([], _ , ColoredMap, ColoredMap).
arrangecolors([Country:Neighbors|Rest], ColorList, TempList, ColoredMap) :-
	member(Color,ColorList),
	arrangecolors(Rest,ColorList,[Country:Color|TempList], ColoredMap).

% Vamos identificar o vizinho do pais que procuramos

findneighbors(X, Map, Who) :-
    map(Map, Countries),
    neighbors(X,Countries,Who).

neighbors(X,[],[]).
neighbors(X,[X:Neighbors|_], Neighbors) :- !. 
neighbors(X,[_|RestofCountries], Neighbors) :-
	neighbors(X,RestofCountries, Neighbors).

	/*
	|?- findneighbors(holland,'West Europe',X).
	X = [belgium,germany]
	*/

% Vamos verificar se o pais é adjacente
adjacent(X,Y,Map) :-
    findneighbors(X, Map, Countries),
    member(Y, Countries).

	/*
	| ?- adjacent(holland, germany, 'West Europe').
	true ? 
	| ?- adjacent(holland, france, 'West Europe').
	no
	| ?- adjacent(spain, france, 'West Europe').  
	true ? 
	*/

