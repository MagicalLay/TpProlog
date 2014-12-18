/**
TP 10 Prolog : Mondes Possibles

@author Pierre-Marie AIRIAU
@version Annee scolaire 2014/2015
*/

% dana likes cody
% bess does not like dana
% cody does not like abby
% nobody likes someone who does not like her
% abby likes everyone who likes bess
% dana likes everyone bess likes
% everybody likes somebody

people([abby, bess, cody, dana]).

% Question 1.1

combinaisonLikes(X, [Z], [likes(X,Z)]).
combinaisonLikes(X, [Z|Y], [likes(X,Z)|Suite]) :- 
		combinaisonLikes(X, Y, Suite).

combinaison([X],[Y|Z],Res) :- 
		combinaisonLikes(X, [Y|Z], Res).
combinaison([W|X],[Y|Z],Res) :- 
		combinaisonLikes(W,[Y|Z],Res1),
		combinaison(X,[Y|Z],Res2),
		append(Res1,Res2,Res).

make_all_pairs([X],likes(X, X)).
make_all_pairs(X,Res) :- 
		combinaison(X,X,Res).

% Question 1.2

sub_list([],[]).
sub_list([W|X],[W|Z]) :- sub_list(X,Z).
sub_list([_|X],Z) :- sub_list(X,Z).
	
% Question 1.3

proposition1([likes(dana,cody)|_]) :- !.
proposition1([_|Y]) :- proposition1(Y).


proposition2([]).
proposition2([X|Y]) :- \==(X, likes(bess, dana)), proposition2(Y).

proposition3([]).
proposition3([X|Y]) :- \==(X, likes(cody, abby)), proposition3(Y).

test4([],_).
test4([likes(A,B)|X], Y) :- 
		member(likes(B,A), Y), 
		test4(X, Y).
proposition4(X) :- test4(X,X).

test5([],_).
test5([likes(_,B)|X], Y) :-
		\==(B, bess),
		test5(X, Y).
test5([likes(A,bess)|X], Y) :- 
		member(likes(abby,A), Y), 
		test5(X, Y).
proposition5(X) :- test5(X,X).

test6([],_).
test6([likes(B,_)|X], Y) :-
		\==(B, bess),
		test6(X, Y).
test6([likes(bess,A)|X], Y) :- 
		member(likes(dana,A), Y), 
		test6(X, Y).
proposition6(X) :- test6(X,X).

proposition7(X) :- 
		member(likes(abby,_), X),
		member(likes(bess,_), X),
		member(likes(cody,_), X),
		member(likes(dana,_), X).

% Question 1.4

possible_worlds(Monde) :- 
        	make_all_pairs([abby, bess, cody, dana],ListePaires),
        	sub_list(ListePaires,Monde),
        	proposition1(Monde),
        	proposition2(Monde),
        	proposition3(Monde),
        	proposition4(Monde),
        	proposition5(Monde),
        	proposition6(Monde),
        	proposition7(Monde).

%Question 1.5

possible_worlds2(Monde) :- 
        	make_all_pairs([abby, bess, cody, dana],ListePaires),
        	sub_list(ListePaires,Monde),
        	proposition1(Monde),
        	proposition2(Monde),
        	proposition3(Monde),
        	proposition4(Monde),
        	proposition5(Monde),
        	proposition6(Monde),
        	proposition7(Monde),
		is_set(Monde).


% Questions 1.6 and 1.7

test_possible_worlds :-
        possible_worlds(World),
        writeln(World),
        fail.

% liste 4 personnes : 65 536 solutions (soit 2^16).
% liste 5 personnes : 33 554 432 (soit près de 2^34).
% On propose donc une borne inférieure de 2^(2^n).


% Question 1.7

% Les résultats du coverage sont légèrement différents. Ceci est dû au fait que les propositions filtrent dans un ordre different les résultats. 
%Toutefois, le monde des solutions reste identiques,ce qui est normal car l'ordre des propositions n'importe pas ici.


