/**
TP 8 Traitement Automatique de la Langue (TAL) - Prolog

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/


/**************************************
Question 1.1
***************************************

GP_NOMINAL = article nom_commun | nom_propre | article nom_commun adjectif | article nom_commun RELATIF | nom_propre RELATIF | article nom_commun RELATIF GP_VERBAL | nom_propre RELATIF GP_VERBAL

GP_VERBAL = verbe | verbe GP_NOMINAL

GP_PREP = prep GP_NOMINAL | prep GP_VERBAL

RELATIF = pronom GP_VERBAL

*/


/**************************************
Question 2.1
***************************************

===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================

phrase_simple(Phrase) :- gp_nominal(Phrase,S1),
		gp_verbal(S1,[]).
phrase_simple(Phrase) :- gp_nominal(Phrase,S1),
		gp_verbal(S1,S2),
		gp_prepositionnel(S2,[]).
phrase_simple(Phrase) :- gp_nominal(Phrase,S1),
		gp_prepositionnel(S1,S2),
		gp_verbal(S2,[]).
phrase_simple(Phrase) :- gp_prepositionnel(Phrase,[]).

gp_nominal([Np|Suite],Suite) :- nom_propre(Np).
gp_nominal(Gn,Suite) :- Gn=[Art|S],
		article(Art),
		S=[Nc|Suite],
		nom_commun(Nc).
gp_nominal(Gn,Suite) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S2],
		nom_commun(Nc),
		S2=[Adj|Suite],
		adjectif(Adj).
gp_nominal(Gn,Suite) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S1],
		nom_commun(Nc),
		relatif(S1,Suite).
gp_nominal(Gn,Suite) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S1],
		nom_commun(Nc),
		relatif(S1,S2),
		gp_verbal(S2, Suite).
gp_nominal(Gn,Suite) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,Suite).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL, GV)) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,S1, REL),
		gp_verbal(S1, Suite, GV).

gp_verbal([V|Suite],Suite) :- verbe(V).
gp_verbal(L,Suite) :- L=[V|R],
		verbe(V),
		gp_nominal(R,Suite).

gp_prepositionnel(Gp,Suite) :- Gp=[Prep|S],
		prep(Prep),
		gp_nominal(S,Suite).
gp_prepositionnel(Gp,Suite) :- Gp=[Prep|S],
		prep(Prep),
		gp_verbal(S,Suite).

relatif(Rel,Suite) :- Rel=[Pro|S],
		pronom(Pro),
		gp_verbal(S,Suite).

		
article(le).
article(les).
article(la).
article(un).
article(une).
nom_commun(chien).
nom_commun(enfants).
nom_commun(rue).
nom_commun(femme).
nom_commun(pull).
nom_commun(steak).
nom_propre(paul).
adjectif(noir).
prep(dans).
verbe(aboie).
verbe(jouent).
verbe(marche).
verbe(porte).
verbe(mange).
pronom(qui).

analyse(Phrase) :- phrase_simple(Phrase).

===============================================================================
===============================================================================
 Tests
===============================================================================

analyse([le,chien,aboie]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

analyse([les,enfants,jouent]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

3 ?- analyse([paul,marche,dans,la,rue]).
true .

5 ?- analyse([les,chien,aboie]).
true 

6 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,chien]). 

true .

7 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,steak]).
true .

15 ?- analyse([paul,qui,porte,un,pull,noir,mange,un,steak]).
true .
*/

