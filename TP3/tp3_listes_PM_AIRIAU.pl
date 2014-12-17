/**
TP3 Listes Prolog

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/

/**
===================================================================================================
Question 1.1
===================================================================================================
*/

membre(A,[X|U]):- membre(A,U), \==(A,X).
membre(A,[A|_]).


compte(_,[],0).
compte(A,[A|X],N):- compte(A,X,M), N is M+1.
compte(A,[B|X],N):- \==(A,B),compte(A,X,N).


egal([],[]).
egal([A|U],[A|X]):- egal(U,X).
testRenverser([B|X],A,Y):-testRenverser(X,[B|A],Y).
testRenverser([],A,Y):-egal(A,Y).
renverser([A|X],Y):-testRenverser(X,[A],Y).


palind(X):- renverser(X,X).


nieme(1,[A|_],A).
nieme(N,[_|X],A):- \==(N,1), nieme(M,X,A), N is M+1. 


hors_de(_,[]).
hors_de(A,[B|X]):- \==(A,B), hors_de(A,X).


tous_diff([]).
tous_diff([A|X]):- tous_diff(X), hors_de(A,X).


conc3([],[],[],[]).
conc3([],[],[A|Z],[A|T]):- conc3([],[],Z,T).
conc3([],[A|Y],Z,[A|T]):- conc3([],Y,Z,T).
conc3([A|X],Y,Z,[A|T]):-conc3(X,Y,Z,T).


debute_par(_,[]).
debute_par([A|X],[A|Y]):-debute_par(X,Y).


sous_liste(X,Y):-debute_par(X,Y).
sous_liste([_|X],Y):-sous_liste(X,Y). 


elimfirst([],_).
elimfirst([A|X],Y):- tous_diff(Y), membre(A,Y), elimfirst(X,Y).
elimsecond(_,[]).
elimsecond(X,[B|Y]):- tous_diff(Y), membre(B,X), elimsecond(X,Y).
elim(X,Y):- elimfirst(X,Y), elimsecond(X,Y), tous_diff(Y).


remplir([],[]).
remplir([X|L1],[X|L2]):- remplir(L1,L2).
inserer(E,[X|L1],[E|L2]):- E<X, remplir([X|L1],L2).
inserer(E,[X|L1],[X|L2]):- inserer(E,L1,L2), X<E.
tri([],_).
tri([E|X],Y):- inserer(E,Y,Z), tri(X,Z).


/**
==============================================================================================
Question 2.1
==============================================================================================
*/

inclus([],_).
inclus([A|X],Y):- membre(A,Y), inclus(X,Y).


non_inclus([A|X],Y):- hors_de(A,Y) ; non_inclus(X,Y).


union_ens(X,Y,Z):- inclus(X,Z), inclus(Y,Z), union_ens2(X,Y,Z).

union_ens2([],[],[]).
union_ens2([],[_|Y],[_|Z]):- union_ens2([],Y,Z).
union_ens2([A|X],[B|Y],[C|Z]):- membre(A,[B|Y]), union_ens2(X,[B|Y],[C|Z]).
union_ens2([A|X],[B|Y],[_|Z]):- hors_de(A,[B|Y]), union_ens2(X,[B|Y],Z).
/**
==============================================================================================
Tests
==============================================================================================
*/

/********************************************************************
membre
*********************************************************************
[eclipse 34]: 
 ?- membre(9,[1,6,3,9,7]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 35]: ?- membre(9,[1,6,3,7]).

No (0.00s cpu)
[eclipse 106]: ?- membre(X,[1,5,6]).

X = 6
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = 5
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = 1
Yes (0.00s cpu, solution 3)

*/

