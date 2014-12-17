/**
TP 4 Arbres binaires - Prolog

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/


/*
-------------------------------------------------------------------------------
 Définition des prédicats
-------------------------------------------------------------------------------
*/

arbre_binaire(arb_bin(X,vide,vide)):- integer(X).
arbre_binaire(arb_bin(X,Y,Z)):- integer(X),arbre_binaire(Y),arbre_binaire(Z).
arbre_binaire(arb_bin(X,vide,Z)):- integer(X),arbre_binaire(Z).
arbre_binaire(arb_bin(X,Y,vide)):- integer(X),arbre_binaire(Y).


dans_arbre_binaire(E,arb_bin(E,_,_)).
dans_arbre_binaire(E,arb_bin(_,Y,Z)):-dans_arbre_binaire(E,Y);dans_arbre_binaire(E,Z).


sous_arbre_binaire(S,S).
sous_arbre_binaire(S,arb_bin(_,S,_)).
sous_arbre_binaire(S,arb_bin(_,_,S)).
sous_arbre_binaire(S,arb_bin(_,X,Y)):-sous_arbre_binaire(S,X);sous_arbre_binaire(S,Y).


remplacer(SA1,_,B,B):- not(sous_arbre_binaire(SA1,B)).
remplacer(SA1,SA2,SA1,SA2).
remplacer(SA1,SA2,arb_bin(X,Y,Z),arb_bin(X,Y2,Z2)):- remplacer(SA1,SA2,Y,Y2),remplacer(SA1,SA2,Z,Z2).


isomorphes(arb_bin(X,Y,Z),arb_bin(X,Z,Y)).
isomorphes(arb_bin(X,Y,Z),arb_bin(X,Y2,Z2)):- isomorphes(Y,Y2),isomorphes(Z,Z2).


infixe(arb_bin(X,vide,vide),X).
infixe(arb_bin(X,vide,Z),[X|B]):- infixe(Z,B).
infixe(arb_bin(X,Y,vide),[A|X]):- infixe(Y,A).
infixe(arb_bin(X,Y,Z),[A|B]):- infixe(Y,A),infixe(arb_bin(X,vide,Z),B).


insertion_arbre_ordonne(X,arb_bin(Y,vide,vide),arb_bin(Y,arb_bin(X,vide,vide),vide)):- X<Y.
insertion_arbre_ordonne(X,arb_bin(Y,vide,vide),arb_bin(Y,vide,arb_bin(X,vide,vide))):- X>Y.
insertion_arbre_ordonne(X,arb_bin(Y,A,vide),arb_bin(Y,A,arb_bin(X,vide,vide))):- X>Y.
insertion_arbre_ordonne(X,arb_bin(Y,A,vide),arb_bin(Y,B,vide)):- X<Y, insertion_arbre_ordonne(X,A,B).
insertion_arbre_ordonne(X,arb_bin(Y,vide,A),arb_bin(Y,arb_bin(X,vide,vide),A)):- X<Y.
insertion_arbre_ordonne(X,arb_bin(Y,vide,A),arb_bin(Y,vide,B)):- X>Y, insertion_arbre_ordonne(X,A,B).
insertion_arbre_ordonne(X,arb_bin(Y,A,B),arb_bin(Y,Z,B)):- X<Y, insertion_arbre_ordonne(X,A,Z).
insertion_arbre_ordonne(X,arb_bin(Y,A,B),arb_bin(Y,A,Z)):- X>Y, insertion_arbre_ordonne(X,B,Z).

/*suivant ne marche pas : pas compris comment fonctionnent les variables non instanciés dans les +
*/
insertion_arbre_ordonne1(X,arb_bin(Y,Z,vide)):- free(Z), X<Y, Z==arb_bin(X,vide,vide).
insertion_arbre_ordonne1(X,arb_bin(Y,vide,Z)):- free(Z), X>Y, Z==arb_bin(X,vide,vide).
insertion_arbre_ordonne1(X,arb_bin(Y,_,Z)):- free(Z), X>Y, Z==arb_bin(X,vide,vide).
insertion_arbre_ordonne1(X,arb_bin(Y,B,vide)):- X<Y, insertion_arbre_ordonne(X,B).
insertion_arbre_ordonne1(X,arb_bin(Y,Z,_)):- free(Z), X<Y, arb_bin(X,vide,vide).
insertion_arbre_ordonne1(X,arb_bin(Y,vide,B)):- X>Y, insertion_arbre_ordonne(X,B).
insertion_arbre_ordonne1(X,arb_bin(Y,Z,_)):- X<Y, insertion_arbre_ordonne(X,Z).
insertion_arbre_ordonne1(X,arb_bin(Y,_,Z)):- X>Y, insertion_arbre_ordonne(X,Z).

