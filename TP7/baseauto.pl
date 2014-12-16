/**
TP 7 Base de Données Déductives (BDD) - Prolog

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/


/*
===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================
*/
% ============================================================================= 
% SECTION 1 : Base de données
% ============================================================================= 

assemblage(voiture, porte, 4).
assemblage(voiture, roue, 4).
assemblage(voiture, moteur, 1).
assemblage(roue, jante, 1).
assemblage(porte, tole, 1).
assemblage(porte, vitre, 1).
assemblage(roue, pneu, 1).
assemblage(moteur, piston, 4).
assemblage(moteur, soupape, 16).

           
piece(p1, tole, lyon).
piece(p2, jante, lyon).
piece(p3, jante, marseille).
piece(p4, pneu, clermontFerrand).
piece(p5, piston, toulouse).
piece(p6, soupape, lille).
piece(p7, vitre, nancy).
piece(p8, tole, marseille).
piece(p9, vitre, marseille).

                  
demandeFournisseur(dupont, lyon).
demandeFournisseur(michel, clermontFerrand).
demandeFournisseur(durand, lille).
demandeFournisseur(dupond, lille).
demandeFournisseur(martin, rennes).
demandeFournisseur(smith, paris).
demandeFournisseur(brown, marseille).
          
          
fournisseurReference(f1, dupont, lyon).
fournisseurReference(f2, durand, lille).
fournisseurReference(f3, martin, rennes).
fournisseurReference(f4, michel, clermontFerrand).
fournisseurReference(f5, smith, paris).
fournisseurReference(f6, brown, marseille).

                  
livraison(f1, p1, 300).
livraison(f2, p2, 200).
livraison(f3, p3, 200).
livraison(f4, p4, 400).
livraison(f6, p5, 500).
livraison(f6, p6, 1000).
livraison(f6, p7, 300).
livraison(f1, p2, 300).
livraison(f4, p2, 300).
livraison(f4, p1, 300).


% ============================================================================= 
% SECTION 2 : Opération relationnelles
% ============================================================================= 

select(Y, [X,Z]) :- piece(X, Z, Y).

proj([X,Y]) :- piece(_,X,Y).

union([X,Y]) :- demandeFournisseur(X,Y).
union([X,Y]) :- fournisseurReference(_, X, Y), 
				not(demandeFournisseur(X, Y)).

intersection([X, Y]) :- fournisseurReference(_, X, Y), 
						demandeFournisseur(X, Y).

diffEnsemble([X, Y]) :- demandeFournisseur(X, Y), 
						not(fournisseurReference(_, X, Y)).

prodCart([F, N, V, F1, P, Q]) :- fournisseurReference(F, N, V), 
								 livraison(F1, P, Q).

jointure([F, N, V, P, Q]) :- fournisseurReference(F, N, V), 
							 livraison(F, P, Q).
jointure350([F, N, V, P, Q]) :- jointure([F, N, V, P, Q]), 
				Q>350.

div([F, N, V]) :- fournisseurReference(F, N, V), 
				  livraison(F, P, _), 
				  piece(P, _, lyon).

sum([A],A).
sum([A|B],Q) :- sum(B,C), Q is C+A.
nbPiece([F,Qt]) :- fournisseurReference(F,_,_), 
				   findall(Q, livraison(F,_,Q), R), 
				   sum(R,Qt).

% ============================================================================= 
% SECTION 3 : Au delà de l’algèbre relationnelle
% ============================================================================= 

%% Question 3.1

ensemble_comp(Composant,Res) :- findall(Piece,assemblage(Composant,Piece,_),EnsembleComp),
								ensemble_comp2(EnsembleComp,ResFils),
								append(EnsembleComp,ResFils,ResTemp),
								ensemble_comp2(ResFils,ResTemp2),
								append(ResTemp,ResTemp2,Res).
ensemble_comp2([],[]).
ensemble_comp2([Tete|Reste], EnsembleComp) :- findall(Piece,assemblage(Tete,Piece,_),Ensemble1),
											  ensemble_comp2(Reste,Ensemble2),
											  append(Ensemble1,Ensemble2,EnsembleComp).

											  
											  
%% Question 3.2

nombre_piece(Composant,NombreRes) :- findall((Piece,Qte),assemblage(Composant,Piece,Qte),EnsembleComp),
									 nombre_piece_liste(EnsembleComp,Res),
									 somme_liste(Res,NombreRes).
nombre_piece_liste([],[]).
nombre_piece_liste([(P,Qt)|Reste],Res) :- findall((Piece,Qte),assemblage(P,Piece,Qte),[(A,B)|C]),
										  multiplier_liste([(A,B)|C],Qt,EnsembleCompF),
										  nombre_piece_liste(Reste,Res1),
										  nombre_piece_liste(EnsembleCompF,Res2),
										  append(Res1,Res2,Res).
