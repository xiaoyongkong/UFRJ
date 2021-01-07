%----------------------------------------------------------------------
% Tarefa - Jarras

% Breno Costa - 114036496
% Xiao Yong Kong - 114176987 
%----------------------------------------------------------------------

%--------------
% letra a
%--------------

objetivo((2, _)).

%--------------
% letra b
%--------------

acao((J1, J2), encher1, (4, J2)) :- J1 < 4.
acao((J1, J2), encher2, (J1, 3)) :- J2 < 3.
acao((J1, J2), esvaziar1, (0, J2)) :- J1 > 0.
acao((J1, J2), esvaziar2, (J1, 0)) :- J2 > 0.

acao((J1, J2), passar12, (J1a, J2a)) :-   
    J2 < 3, J1 > 0,
    Cabe2 is 3 - J2,
    Cabe2 < J1,
    J1a is J1 - Cabe2,
    J2a is J2 + Cabe2.

acao((J1, J2), passar12, (J1a, J2a)) :-
    J2 < 3, J1 > 0,
    3 - J2 >= J1,
    J1a is 0,
    J2a is J2 + J1.

acao((J1, J2), passar21, (J1a, J2a)) :-
    J1 < 4, J2 > 0,
    Cabe1 is 4 - J1,
    Cabe1 < J2,
    J1a is J1 + Cabe1,
    J2a is J2 - Cabe1.

acao((J1, J2), passar21, (J1a, J2a)) :-
    J1 < 4, J2 > 0,
    4 - J1 >= J2,
    J2a is 0,
    J1a is J1 + J2.

%--------------
% letra c
%--------------

vizinhos(N, FilhosN) :-
    findall(Na, acao(N, _, Na), FilhosN).

%--------------
% letra d
%--------------

adicionar_fronteira_largura(FilhosN, F1, F2) :-
    append(F1, FilhosN, F2).

bfs_simples([Node|_]) :- objetivo(Node), !.
bfs_simples([Node|F1]) :-
    vizinhos(Node, FilhosN),
    adicionar_fronteira_largura(FilhosN, F1, F2),
    bfs_simples(F2).

busca_largura_simples(Inicio) :-
    bfs_simples([Inicio]).

% Resposta: Só responde true (caso ache solução objetiva).
% Isto ocorre porque não esta sendo salva a arvore que está sendo formado na busca
% já que não existe, por exemplo, um argumento.

%--------------
% letra e
%--------------

% Duas abordagens para guardar a sequencia: 
% 1. Retornar todas as configurações percorridas (busca_largura_repeticao_1)
% 2. Retornar o caminho do inicio ate o nó objetivo (busca_largura_repeticao_2)

%---------------------
% Primeira Abordagem
%---------------------

bfs_repeticao_1([Node|_], [Node]) :- objetivo(Node).
bfs_repeticao_1([Node|F1], [Node|L]) :-
    vizinhos(Node, FilhosN),
    adicionar_fronteira_largura(FilhosN, F1, F2),
    bfs_repeticao_1(F2, L).

% Retorna todos os nós percorridos na busca 
busca_largura_repeticao_1(Inicio, S) :-
	bfs_repeticao_1([Inicio], S).

%--------------------
% Segunda Abordagem
%--------------------

vizinhos_caminho([N|Caminho], FilhosN) :-
    findall([Na, N|Caminho], acao(N, _, Na), FilhosN).

bfs_repeticao_2([[Node|Caminho]|_], [Node|Caminho]) :- 
    objetivo(Node).

bfs_repeticao_2([Caminho|F1], S) :-
    vizinhos_caminho(Caminho, FilhosN),
    adicionar_fronteira_largura(FilhosN, F1, F2),
    bfs_repeticao_2(F2, S).

% Retorna somente o caminho do inicio até o nó objetivo:
busca_largura_repeticao_2(Start, L) :-
    bfs_repeticao_2([[Start]], S),
    reverse(S, L).

%--------------
% letra f
%--------------

% Evitar os estados repetidos

% Duas abordagens: 
% 1. Retornar todas as configurações percorridas (busca_largura_1)
% 2. Retornar o caminho do inicio ate o nó objetivo (busca_largura_2)

%---------------------
% Primeira Abordagem
%---------------------

member(X, [X|_]) :- !.
member(X, [_|T]) :- member(X, T).

dif([], _, []) :- !.
dif(L, [], L) :- !.
dif(L, L, []) :- !.
dif([H1|T1], L2, L3) :-
    member(H1, L2), !,
    dif(T1, L2, L3), !.
dif([H1|T1], L2, [H1|T2]) :-
    dif(T1, L2, T2).

bfs_1([Node|_], _, [Node]) :- objetivo(Node).
bfs_1([Node|F1], Visitados, [Node|R]) :-
    vizinhos(Node, FilhosN),
    dif(FilhosN, Visitados, FilhosUnicos),
    append(FilhosUnicos, Visitados, Visitados1),
    adicionar_fronteira_largura(FilhosUnicos, F1, F2),
    bfs_1(F2, Visitados1, R).