/*
-------------------------------------------------------------------------------
 Tests
-------------------------------------------------------------------------------
*/

% Quelques arbres à copier coller pour vous faire gagner du temps, mais
% n'hésitez pas à en définir d'autres

/*
arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, 7, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))

arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))

arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))

arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))

arb_bin(8, arb_bin(4, arb_bin(2, _, _), arb_bin(6, _, _)), arb_bin(12, arb_bin(10, _, _), _))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,vide,arb_bin(10,vide,vide)))

arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(6,vide,arb_bin(10,vide,vide)))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(10,vide,vide)))

*/

/*********************************************************
arbre_binaire
**********************************************************
[eclipse 29]: ?- arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 30]: ?- arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, a)))).

No (0.00s cpu)
[eclipse 31]: ?- arbre_binaire(arb_bin(1, vide,vide)).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

/********************************************************
dans_arbre_binaire
*********************************************************
[eclipse 35]: ?- dans_arbre_binaire(5,arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 36]: ?- dans_arbre_binaire(7,arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))).

No (0.00s cpu)
*/

/******************************************************
sous_arbre_binaire
*******************************************************
[eclipse 38]: ?- sous_arbre_binaire(arb_bin(6, vide, vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))).

Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 39]: ?- sous_arbre_binaire(arb_bin(6, 7, vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))).

No (0.00s cpu)
*/

/****************************************************
remplacer
*****************************************************
[eclipse 49]: ?- remplacer(arb_bin(8,vide,vide),arb_bin(5,vide,vide),arb_bin(6,vide,arb_bin(8,vide,vide)),Y).

No (0.00s cpu)
[eclipse 50]: ?- remplacer(arb_bin(8,vide,vide),arb_bin(5,vide,vide),arb_bin(6,vide,arb_bin(4,vide,vide)),Y).

Y = arb_bin(6, vide, arb_bin(4, vide, vide))
Yes (0.00s cpu)
[eclipse 58]: ?- remplacer(arb_bin(6,vide,vide),arb_bin(10,vide,vide),arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(6, vide, vide)),Y).

Y = arb_bin(3, arb_bin(5, arb_bin(10, vide, vide), arb_bin(7, vide, vide)), arb_bin(10, vide, vide))
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

/***************************************************
isomorphes
****************************************************
[eclipse 61]: ?- isomorphes(arb_bin(3,arb_bin(4,vide,vide),arb_bin(5,arb_bin(6,vide,vide),arb_bin(7,vide,vide))),arb_bin(3,arb_bin(5,arb_bin(6,vide,vide),arb_bin(7,vide,vide)),arb_bin(4,vide,vide))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 62]: ?- isomorphes(arb_bin(3,arb_bin(4,vide,vide),arb_bin(5,arb_bin(6,vide,vide),arb_bin(7,vide,vide))),arb_bin(3,arb_bin(6,vide,vide),arb_bin(5,arb_bin(4,vide,vide),arb_bin(7,vide,vide)))).

No (0.00s cpu)
*/

/**************************************************
infixe
***************************************************
[eclipse 67]: ?- infixe(arb_bin(1,arb_bin(2,arb_bin(6,vide,vide),vide),arb_bin(3,arb_bin(4,vide,vide),arb_bin(5,vide,vide))),Y).

Y = [[6|2], 1, 4, 3|5]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Y = [[6|2], 1, 4, 3|5]
Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)
*/

/**************************************************
insertion_arbre_ordonne
***************************************************
[eclipse 73]: ?- insertion_arbre_ordonne(14,arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)),B2).

                                       B2 = arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), arb_bin(14, vide, vide)))
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 74]: ?- insertion_arbre_ordonne(5,arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)),B2).

                                      B2 = arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, arb_bin(5, vide, vide), vide)), arb_bin(12, arb_bin(10, vide, vide), vide))
Yes (0.00s cpu, solution 1, maybe more) ? ;

*/

/**************************************************
insertion_arbre_ordonne1
***************************************************
[eclipse 79]: ?- insertion_arbre_ordonne1(5,arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))).
calling an undefined procedure insertion_arbre_ordonne(5, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide))) in module eclipse
Abort
*/
