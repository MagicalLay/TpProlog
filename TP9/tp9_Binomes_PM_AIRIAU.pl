/**
TP 9 Prolog

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/

/*

========================================================
I- Résolution par force brute
========================================================



*********************************
Question 1.1
*********************************

*/

creerBinomes(_,[],[]).
creerBinomes(A,[B|Suite],[(A,B)|Suite2]) :- 
		creerBinomes(A,Suite,Suite2). 

combiner([],[]).
combiner([C1|Suite], Binomes) :- 
		creerBinomes(C1, Suite, B1),
		combiner(Suite, Suite2),
		append(B1, Suite2, Binomes).
		
/*

*******************************
Question 1.2
*******************************

*/

extraire_aux(BinRest, 0, [], BinRest, _).
extraire_aux([(E1,E2)|Suite], Nb, [(E1,E2)|Suite2], RemainingBinomes,PluDispo) :- 
		\==(Nb, 0),
		not(member(E1,PluDispo)),
		not(member(E2,PluDispo)),
		Nbn is Nb-1,
		extraire_aux(Suite, Nbn, Suite2, RemainingBinomes, [E1,E2|PluDispo]).
extraire_aux([(E1,E2)|Suite], Nb, Suite2, [(E1,E2)|RemainingBinomes], PluDispo) :- 
		\==(Nb,0),
		extraire_aux(Suite,Nb,Suite2,RemainingBinomes,PluDispo).

extraire(AllPossibleBinomes,NbBinomes, Tp, RemainingBinomes) :-
		extraire_aux(AllPossibleBinomes,NbBinomes, Tp, RemainingBinomes,[]).	

/*

*******************************
Question 1.3
*******************************

*/	

nb_binome([],0).
nb_binome([_,_|Suite],Res1) :-
		nb_binome(Suite,Res2),
		Res1 is Res2+1.

les_tps_aux([],_,[]).
les_tps_aux(Copains, NbBin, [Tp|Suite]) :-
		extraire(Copains,NbBin, Tp, RemainingBinomes),
		les_tps_aux(RemainingBinomes,NbBin, Suite),
		!.
	
les_tps(Copain,Tp) :-
		combiner(Copain,Binomes),
		nb_binome(Copain,NbBin),
		les_tps_aux(Binomes, NbBin, Tp).
/*

========================================================
Tests
========================================================

**************
Q 1.1
**************
?- combiner([pluto, riri, fifi, loulou], Binomes).
Binomes = [ (pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)]

**************
Q 1.2
**************
?- combiner([pluto, riri, fifi, loulou], Binomes),extraire(Binomes,2,Tp,R).
Binomes = [ (pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)],
Tp = [ (pluto, riri), (fifi, loulou)],
R = [ (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou)] ;
Binomes = [ (pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)],
Tp = [ (pluto, fifi), (riri, loulou)],
R = [ (pluto, riri), (pluto, loulou), (riri, fifi), (fifi, loulou)] ;
Binomes = [ (pluto, riri), (pluto, fifi), (pluto, loulou), (riri, fifi), (riri, loulou), (fifi, loulou)],
Tp = [ (pluto, loulou), (riri, fifi)],
R = [ (pluto, riri), (pluto, fifi), (riri, loulou), (fifi, loulou)] ;
false.

***************
Q 1.3
***************
?- les_tps([pluto, riri, fifi, loulou], Binomes).
Binomes = [[ (pluto, riri), (fifi, loulou)], [ (pluto, fifi), (riri, loulou)], [ (pluto, loulou), (riri, fifi)]] ;
false.


*/