/**************************************
Question 2.2
***************************************

===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================


phrase_simple(Phrase, phr(GN, GV)) :- gp_nominal(Phrase,S1, GN),
		gp_verbal(S1,[], GV).
phrase_simple(Phrase, phr(GN, GV, GP)) :- gp_nominal(Phrase,S1, GN),
		gp_verbal(S1,S2, GV),
		gp_prepositionnel(S2,[], GP).
phrase_simple(Phrase, phr(GN, GP, GV)) :- gp_nominal(Phrase,S1, GN),
		gp_prepositionnel(S1,S2, GP),
		gp_verbal(S2,[], GV).
phrase_simple(Phrase, phr(GP)) :- gp_prepositionnel(Phrase,[], GP).

gp_nominal([Np|Suite],Suite, gn(Np)) :- nom_propre(Np).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc))) :- Gn=[Art|S],
		article(Art),
		S=[Nc|Suite],
		nom_commun(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj))) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S2],
		nom_commun(Nc),
		S2=[Adj|Suite],
		adjectif(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL)) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S1],
		nom_commun(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV)) :- Gn=[Art|S],
		article(Art),
		S=[Nc|S1],
		nom_commun(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL)) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,Suite, REL).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL, GV)) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,S1, REL),
		gp_verbal(S1, Suite, GV).

gp_verbal([V|Suite],Suite, gv(verbe(V))) :- verbe(V).
gp_verbal(L,Suite, gv(verbe(V), GN)) :- L=[V|R],
		verbe(V),
		gp_nominal(R,Suite, GN).

gp_prepositionnel(Gp,Suite, gp(prep(Prep), GN)) :- Gp=[Prep|S],
		prep(Prep),
		gp_nominal(S,Suite, GN).
gp_prepositionnel(Gp,Suite, gp(prep(Prep), GV)) :- Gp=[Prep|S],
		prep(Prep),
		gp_verbal(S,Suite, GV).

relatif(Rel,Suite, rel(pronom(Pro), GV)) :- Rel=[Pro|S],
		pronom(Pro),
		gp_verbal(S,Suite, GV).


		
article(le).
article(les).
article(la).
article(un).
article(une).
nom_commun(chien).
nom_commun(enfants).
nom_commun(rue).
nom_commun(femme).
nom_commun(pull).
nom_commun(steak).
nom_propre(paul).
adjectif(noir).
prep(dans).
verbe(aboie).
verbe(jouent).
verbe(marche).
verbe(porte).
verbe(mange).
pronom(qui).

analyse(Phrase, R) :- phrase_simple(Phrase, R).


===============================================================================
===============================================================================
 Tests
===============================================================================

17 ?- analyse([paul,qui,porte,un,pull,noir,mange,un,steak], R).
R = phr(gn(nom_prop(paul), rel(pronom(qui), gv(verbe(porte), gn(art(un), nom_com(pull), adj(noir))))), gv(verbe(mange), gn(art(un), nom_com(steak)))) .

*/

/**************************************
Question 2.3
***************************************

===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================


phrase_simple(Phrase, phr(GN, GV)) :- gp_nominal(Phrase,S1, GN),
		gp_verbal(S1,[], GV).
phrase_simple(Phrase, phr(GN, GV, GP)) :- gp_nominal(Phrase,S1, GN),
		gp_verbal(S1,S2, GV),
		gp_prepositionnel(S2,[], GP).
phrase_simple(Phrase, phr(GN, GP, GV)) :- gp_nominal(Phrase,S1, GN),
		gp_prepositionnel(S1,S2, GP),
		gp_verbal(S2,[], GV).
phrase_simple(Phrase, phr(GP)) :- gp_prepositionnel(Phrase,[], GP).

gp_nominal([Np|Suite],Suite, gn(Np)) :- nom_propre(Np).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc))) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|Suite],
		nom_communSingMasc(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc))) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|Suite],
		nom_communSingFem(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc))) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|Suite],
		nom_communPlurFem(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc))) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|Suite],
		nom_communPlurMasc(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj))) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S2],
		nom_communSingFem(Nc),
		S2=[Adj|Suite],
		adjectifSingFem(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj))) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S2],
		nom_communSingMasc(Nc),
		S2=[Adj|Suite],
		adjectifSingMasc(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj))) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S2],
		nom_communPlurFem(Nc),
		S2=[Adj|Suite],
		adjectifPlurFem(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj))) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S2],
		nom_communPlurMasc(Nc),
		S2=[Adj|Suite],
		adjectifPlurMasc(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL)) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S1],
		nom_communSingFem(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL)) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S1],
		nom_communSingMasc(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL)) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurFem(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL)) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurMasc(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV)) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S1],
		nom_communSingFem(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV)) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S1],
		nom_communSingMasc(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV)) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurFem(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV)) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurMasc(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL)) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,Suite, REL).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL, GV)) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,S1, REL),
		gp_verbal(S1, Suite, GV).

gp_verbal([V|Suite],Suite, gv(verbe(V))) :- verbe(V).
gp_verbal(L,Suite, gv(verbe(V), GN)) :- L=[V|R],
		verbe(V),
		gp_nominal(R,Suite, GN).

gp_prepositionnel(Gp,Suite, gp(prep(Prep), GN)) :- Gp=[Prep|S],
		prep(Prep),
		gp_nominal(S,Suite, GN).
gp_prepositionnel(Gp,Suite, gp(prep(Prep), GV)) :- Gp=[Prep|S],
		prep(Prep),
		gp_verbal(S,Suite, GV).

relatif(Rel,Suite, rel(pronom(Pro), GV)) :- Rel=[Pro|S],
		pronom(Pro),
		gp_verbal(S,Suite, GV).

		
articleSingMasc(le).
articleSingMasc(un).
articleSingFem(une).
articleSingFem(la).
articlePlur(les).
articlePlur(des).
nom_communSingMasc(chien).
nom_communSingMasc(pull).
nom_communSingMasc(steak).
nom_communSingFem(rue).
nom_communSingFem(femme).
nom_communPlurMasc(enfants).
nom_communPlurMasc(chiens).
nom_communPlurFem(femmes).
nom_propre(paul).
adjectifSingMasc(noir).
adjectifSingFem(noire).
adjectifPlurMasc(noirs).
adjectifPlurFem(noires).
prep(dans).
verbe(aboie).
verbe(jouent).
verbe(marche).
verbe(porte).
verbe(mange).
pronom(qui).

analyse(Phrase, R) :- phrase_simple(Phrase, R).


===============================================================================
===============================================================================
 Tests
===============================================================================

31 ?- analyse([le,chien,aboie], R).
R = phr(gn(art(le), nom_com(chien)), gv(verbe(aboie))) .

32 ?- analyse([les,chien,aboie], R).
false.

34 ?- analyse([les,enfants,jouent], R).
R = phr(gn(art(les), nom_com(enfants)), gv(verbe(jouent))) .

35 ?- analyse([une,enfants,jouent], R).
false.

37 ?- analyse([paul,marche,dans,la,rue],R).
R = phr(gn(paul), gv(verbe(marche)), gp(prep(dans), gn(art(la), nom_com(rue)))) .

38 ?- analyse([paul,marche,dans,un,rue],R).
false.

40 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,steak],R).
R = phr(gn(art(la), nom_com(femme), rel(pronom(qui), gv(verbe(porte), gn(art(un), nom_com(pull), adj(noir))))), gv(verbe(mange), gn(art(un), nom_com(steak)))) .

41 ?- analyse([la,femmes,qui,porte,un,pull,noir,mange,un,steak],R).
false.

42 ?- analyse([la,femme,qui,porte,une,pull,noir,mange,un,steak],R).
false.

43 ?- analyse([la,femme,qui,porte,une,pull,noir,mange,les,steak],R).
false.

49 ?- analyse([les,chien,aboie],R).
false.

50 ?- analyse([les,chiens,aboie],R).
R = phr(gn(art(les), nom_com(chiens)), gv(verbe(aboie))) .

52 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,chien],R).
R = phr(gn(art(la), nom_com(femme), rel(pronom(qui), gv(verbe(porte), gn(art(un), nom_com(pull), adj(noir))))), gv(verbe(mange), gn(art(un), nom_com(chien)))) .

53 ?- analyse([la,femme,qui,porte,un,pull,noire,mange,un,chien],R).
false.
*/