nombre_piece_liste([(P,Qt)|Reste],Res) :- findall((Piece,Qte),assemblage(P,Piece,Qte),[]),
										  nombre_piece_liste(Reste,Res2),
										  append([(P,Qt)],Res2,Res).
multiplier_liste([],_,[]).
multiplier_liste([(P,Qt)|Reste],Qte,[(P,Qtres)|ListeRes]) :- Qtres is *(Qt,Qte),
															 multiplier_liste(Reste,Qte,ListeRes).	
somme_liste([],0).
somme_liste([(_,Qt)|Reste],Res) :- somme_liste(Reste,Res2),
								   Res is +(Res2,Qt).



%% Question 3.3
   
jointure_piece(NomPiece,Qte):- piece(NumPiece,NomPiece,_),
							   livraison(_,NumPiece,Qte).
nb_piece_dispo(NomPiece,Nb) :- findall((NomPiece,Qte),jointure_piece(NomPiece,Qte),Res),
							   somme_liste(Res,Nb).
nb_compo_pour_une_voiture(_,[],0).
nb_compo_pour_une_voiture(Piece,[(Piece,Qte)|_],Qte).
nb_compo_pour_une_voiture(PieceA,[(PieceB,_)|Reste],Qte) :- \==(PieceA,PieceB),
															nb_compo_pour_une_voiture(PieceA,Reste,Qte). 
nb_voiture_par_compo(Piece,Res) :- nb_piece_dispo(Piece,Nb_piece_dispo),
								   nombre_piece_liste([(voiture,1)],ListeCompo),
								   nb_compo_pour_une_voiture(Piece,ListeCompo,Nb_piece_necessaire),
								   Res is //(Nb_piece_dispo,Nb_piece_necessaire).
nb_voiture_liste([],0).
nb_voiture_liste([A],Res) :- nb_voiture_par_compo(A,Res),						 !.
nb_voiture_liste([A|B],Res) :- nb_voiture_par_compo(A,Res1),
							   nb_voiture_liste(B,Res2),
							   Res is min(Res1,Res2).
nb_voiture(Res) :- findall(Piece,piece(_, Piece,_),ListePiece), %Il faudrait éliminer les doublons
				   nb_voiture_liste(ListePiece,Res).