/**********************************************************************
compte
***********************************************************************
[eclipse 52]: ?- compte(3,[1,3,5,7,3,9],3).

No (0.00s cpu)
[eclipse 53]: ?- compte(3,[1,3,5,7,3,9],2).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 54]: ?- compte(3,[1,5,7,9],0).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

[eclipse 109]: ?- compte(3,[1,5,3,6,8,1,3,5],X).

X = 2
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/



/************************************************************************
renverser
*************************************************************************
[eclipse 110]: ?- renverser([t,e,s,t,d],X).

X = [d, t, s, e, t]
Yes (0.00s cpu)

[eclipse 57]: ?- renverser([t,e,s,t],[t,s,e,t]).

Yes (0.00s cpu)
[eclipse 58]: ?- renverser([t,e,s,t],[t,s,q,t]).

No (0.00s cpu)
[eclipse 59]: ?- renverser([t,e,s,t,d],[t,s,q,t]).

No (0.00s cpu)

*/

/****************************************************************************
palind
*****************************************************************************
[eclipse 61]: ?- palind([8,6,1,3,2]).

No (0.00s cpu)
[eclipse 62]: ?- palind([8,6,1,6,8]).

Yes (0.00s cpu)
[eclipse 63]: ?- palind([8,6,1,1,6,8]).

Yes (0.00s cpu)

*/

/***********************************************************************
nieme
***********************************************************************
[eclipse 70]: ?- nieme(5,[4,5,3,1,2,7,8,6],2).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 71]: ?- nieme(5,[4,5,3,1,2,7,8,6],5).

No (0.00s cpu)
eclipse 108]: nieme(5,[1,5,3,6,4,8,7],A).

A = 4
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.01s cpu)

Cette fonction gére aussi le mode (-,+,+) :

[eclipse 112]: ?- nieme(X,[4,5,3,1,2,7,8,6,2],2).

X = 5
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = 9
Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)

Un tel algorithme existe donc.

*/

/*************************************************
hors_de
**************************************************
[eclipse 74]: ?- hors_de(9,[2,6,3,7,8,9,5]).

No (0.00s cpu)
[eclipse 75]: ?- hors_de(9,[2,6,3,7,8,5]).

Yes (0.00s cpu)

*/

/********************************************
tous_diff
*********************************************
[eclipse 85]: ?- tous_diff([1,2,3,4,5,6,7,8,9]).

Yes (0.00s cpu)
[eclipse 86]: ?- tous_diff([1,2,3,4]).

Yes (0.00s cpu)
[eclipse 87]: ?- tous_diff([1,2,3,4,4,6,7,8,9]).

No (0.00s cpu)

*/