/********************************************
Tests
*********************************************

=========================
Question 1.1
=========================

?- make_all_pairs([1,2],Res).
Res = [likes(1, 1), likes(1, 2), likes(2, 1), likes(2, 2)]
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

?- make_all_pairs([1,2,3],Res).
Res = [likes(1, 1), likes(1, 2), likes(1, 3), likes(2, 1), likes(2, 2), likes(2, 3), likes(3, 1), likes(3, 2), likes(3, 3)]
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

=========================
Question 1.2
=========================

[eclipse 9]: sub_list([1,2],Res).
Res = [1, 2]
Yes (0.00s cpu, solution 1, maybe more) ? ;
Res = [1]
Yes (0.00s cpu, solution 2, maybe more) ? ;
Res = [2]
Yes (0.00s cpu, solution 3, maybe more) ? ;
Res = []
Yes (0.00s cpu, solution 4)

[eclipse 10]: sub_list([1,2,4],Res).
Res = [1, 2, 4]
Yes (0.00s cpu, solution 1, maybe more) ? ;
Res = [1, 2]
Yes (0.00s cpu, solution 2, maybe more) ? ;
Res = [1, 4]
Yes (0.00s cpu, solution 3, maybe more) ? ;
Res = [1]
Yes (0.00s cpu, solution 4, maybe more) ? ;
Res = [2, 4]
Yes (0.00s cpu, solution 5, maybe more) ? ;
Res = [2]
Yes (0.00s cpu, solution 6, maybe more) ? ;
Res = [4]
Yes (0.00s cpu, solution 7, maybe more) ? ;
Res = []
Yes (0.00s cpu, solution 8)

=========================
Question 1.3
=========================

[eclipse 22]: proposition1([likes(cody, dana), likes(dana, dana)]).
No (0.00s cpu)
[eclipse 23]: proposition1([likes(dana, cody), likes(dana, dana)]).
Yes (0.00s cpu)
[eclipse 24]: proposition1([likes(cody, bess), likes(dana, cody), likes(dana, dana)]).
Yes (0.00s cpu)

[eclipse 33]: proposition2([likes(dana, cody), likes(dana, dana)]).
Yes (0.00s cpu)
[eclipse 34]: proposition2([likes(dana, cody), likes(bess, cody), likes(dana, dana)]).
Yes (0.00s cpu)
[eclipse 35]: proposition2([likes(dana, cody), likes(bess, dana), likes(dana, dana)]).
No (0.00s cpu)

[eclipse 40]: proposition3([likes(dana, cody), likes(dana, dana)]).
Yes (0.00s cpu)
[eclipse 41]: proposition3([likes(dana, cody), likes(cody, dana), likes(dana, dana)]).
Yes (0.00s cpu)
[eclipse 42]: proposition3([likes(dana, cody), likes(cody, abby), likes(dana, dana)]).
No (0.00s cpu)

[eclipse 67]: proposition4([]).
Yes (0.00s cpu)
[eclipse 68]: proposition4([likes(cody, anna)]).
No (0.00s cpu)
[eclipse 69]: proposition4([likes(cody, dana), likes(dana, cody)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 70]: proposition4([likes(cody, dana), likes(dana, cody), likes(bess, abby)]).
No (0.00s cpu)
[eclipse 71]: proposition4([likes(cody, dana), likes(abby, bess), likes(dana, cody), likes(bess, abby)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

[eclipse 79]: proposition5([likes(cody, dana)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 80]: proposition5([likes(cody, dana), likes(dana, bess)]).
No (0.00s cpu)
[eclipse 81]: proposition5([likes(cody, dana), likes(dana, bess), likes(abby, dana)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 82]: proposition5([likes(abby, bess), likes(cody, dana), likes(abby, dana), likes(dana, bess), likes(abby, abby)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 83]: proposition5([likes(dana, bess), likes(cody, bess), likes(abby, dana)]).
No (0.00s cpu)

[eclipse 88]: proposition6([likes(cody, dana)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)
[eclipse 89]: proposition6([likes(cody, dana), likes(bess, cody)]).
No (0.00s cpu)
?- proposition6([likes(dana, abby), likes(bess, abby)]).
true
[eclipse 90]: proposition6([likes(cody, dana), likes(bess, cody), likes(dana, cody)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

[eclipse 92]: proposition7([likes(cody, dana)]).
No (0.00s cpu)
[eclipse 93]: proposition7([likes(cody, dana), likes(dana, abby)]).
No (0.00s cpu)
[eclipse 94]: proposition7([likes(cody, abby), likes(dana, abby), likes(abby, dana), likes(bess, dana)]).
Yes (0.00s cpu, solution 1, maybe more) ? ;
No (0.00s cpu)

=========================
Question 1.4
=========================

?- possible_worlds(X).
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] ;
X = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby), likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(..., ...)] 
....
=========================
Question 1.6
=========================

test_possible_worlds.
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,cody),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody),likes(dana,dana)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
[likes(abby,abby),likes(abby,bess),likes(abby,dana),likes(bess,abby),likes(cody,dana),likes(dana,abby),likes(dana,cody)]
...
==============================================================================
                               Coverage by File                               
==============================================================================
File                                                     Clauses    %Cov %Fail
==============================================================================
d:/swipl/library/lists.pl                                     97     2.1   0.0
d:/swipl/library/test_cover.pl                                22     9.1   4.5
==============================================================================

*/