/**************************************
Question 2.4
***************************************

===============================================================================
===============================================================================
 Définition des prédicats
===============================================================================
*/

phrase_simple(Phrase, phr(GN, GV)) :- gp_nominal(Phrase,S1, GN, Sem),
		gp_verbal(S1,[], GV, Sem2),
		lies(Sem,Sem2).
phrase_simple(Phrase, phr(GN, GV, GP)) :- gp_nominal(Phrase,S1, GN, Sem),
		gp_verbal(S1,S2, GV, Sem2),
		lies(Sem,Sem2),
		gp_prepositionnel(S2,[], GP).
phrase_simple(Phrase, phr(GN, GP, GV)) :- gp_nominal(Phrase,S1, GN, Sem),
		gp_prepositionnel(S1,S2, GP),
		gp_verbal(S2,[], GV, Sem2),
		lies(Sem,Sem2).
phrase_simple(Phrase, phr(GP)) :- gp_prepositionnel(Phrase,[], GP).

gp_nominal([Np|Suite],Suite, gn(Np), Np) :- nom_propre(Np).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc)), Nc) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|Suite],
		nom_communSingMasc(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc)), Nc) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|Suite],
		nom_communSingFem(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc)), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|Suite],
		nom_communPlurFem(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc)), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|Suite],
		nom_communPlurMasc(Nc).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj)), Nc) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S2],
		nom_communSingFem(Nc),
		S2=[Adj|Suite],
		adjectifSingFem(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj)), Nc) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S2],
		nom_communSingMasc(Nc),
		S2=[Adj|Suite],
		adjectifSingMasc(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj)), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S2],
		nom_communPlurFem(Nc),
		S2=[Adj|Suite],
		adjectifPlurFem(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), adj(Adj)), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S2],
		nom_communPlurMasc(Nc),
		S2=[Adj|Suite],
		adjectifPlurMasc(Adj).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL), Nc) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S1],
		nom_communSingFem(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL), Nc) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S1],
		nom_communSingMasc(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurFem(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurMasc(Nc),
		relatif(S1,Suite, REL).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV), Nc) :- Gn=[Art|S],
		articleSingFem(Art),
		S=[Nc|S1],
		nom_communSingFem(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV, Sem),
		lies(Nc,Sem).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV), Nc) :- Gn=[Art|S],
		articleSingMasc(Art),
		S=[Nc|S1],
		nom_communSingMasc(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV, Sem),
		lies(Nc,Sem).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurFem(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV, Sem),
		lies(Nc,Sem).