/************************************************
conc3
*************************************************

[eclipse 113]: conc3([2,4,5],[7,4,9],[1,2],X).

X = [2, 4, 5, 7, 4, 9, 1, 2]
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

[eclipse 91]: ?- conc3([2,4,5],[7,4,9],[1,2],[2,4,5,7,4,9,1,2]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 92]: ?- conc3([2,4,5],[7,4,9],[1,2],[2,4,5,7,4,1,2]).

No (0.00s cpu)
[eclipse 93]: ?- conc3([2,4,5],[],[1,2],[2,4,5,1,2]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

On s'intèresse aussi au fait de savoir si l'algorithme peut résoudre les cas sous la forme (-,-,-,+) :

?- conc3(X,Y,Z,[2,4,5,1,2]).

X = []
Y = []
Z = [2, 4, 5, 1, 2]
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = []
Y = [2]
Z = [4, 5, 1, 2]
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = []
Y = [2, 4]
Z = [5, 1, 2]
Yes (0.00s cpu, solution 3, maybe more) ? ;

X = []
Y = [2, 4, 5]
Z = [1, 2]
Yes (0.00s cpu, solution 4, maybe more) ? ;

X = []
Y = [2, 4, 5, 1]
Z = [2]
Yes (0.00s cpu, solution 5, maybe more) ? ;

X = []
Y = [2, 4, 5, 1, 2]
Z = []
Yes (0.00s cpu, solution 6, maybe more) ? ;

X = [2]
Y = []
Z = [4, 5, 1, 2]
Yes (0.00s cpu, solution 7, maybe more) ? ;

X = [2]
Y = [4]
Z = [5, 1, 2]
Yes (0.00s cpu, solution 8, maybe more) ? ;

X = [2]
Y = [4, 5]
Z = [1, 2]
Yes (0.00s cpu, solution 9, maybe more) ? ;

X = [2]
Y = [4, 5, 1]
Z = [2]
Yes (0.00s cpu, solution 10, maybe more) ? ;

X = [2]
Y = [4, 5, 1, 2]
Z = []
Yes (0.00s cpu, solution 11, maybe more) ? ;

X = [2, 4]
Y = []
Z = [5, 1, 2]
Yes (0.00s cpu, solution 12, maybe more) ? ;

X = [2, 4]
Y = [5]
Z = [1, 2]
Yes (0.00s cpu, solution 13, maybe more) ? ;

X = [2, 4]
Y = [5, 1]
Z = [2]
Yes (0.00s cpu, solution 14, maybe more) ? ;

X = [2, 4]
Y = [5, 1, 2]
Z = []
Yes (0.00s cpu, solution 15, maybe more) ? ;

X = [2, 4, 5]
Y = []
Z = [1, 2]
Yes (0.00s cpu, solution 16, maybe more) ? ;

X = [2, 4, 5]
Y = [1]
Z = [2]
Yes (0.00s cpu, solution 17, maybe more) ? ;

X = [2, 4, 5]
Y = [1, 2]
Z = []
Yes (0.00s cpu, solution 18, maybe more) ? ;

X = [2, 4, 5, 1]
Y = []
Z = [2]
Yes (0.00s cpu, solution 19, maybe more) ? ;

X = [2, 4, 5, 1]
Y = [2]
Z = []
Yes (0.00s cpu, solution 20, maybe more) ? ;

X = [2, 4, 5, 1, 2]
Y = []
Z = []
Yes (0.00s cpu, solution 21)

*/

/****************************************
debute_par
*****************************************
[eclipse 121]: ?- debute_par([2,1,4,5,6,7],[2,1,4]).

Yes (0.00s cpu)

[eclipse 123]: ?- debute_par([2,1,5,6,7],[2,1,4]).

No (0.00s cpu)

[eclipse 124]: ?- debute_par([2,1,5,6,7],X).

X = []
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = [2]
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = [2, 1]
Yes (0.00s cpu, solution 3, maybe more) ? ;

X = [2, 1, 5]
Yes (0.00s cpu, solution 4, maybe more) ? ;

X = [2, 1, 5, 6]
Yes (0.00s cpu, solution 5, maybe more) ? ;

X = [2, 1, 5, 6, 7]
Yes (0.00s cpu, solution 6)

L'algorithme en est donc aussi capable.

*/

/****************************************
sous_liste
*****************************************
[eclipse 104]: ?- sous_liste([9,8,1,4,5,8,6], [1,3,4]).

No (0.00s cpu)
[eclipse 105]: ?- sous_liste([9,8,1,3,4,5,8,6], [1,3,4]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

[eclipse 129]: ?- sous_liste([9,8,1,3], X).

X = []
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = [9]
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = [9, 8]
Yes (0.00s cpu, solution 3, maybe more) ? ;

X = [9, 8, 1]
Yes (0.00s cpu, solution 4, maybe more) ? ;

X = [9, 8, 1, 3]
Yes (0.00s cpu, solution 5, maybe more) ? ;

X = []
Yes (0.00s cpu, solution 6, maybe more) ? ;

X = [8]
Yes (0.00s cpu, solution 7, maybe more) ? ;

X = [8, 1]
Yes (0.00s cpu, solution 8, maybe more) ? ;

X = [8, 1, 3]
Yes (0.00s cpu, solution 9, maybe more) ? ;

X = []
Yes (0.00s cpu, solution 10, maybe more) ? ;

X = [1]
Yes (0.00s cpu, solution 11, maybe more) ? ;

X = [1, 3]
Yes (0.00s cpu, solution 12, maybe more) ? ;

X = []
Yes (0.00s cpu, solution 13, maybe more) ? ;

X = [3]
Yes (0.00s cpu, solution 14, maybe more) ? ;

X = []
Yes (0.00s cpu, solution 15)

*/

