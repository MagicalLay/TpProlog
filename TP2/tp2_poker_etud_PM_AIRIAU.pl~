% 18 Septembre 2014 / Pierre-Marie Airiau / G2.1
% TP2 TERMES CONSTRUITS - A compléter et faire tourner sous Eclipse Prolog
% ==============================================================================
% ============================================================================== 
%	FAITS
% ============================================================================== 
/*
	hauteur(Valeur)
*/
hauteur(deux).
hauteur(trois).
hauteur(quatre).
hauteur(cinq).
hauteur(six).
hauteur(sept).
hauteur(huit).
hauteur(neuf).
hauteur(dix).
hauteur(valet).
hauteur(dame).
hauteur(roi).
hauteur(as).

/*
	couleur(Valeur)
*/
couleur(trefle).
couleur(carreau).
couleur(coeur).
couleur(pique).

/*
	succ_hauteur(H1, H2)
*/
succ_hauteur(deux, trois).
succ_hauteur(trois, quatre).
succ_hauteur(quatre, cinq).
succ_hauteur(cinq, six).
succ_hauteur(six, sept).
succ_hauteur(sept, huit).
succ_hauteur(huit, neuf).
succ_hauteur(neuf, dix).
succ_hauteur(dix, valet).
succ_hauteur(valet, dame).
succ_hauteur(dame, roi).
succ_hauteur(roi, as).

/*
	succ_couleur(C1, C2)
*/
succ_couleur(trefle, carreau).
succ_couleur(carreau, coeur).
succ_couleur(coeur, pique).

/*
  carte_test
  cartes pour tester le prédicat EST_CARTE
*/

carte_test(c1,carte(sept,trefle)).
carte_test(c2,carte(neuf,carreau)).
carte_test(ce1,carte(7,trefle)).
carte_test(ce2,carte(sept,t)).

/* 
	main_test(NumeroTest, Main) 
	mains pour tester le prédicat EST_MAIN 
*/