gp_nominal(Gn,Suite, gn(art(Art), nom_com(Nc), REL, GV), Nc) :- Gn=[Art|S],
		articlePlur(Art),
		S=[Nc|S1],
		nom_communPlurMasc(Nc),
		relatif(S1,S2, REL),
		gp_verbal(S2, Suite, GV, Sem),
		lies(Nc,Sem).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL), Np) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,Suite, REL).
gp_nominal(Gn,Suite, gn(nom_prop(Np), REL, GV), Np) :- Gn=[Np|S],
		nom_propre(Np),
		relatif(S,S1, REL),
		gp_verbal(S1, Suite, GV, Sem),
		lies(Np, Sem).

gp_verbal([V|Suite],Suite, gv(verbe(V)), V) :- verbe(V).
gp_verbal(L,Suite, gv(verbe(V), GN), V) :- L=[V|R],
		verbe(V),
		gp_nominal(R,Suite, GN, Sem),
		lies(V, Sem).

gp_prepositionnel(Gp,Suite, gp(prep(Prep), GN)) :- Gp=[Prep|S],
		prep(Prep),
		gp_nominal(S,Suite, GN, Sem).
gp_prepositionnel(Gp,Suite, gp(prep(Prep), GV)) :- Gp=[Prep|S],
		prep(Prep),
		gp_verbal(S,Suite, GV, Sem).

relatif(Rel,Suite, rel(pronom(Pro), GV)) :- Rel=[Pro|S],
		pronom(Pro),
		gp_verbal(S,Suite, GV, Sem).

		
articleSingMasc(le).
articleSingMasc(un).
articleSingFem(une).
articleSingFem(la).
articlePlur(les).
articlePlur(des).
nom_communSingMasc(chien).
nom_communSingMasc(pull).
nom_communSingMasc(steak).
nom_communSingFem(rue).
nom_communSingFem(femme).
nom_communPlurMasc(enfants).
nom_communPlurMasc(chiens).
nom_communPlurFem(femmes).
nom_propre(paul).
adjectifSingMasc(noir).
adjectifSingFem(noire).
adjectifPlurMasc(noirs).
adjectifPlurFem(noires).
prep(dans).
verbe(aboie).
verbe(jouent).
verbe(marche).
verbe(porte).
verbe(mange).
pronom(qui).

comestibles(mange).
comestibles(steak).

lieu(marche).
lieu(rue).

vetement(porte).
vetement(pull).

animal(aboie).
animal(jouent).
animal(mange).
animal(chien).
animal(chiens).

humain(joue).
humain(paul).
humain(mange).
humain(marche).
humain(femme).
humain(femmes).
humain(enfants).

lies(X, Y) :- comestibles(X),
		comestibles(Y).
lies(X, Y) :- lieu(X),
		lieu(Y).
lies(X, Y) :- vetement(X),
		vetement(Y).
lies(X, Y) :- animal(X),
		animal(Y).
lies(X, Y) :- humain(X),
		humain(Y).

analyse(Phrase, R) :- phrase_simple(Phrase, R).

/*
===============================================================================
===============================================================================
 Tests
===============================================================================

56 ?- analyse([la,femme,marche],R).
R = phr(gn(art(la), nom_com(femme)), gv(verbe(marche))) .

57 ?- analyse([le,chien,marche],R).
false.

63 ?- analyse([la,femme,qui,porte,un,pull,noire,mange,un,steak],R).
false.

64 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,steak],R).
R = phr(gn(art(la), nom_com(femme), rel(pronom(qui), gv(verbe(porte), gn(art(un), nom_com(pull), adj(noir))))), gv(verbe(mange), gn(art(un), nom_com(steak)))) .

66 ?- analyse([la,femme,qui,porte,un,pull,noir,mange,un,chien],R).
R = phr(gn(art(la), nom_com(femme), rel(pronom(qui), gv(verbe(porte), gn(art(un), nom_com(pull), adj(noir))))), gv(verbe(mange), gn(art(un), nom_com(chien)))) .
//erreur due au fait que l'algorithme ne fait pas la difference entre semantique sujet (humain : femme-mange) et semantique COD (animal : mange-chien, mais qui devrait être comestibles plutôt).  
*/

% Quelques phrases de test à copier coller pour vous faire gagner du temps, mais
% n'hésitez pas à en définir d'autres

/*
analyse([le,chien,aboie]).
analyse([les,enfants,jouent]).
analyse([paul,marche,dans,la,rue]).
analyse([la,femme,qui,porte,un,pull,noir,mange,un,steak]).
analyse([les,chien,aboie]).
analyse([la,femme,qui,porte,un,pull,noir,mange,un,chien]).              

*/