/*
===============================================================================
===============================================================================
 Tests
===============================================================================
select(lyon, X).
X = [p1, tole]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [p2, jante]
Yes (0.00s cpu, solution 2)

proj(X).
X = [tole, lyon]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [jante, lyon]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [jante, marseille]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [pneu, clermontFerrand]
Yes (0.00s cpu, solution 4, maybe more) ? ;
X = [piston, toulouse]
Yes (0.00s cpu, solution 5, maybe more) ? ;
X = [soupape, lille]
Yes (0.00s cpu, solution 6, maybe more) ? ;
X = [vitre, nancy]
Yes (0.00s cpu, solution 7, maybe more) ? ;
X = [tole, marseille]
Yes (0.00s cpu, solution 8, maybe more) ? ;
X = [vitre, marseille]
Yes (0.00s cpu, solution 9)

union(X).
X = [dupont, lyon]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [michel, clermontFerrand]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [durand, lille]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [dupond, lille]
Yes (0.00s cpu, solution 4, maybe more) ? ;
X = [martin, rennes]
Yes (0.00s cpu, solution 5, maybe more) ? ;
X = [smith, paris]
Yes (0.00s cpu, solution 6, maybe more) ? ;
X = [brown, marseille]
Yes (0.00s cpu, solution 7, maybe more) ? ;
No (0.00s cpu)

intersection(X).
X = [dupont, lyon]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [durand, lille]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [martin, rennes]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [michel, clermontFerrand]
Yes (0.00s cpu, solution 4, maybe more) ? ;
X = [smith, paris]
Yes (0.00s cpu, solution 5, maybe more) ? ;
X = [brown, marseille]
Yes (0.00s cpu, solution 6)

diffEnsemble(X).
X = [dupond, lille]
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

prodCart(X).
X = [f1, dupont, lyon, f1, p1, 300]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [f1, dupont, lyon, f2, p2, 200]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [f1, dupont, lyon, f3, p3, 200]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [f1, dupont, lyon, f4, p4, 400]
Yes (0.01s cpu, solution 4, maybe more) ? ;
X = [f1, dupont, lyon, f6, p5, 500]
Yes (0.01s cpu, solution 5, maybe more) ? ;
X = [f1, dupont, lyon, f6, p6, 1000]
Yes (0.01s cpu, solution 6, maybe more) ? ;
X = [f1, dupont, lyon, f6, p7, 300]
Yes (0.01s cpu, solution 7, maybe more) ? ;
X = [f1, dupont, lyon, f1, p2, 300]
Yes (0.01s cpu, solution 8, maybe more) ? ;
X = [f1, dupont, lyon, f4, p2, 300]
Yes (0.01s cpu, solution 9, maybe more) ? ;
X = [f1, dupont, lyon, f4, p1, 300]
Yes (0.01s cpu, solution 10, maybe more) ? ;
X = [f2, durand, lille, f1, p1, 300]
Yes (0.01s cpu, solution 11, maybe more) ? ;
X = [f2, durand, lille, f2, p2, 200]
Yes (0.01s cpu, solution 12, maybe more) ? ;
X = [f2, durand, lille, f3, p3, 200]
Yes (0.01s cpu, solution 13, maybe more) ? ;
X = [f2, durand, lille, f4, p4, 400]
Yes (0.01s cpu, solution 14, maybe more) ? ;
X = [f2, durand, lille, f6, p5, 500]
Yes (0.01s cpu, solution 15, maybe more) ? ;
X = [f2, durand, lille, f6, p6, 1000]
Yes (0.01s cpu, solution 16, maybe more) ? ;
X = [f2, durand, lille, f6, p7, 300]
Yes (0.01s cpu, solution 17, maybe more) ? ;
X = [f2, durand, lille, f1, p2, 300]
Yes (0.01s cpu, solution 18, maybe more) ? ;
X = [f2, durand, lille, f4, p2, 300]
Yes (0.01s cpu, solution 19, maybe more) ? ;
X = [f2, durand, lille, f4, p1, 300]
Yes (0.01s cpu, solution 20, maybe more) ? ;
X = [f3, martin, rennes, f1, p1, 300]
Yes (0.01s cpu, solution 21, maybe more) ? ;
X = [f3, martin, rennes, f2, p2, 200]
Yes (0.01s cpu, solution 22, maybe more) ? ;
X = [f3, martin, rennes, f3, p3, 200]
Yes (0.01s cpu, solution 23, maybe more) ? ;
X = [f3, martin, rennes, f4, p4, 400]
Yes (0.01s cpu, solution 24, maybe more) ? ;
X = [f3, martin, rennes, f6, p5, 500]
Yes (0.01s cpu, solution 25, maybe more) ? ;
X = [f3, martin, rennes, f6, p6, 1000]
Yes (0.01s cpu, solution 26, maybe more) ? ;
X = [f3, martin, rennes, f6, p7, 300]
Yes (0.01s cpu, solution 27, maybe more) ? ;
X = [f3, martin, rennes, f1, p2, 300]
Yes (0.01s cpu, solution 28, maybe more) ? ;
X = [f3, martin, rennes, f4, p2, 300]
Yes (0.01s cpu, solution 29, maybe more) ? ;
X = [f3, martin, rennes, f4, p1, 300]
Yes (0.01s cpu, solution 30, maybe more) ? ;
X = [f4, michel, clermontFerrand, f1, p1, 300]
Yes (0.01s cpu, solution 31, maybe more) ? ;
X = [f4, michel, clermontFerrand, f2, p2, 200]
Yes (0.01s cpu, solution 32, maybe more) ? ;
X = [f4, michel, clermontFerrand, f3, p3, 200]
Yes (0.01s cpu, solution 33, maybe more) ? ;
X = [f4, michel, clermontFerrand, f4, p4, 400]
Yes (0.01s cpu, solution 34, maybe more) ? ;
X = [f4, michel, clermontFerrand, f6, p5, 500]
Yes (0.01s cpu, solution 35, maybe more) ? ;
X = [f4, michel, clermontFerrand, f6, p6, 1000]
Yes (0.01s cpu, solution 36, maybe more) ? ;
X = [f4, michel, clermontFerrand, f6, p7, 300]
Yes (0.01s cpu, solution 37, maybe more) ? ;
X = [f4, michel, clermontFerrand, f1, p2, 300]
Yes (0.01s cpu, solution 38, maybe more) ? ;
X = [f4, michel, clermontFerrand, f4, p2, 300]
Yes (0.01s cpu, solution 39, maybe more) ? ;
X = [f4, michel, clermontFerrand, f4, p1, 300]
Yes (0.01s cpu, solution 40, maybe more) ? ;
X = [f5, smith, paris, f1, p1, 300]
Yes (0.01s cpu, solution 41, maybe more) ? ;
X = [f5, smith, paris, f2, p2, 200]
Yes (0.01s cpu, solution 42, maybe more) ? ;
X = [f5, smith, paris, f3, p3, 200]
Yes (0.01s cpu, solution 43, maybe more) ? ;
X = [f5, smith, paris, f4, p4, 400]
Yes (0.01s cpu, solution 44, maybe more) ? ;
X = [f5, smith, paris, f6, p5, 500]
Yes (0.01s cpu, solution 45, maybe more) ? ;
X = [f5, smith, paris, f6, p6, 1000]
Yes (0.01s cpu, solution 46, maybe more) ? ;
X = [f5, smith, paris, f6, p7, 300]
Yes (0.01s cpu, solution 47, maybe more) ? ;
X = [f5, smith, paris, f1, p2, 300]
Yes (0.01s cpu, solution 48, maybe more) ? ;
X = [f5, smith, paris, f4, p2, 300]
Yes (0.01s cpu, solution 49, maybe more) ? ;
X = [f5, smith, paris, f4, p1, 300]
Yes (0.01s cpu, solution 50, maybe more) ? ;
X = [f6, brown, marseille, f1, p1, 300]
Yes (0.01s cpu, solution 51, maybe more) ? ;
X = [f6, brown, marseille, f2, p2, 200]
Yes (0.01s cpu, solution 52, maybe more) ? ;
X = [f6, brown, marseille, f3, p3, 200]
Yes (0.01s cpu, solution 53, maybe more) ? ;
X = [f6, brown, marseille, f4, p4, 400]
Yes (0.01s cpu, solution 54, maybe more) ? ;
X = [f6, brown, marseille, f6, p5, 500]
Yes (0.01s cpu, solution 55, maybe more) ? ;
X = [f6, brown, marseille, f6, p6, 1000]
Yes (0.01s cpu, solution 56, maybe more) ? ;
X = [f6, brown, marseille, f6, p7, 300]
Yes (0.01s cpu, solution 57, maybe more) ? ;
X = [f6, brown, marseille, f1, p2, 300]
Yes (0.01s cpu, solution 58, maybe more) ? ;
X = [f6, brown, marseille, f4, p2, 300]
Yes (0.01s cpu, solution 59, maybe more) ? ;
X = [f6, brown, marseille, f4, p1, 300]
Yes (0.01s cpu, solution 60)

jointure(X).
X = [f1, dupont, lyon, p1, 300]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [f1, dupont, lyon, p2, 300]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [f2, durand, lille, p2, 200]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [f3, martin, rennes, p3, 200]
Yes (0.00s cpu, solution 4, maybe more) ? ;
X = [f4, michel, clermontFerrand, p4, 400]
Yes (0.00s cpu, solution 5, maybe more) ? ;
X = [f4, michel, clermontFerrand, p2, 300]
Yes (0.00s cpu, solution 6, maybe more) ? ;
X = [f4, michel, clermontFerrand, p1, 300]
Yes (0.00s cpu, solution 7, maybe more) ? ;
X = [f6, brown, marseille, p5, 500]
Yes (0.00s cpu, solution 8, maybe more) ? ;
X = [f6, brown, marseille, p6, 1000]
Yes (0.00s cpu, solution 9, maybe more) ? ;
X = [f6, brown, marseille, p7, 300]
Yes (0.00s cpu, solution 10)

jointure350(X).
X = [f4, michel, clermontFerrand, p4, 400]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [f6, brown, marseille, p5, 500]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [f6, brown, marseille, p6, 1000]
Yes (0.00s cpu, solution 3, maybe more) ? ;
No (0.00s cpu)

div(X).
X = [f1, dupont, lyon]
Yes (0.00s cpu, solution 1, maybe more) ? ;
X = [f1, dupont, lyon]
Yes (0.00s cpu, solution 2, maybe more) ? ;
X = [f2, durand, lille]
Yes (0.00s cpu, solution 3, maybe more) ? ;
X = [f4, michel, clermontFerrand]
Yes (0.00s cpu, solution 4, maybe more) ? ;
X = [f4, michel, clermontFerrand]
Yes (0.00s cpu, solution 5, maybe more) ? ;
No (0.00s cpu)

?- nbPiece([f2,Q]).
Q = 200 .

?- nbPiece([f6,Q]).
Q = 1800

?- nbPiece(X).
X = [f1, 600] ;
X = [f2, 200] ;
X = [f3, 200] ;
X = [f4, 1000] ;
X = [f6, 1800] ;

?- ensemble_comp(voiture, X).
X = [porte, roue, moteur, tole, vitre, jante, pneu, piston, soupape].

?- ensemble_comp(moteur, X).
X = [piston, soupape].

?- nombre_piece(voiture,R).
R = 36 ;

?- nb_voiture(R).
R = 62 .
*/