main_test(main_triee_une_paire, main(carte(sept,trefle),est_carte(carte(valet,coeur)), carte(dame,carreau), carte(dame,pique), carte(roi,pique))).
% attention ici m2 représente un ensemble de mains	 
main_test(m2, main(carte(valet,_), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(as,pique))).
main_test(main_triee_deux_paires, main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(roi,pique))).
main_test(main_triee_brelan, main(carte(sept,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(roi,pique))).	
main_test(main_triee_suite,main(carte(sept,trefle),carte(huit,pique),carte(neuf,coeur),carte(dix,carreau),carte(valet,carreau))).
main_test(main_triee_full,main(carte(deux,coeur),carte(deux,pique),carte(quatre,trefle),carte(quatre,coeur),carte(quatre,pique))).

main_test(merreur1, main(carte(sep,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefle), carte(as,pique))).
main_test(merreur2, main(carte(sep,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefleinf))).

% ============================================================================= 
%        QUESTION 1 : est_carte(carte(Hauteur,Couleur))
% ==============================================================================

est_carte(carte(X,Y)):- hauteur(X), couleur(Y).

% ============================================================================= 
%	QUESTION 2 : est_main(main(C1,C2,C3,C4,C5))
% ============================================================================= 

est_main(main(C1,C2,C3,C4,C5)):- C1\==C2, C1\==C3, C1\==C4, C1\==C5,C2\==C3, C2\==C4, C2\==C5,C3\==C4, C3\==C5,C4\==C5.

% ==============================================================================
%       QUESTION 3 : inf_carte(C1,C2) première version
% ============================================================================= 

inf_hauteur(X,Y):- succ_hauteur(X,Y), X\==Y.
inf_hauteur(X,Y):- succ_hauteur(X,Z),inf_hauteur(Z,Y), X\==Z, Z\==Y.

inf_couleur(X,Y):- succ_couleur(X,Y), X\==Y.
inf_couleur(X,Y):- succ_couleur(X,Z),inf_couleur(Z,Y), X\==Z, Z\==Y, X\==Y.

inf_carte(carte(X,Y),carte(A,B)):- inf_hauteur(X,A), X\==Y, X\==A, X\==B, A\==Y, A\==B.
inf_carte(carte(X,Y),carte(X,Z)):- inf_couleur(Y,Z), X\==Y, X\==Z, Y\==Z.


% ============================================================================= 
%       QUESTION 3 : inf_carte_b(C1,C2) deuxième version
% ==============================================================================



% ==============================================================================
%       QUESTION 4 : est_main_triee(main(C1,C2,C3,C4,C5))
% ==============================================================================

est_main_triee(main(C1,C2,C3,C4,C5)):- inf_carte(C1,C2), inf_carte(C2,C3), inf_carte(C3,C4), inf_carte(C4,C5), C1\==C2, C1\==C3, C1\==C4, C1\==C5, C2\==C3, C2\==C4, C2\==C5, C3\==C4, C3\==C5, C4\==C5.


% ==============================================================================
%       QUESTION 5 : une_paire(main(C1,C2,C3,C4,C5))
% ==============================================================================

une_paire(main(carte(A,_),carte(B,_),carte(C,_),carte(D,_),carte(E,_))):- A==B;B==C;C==D;D==E.

% ==============================================================================
%       QUESTION 6 : deux_paires(main(C1,C2,C3,C4,C5))
% ==============================================================================

deux_paires(main(carte(A,_),carte(B,_),carte(C,_),carte(D,_),carte(E,_))):- A==B, C==D;A==B, D==E; B==C,D==E.

% ============================================================================= 
%       QUESTION 7 : brelan(main(C1,C2,C3,C4,C5))
% ============================================================================= 

brelan(main(carte(A,_),carte(B,_),carte(C,_),carte(D,_),carte(E,_))):- A==B,A==C; B==C,B==D; C==D,C==E.

% ============================================================================= 
%       QUESTION 8 : suite(main(C1,C2,C3,C4,C5))
% ==============================================================================

suite(main(carte(A,_),carte(B,_),carte(C,_),carte(D,_),carte(E,_))):- succ_hauteur(A,B), succ_hauteur(B,C), succ_hauteur(C,D), succ_hauteur(D,E).

% ============================================================================= 
%       QUESTION 9 : full(main(C1,C2,C3,C4,C5))
% ============================================================================= 

full(main(carte(A,_),carte(B,_),carte(C,_),carte(D,_),carte(E,_))):- A==B,A==C,D==E ; A==B,C==D,C==E.

% ==============================================================================

/* TESTS QUESTION 1 : carte_test

[eclipse 17]: ?- est_carte(carte(dix, carreau)).

Yes (0.00s cpu)
[eclipse 18]: ?- est_carte(carte(dix, fleur)).

No (0.00s cpu)
[eclipse 19]: ?- est_carte(carte(9, fleur)).

No (0.00s cpu)

*/

% ============================================================================= 

/*  TESTS QUESTION 2 : est_main

[eclipse 8]: ?- est_main(main(carte(dix,coeur),carte(neuf,trefle),carte(deux,pique),carte(huit,carreau), carte(huit,trefle))).

Yes (0.00s cpu)
[eclipse 9]: ?- est_main(main(carte(dix,coeur),carte(neuf,trefle),carte(deux,pique),carte(huit,carreau), carte(huit,carreau))).

No (0.00s cpu)

*/

% ============================================================================= 

/* TESTS QUESTION 3 premiere version

[eclipse 33]: ?- inf_hauteur(X,dix).

X = neuf
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = deux
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = trois
Yes (0.00s cpu, solution 3, maybe more) ? ;

X = quatre
Yes (0.00s cpu, solution 4, maybe more) ? ;

X = cinq
Yes (0.00s cpu, solution 5, maybe more) ? ;

X = six
Yes (0.00s cpu, solution 6, maybe more) ? ;

X = sept
Yes (0.00s cpu, solution 7, maybe more) ? ;

X = huit
Yes (0.00s cpu, solution 8, maybe more) ? ;

No (0.00s cpu)
[eclipse 34]: ?- inf_couleur(X,coeur).

X = carreau
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = trefle
Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)
[eclipse 35]: ?- inf_carte(carte(neuf,trefle),carte(as,coeur)).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 36]: ?- inf_carte(carte(neuf,trefle),carte(sept,coeur)).

No (0.00s cpu)

*/

% ==============================================================================

/* TESTS QUESTION 3 deuxieme version

*/

% ==============================================================================

/* TESTS QUESTION 4

[eclipse 3]: ?- est_main_triee(main(carte(deux,carreau),carte(quatre,trefle),carte(quatre,pique),carte(six,coeur),carte(as,trefle))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 4]: ?- est_main_triee(main(carte(deux,carreau),carte(quatre,trefle),carte(quatre,pique),carte(six,coeur),carte(cinq,trefle))).

No (0.00s cpu)

*/

% ============================================================================= 

/* TESTS QUESTION 5

[eclipse 14]: ?- une_paire(main(carte(deux,coeur),carte(cinq,trefle),carte(cinq,pique),carte(huit,carreau), carte(dix,carreau))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 15]: ?- une_paire(main(carte(deux,coeur),carte(cinq,trefle),carte(cinq,pique),carte(cinq,carreau), carte(dix,carreau))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)
[eclipse 16]: ?- une_paire(main(carte(deux,coeur),carte(cinq,trefle),carte(sept,pique),carte(neuf,carreau), carte(dix,carreau))).

No (0.00s cpu)

*/

% ==============================================================================

/* TESTS QUESTION 6

[eclipse 21]: ?- deux_paires(main(carte(deux,coeur),carte(cinq,trefle),carte(sept,pique),carte(neuf,carreau), carte(dix,carreau))).

No (0.00s cpu)
[eclipse 22]: ?- deux_paires(main(carte(deux,coeur),carte(deux,trefle),carte(sept,pique),carte(neuf,carreau), carte(neuf,carreau))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 23]: ?- deux_paires(main(carte(deux,coeur),carte(trois,trefle),carte(trois,pique),carte(neuf,carreau), carte(neuf,carreau))).

Yes (0.00s cpu)

*/

% ==============================================================================


/* TESTS QUESTION 7

[eclipse 26]: ?- brelan(main(carte(deux,coeur),carte(trois,trefle),carte(trois,pique),carte(neuf,carreau), carte(neuf,carreau))).

No (0.00s cpu)
[eclipse 27]: ?- brelan(main(carte(deux,coeur),carte(trois,trefle),carte(trois,pique),carte(trois,carreau), carte(neuf,carreau))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

*/

% ==============================================================================

/* TESTS QUESTION 8

[eclipse 29]: ?- suite(main(carte(deux,coeur),carte(trois,trefle),carte(trois,pique),carte(trois,carreau), carte(neuf,carreau))).

No (0.00s cpu)
[eclipse 30]: ?- suite(main(carte(deux,coeur),carte(trois,trefle),carte(quatre,pique),carte(cinq,carreau), carte(six,carreau))).

Yes (0.00s cpu)
[eclipse 31]: ?- suite(main(carte(deux,coeur),carte(trois,trefle),carte(quatre,pique),carte(cinq,carreau), carte(sept,carreau))).

No (0.00s cpu)

*/

% ============================================================================= 

/* TESTS QUESTION 9

[eclipse 34]: ?- full(main(carte(deux,coeur),carte(trois,trefle),carte(quatre,pique),carte(cinq,carreau), carte(sept,carreau))).

No (0.00s cpu)
[eclipse 35]: ?- full(main(carte(deux,coeur),carte(deux,trefle),carte(quatre,pique),carte(quatre,carreau), carte(quatre,carreau))).

Yes (0.00s cpu)
[eclipse 36]: ?- full(main(carte(deux,coeur),carte(deux,trefle),carte(deux,pique),carte(quatre,carreau), carte(quatre,carreau))).

Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

*/