% Retorna todos os nós percorridos na busca 
busca_largura_1(Inicio, R) :-
    bfs_1([Inicio], Inicio, R).

%--------------------
% Segunda Abordagem
%--------------------

vizinhos_caminho_sem_repeticao([N|Caminho], Gerados, FilhosN) :-
    findall([Na, N|Caminho], 
            (acao(N, _, Na), \+(member(Na, Gerados))), 
            FilhosN).

bfs_2([[Node|Caminho]|_], _, [Node|Caminho]) :- objetivo(Node).
bfs_2([Caminho|F1], Gerados, S) :-
    vizinhos_caminho_sem_repeticao(Caminho, Gerados, FilhosN),
    flatten(FilhosN, FilhosFlat),
    append(FilhosFlat, Gerados, Gerados1),
    adicionar_fronteira_largura(FilhosN, F1, F2),
    bfs_2(F2, Gerados1, S).

% Retorna o caminho do inicio até nó solução
busca_largura_2(Inicio, L) :-
    bfs_2([[Inicio]], [Inicio], S),
    reverse(S, L).

% ---------------------------------------------------------------
% Busca em Profundidade - Letra G
% ---------------------------------------------------------------

%--------------
% letra d
%--------------

adicionar_fronteira_prof(FilhosN, F1, F2) :-
    append(FilhosN, F1, F2).

dfs_simples([Node|_]) :- objetivo(Node).
dfs_simples([Node|F1]) :-
    vizinhos(Node, FilhosN),
    adicionar_fronteira_prof(FilhosN, F1, F2),
    dfs_simples(F2).

busca_prof_simples(Inicio) :-
    dfs_simples([Inicio]).

% Resposta: Ocorreu um estouro de pilha, pois como não há um controle para
% evitar passagem por estados já gerados, a busca percorre:
% [(0,0), (4,0), (4,3), (0,3), (4,3), (0,3)...] e fica presa neste ciclo.

%--------------
% letra e
%--------------

% Guardar a sequencia

% Duas abordagens: 
% 1. Retornar todas as configurações percorridas (busca_prof_repeticao_1)
% 2. Retornar o caminho do inicio ate o nó objetivo (busca_prof_repeticao_2)

%---------------------
% Primeira Abordagem
%---------------------

dfs_repeticao_1([Node|_], [Node]) :- objetivo(Node).
dfs_repeticao_1([Node|F1], [Node|L]) :-
    vizinhos(Node, FilhosN),
    adicionar_fronteira_prof(FilhosN, F1, F2),
    dfs_repeticao_1(F2, L).

% Retorna todas as configurações percorridas (mas como não há tratamento de repeticao, fica em loop)
busca_prof_repeticao_1(Inicio, S) :-
    dfs_repeticao_1([Inicio], S).

%---------------------
% Segunda Abordagem
%---------------------

dfs_repeticao_2([[Node|Caminho]|_], [Node|Caminho]) :- 
    objetivo(Node).

dfs_repeticao_2([Caminho|F1], S) :-
    vizinhos_caminho(Caminho, FilhosN),
    adicionar_fronteira_prof(FilhosN, F1, F2),
    dfs_repeticao_2(F2, S).

% Retorna somente o caminho do inicio até o nó objetivo:
busca_prof_repeticao_2(Inicio, L) :-
    dfs_repeticao_2([[Inicio]], S),
    reverse(S, L).

%--------------
% letra f
%--------------

% Evitar estados repetidos

% Duas abordagens: 
% 1. Retornar todas as configurações percorridas (busca_profundidade_1)
% 2. Retornar o caminho do inicio ate o nó objetivo (busca_profundidade_2)

%---------------------
% Primeira Abordagem
%---------------------

dfs_1([Node|_], _, [Node]) :- objetivo(Node).
dfs_1([Node|F1], Visitados, [Node|R]) :-
    vizinhos(Node, FilhosN),
    dif(FilhosN, Visitados, FilhosUnicos),
    append(FilhosUnicos, Visitados, Visitados1),
    adicionar_fronteira_prof(FilhosUnicos, F1, F2),
    dfs_1(F2, Visitados1, R).

% Retorna todas as configurações percorridas na busca
busca_profundidade_1(Inicio, R) :-
    dfs_1([Inicio], [Inicio], R).

%---------------------
% Segunda Abordagem
%---------------------

dfs_2([[Node|Caminho]|_], _, [Node|Caminho]) :- objetivo(Node).
dfs_2([Caminho|F1], Gerados, S) :-
    vizinhos_caminho_sem_repeticao(Caminho, Gerados, FilhosN),
    flatten(FilhosN, FilhosFlat),
    append(FilhosFlat, Gerados, Gerados1),
    adicionar_fronteira_largura(FilhosN, F1, F2),
    dfs_2(F2, Gerados1, S).

% Retorna o caminho do inicio até o nó solução
busca_profundidade_2(Inicio, L) :-
    dfs_2([[Inicio]], [Inicio], S),
    reverse(S, L).