/***************************************
elim
****************************************
[eclipse 143]: ?- elim([1,2,3,1,4,3,2],Y).

Y = [4, 3, 2, 1]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Y = [3, 4, 2, 1]
Yes (0.00s cpu, solution 2, maybe more) ? ;

Y = [4, 2, 3, 1]
Yes (0.00s cpu, solution 3, maybe more) ? ;

Y = [3, 2, 4, 1]
Yes (0.00s cpu, solution 4, maybe more) ? ;

Y = [2, 4, 3, 1]
Yes (0.00s cpu, solution 5, maybe more) ? ;

Y = [2, 3, 4, 1]
Yes (0.00s cpu, solution 6, maybe more) ? ;

Y = [4, 3, 1, 2]
Yes (0.00s cpu, solution 7, maybe more) ? ;

Y = [3, 4, 1, 2]
Yes (0.00s cpu, solution 8, maybe more) ? ;

Y = [4, 2, 1, 3]
Yes (0.00s cpu, solution 9, maybe more) ? ;

Y = [3, 2, 1, 4]
Yes (0.00s cpu, solution 10, maybe more) ? ;

Y = [2, 4, 1, 3]
Yes (0.00s cpu, solution 11, maybe more) ? ;

Y = [2, 3, 1, 4]
Yes (0.00s cpu, solution 12, maybe more) ? ;

Y = [4, 1, 3, 2]
Yes (0.00s cpu, solution 13, maybe more) ? ;

Y = [3, 1, 4, 2]
Yes (0.00s cpu, solution 14, maybe more) ? ;

Y = [4, 1, 2, 3]
Yes (0.01s cpu, solution 15, maybe more) ? ;

Y = [3, 1, 2, 4]
Yes (0.01s cpu, solution 16, maybe more) ? ;

Y = [2, 1, 4, 3]
Yes (0.01s cpu, solution 17, maybe more) ? ;

Y = [2, 1, 3, 4]
Yes (0.01s cpu, solution 18, maybe more) ? ;

Y = [1, 4, 3, 2]
Yes (0.01s cpu, solution 19, maybe more) ? ;

Y = [1, 3, 4, 2]
Yes (0.01s cpu, solution 20, maybe more) ? ;

Y = [1, 4, 2, 3]
Yes (0.01s cpu, solution 21, maybe more) ? ;

Y = [1, 3, 2, 4]
Yes (0.01s cpu, solution 22, maybe more) ? ;

Y = [1, 2, 4, 3]
Yes (0.01s cpu, solution 23, maybe more) ? ;

Y = [1, 2, 3, 4]

*/

/******************************************
inserer
******************************************
[eclipse 8]: ?- inserer(5,[1,2,3,4,6,7,8],X).

X = [1, 2, 3, 4, 5, 7, 8]
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

/*******************************************
inclus
********************************************
[eclipse 4]: ?- inclus([1,4,3],[2,4,3,1]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 5]: ?- inclus([1,4,3],[2,3,1]).

No (0.00s cpu)
*/

/*********************************************
non_inclus
***********************************************
[eclipse 14]: ?- non_inclus([1,4,3,7],[2,3,1,4]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 15]: ?- non_inclus([1,4,3],[2,3,1,4]).

No (0.00s cpu)
*/

/********************************************
union_ens
*********************************************
[eclipse 25]: ?- union_ens([1,2,4],[3,5],[1,2,3,4,5]).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

