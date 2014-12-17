/*

TP Prolog - Arithmetique

@author Pierre-Marie AIRIAU
@date 09/10/2014

*/

add(zero,zero,zero).
add(zero,s(Y),s(Z)):- add(zero,Y,Z).
add(s(X),Y,s(Z)):- add(X,Y,Z). 

/*
[eclipse 4]: ?- add(X,Y,s(s(zero))).

X = zero
Y = s(s(zero))
Yes (0.00s cpu, solution 1, maybe more) ? ;

X = s(zero)
Y = s(zero)
Yes (0.00s cpu, solution 2, maybe more) ? ;

X = s(s(zero))
Y = zero
Yes (0.00s cpu, solution 3)
[eclipse 5]: ?- add(s(zero),s(s(zero)),X).

X = s(s(s(zero)))
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

sub(X,Y,Z):- add(Y,Z,X).

/*
[eclipse 9]: ?- sub(s(s(s(zero))),s(s(zero)),X).

X = s(zero)
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

prod(zero, _, zero).
prod(s(X), Y, Z):- prod(X,Y,A), 
		   add(A,Y,Z).

/*
[eclipse 13]: ?- prod(s(s(zero)),s(s(s(zero))),Prod).

Prod = s(s(s(s(s(s(zero))))))
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

factorial(zero, s(zero)).
factorial(s(X),Y):- factorial(X,Z), 
		    prod(s(X), Z, Y).

/*
[eclipse 21]: ?- factorial(s(s(s(zero))), F).

F = s(s(s(s(s(s(zero))))))
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
[eclipse 22]: ?- factorial(s(s(s(s(s(s(s(s(s(s(s(s(zero)))))))))))), F).
*** Overflow of the global/trail stack in spite of garbage collection!
You can use the "-g kBytes" (GLOBALSIZE) option to have a larger stack.
Peak sizes were: global stack 524184 kbytes, trail stack 360 kbytes
Abort
=> le calcul de 12! ne marche pas à cause de l'overflow
*/

%%%%%%%%%%% Binary representation
add_bit(0, 0, 0, 0, 0).
add_bit(0, 0, 1, 1, 0).
add_bit(0, 1, 0, 1, 0).
add_bit(0, 1, 1, 0, 1).
add_bit(1, 0, 0, 1, 0).
add_bit(1, 0, 1, 0, 1).
add_bit(1, 1, 0, 0, 1).
add_bit(1, 1, 1, 1, 1).


add2([A],[B],[C],CI):- add_bit(A,B,CI,C,_).
add2([],[B],[C],CI):- add_bit(0,B,CI,C,_).
add2([A],[],[C],CI):- add_bit(A,0,CI,C,_).
add2([],[],[C],CI):- add_bit(0,0,CI,C,_).
add2([A|X],[B|Y],[C|Z],CI):- add_bit(A,B,CI,C,D), 
			     add2(X,Y,Z,D).

add2([],[B|Y],[C|Z],CI):- add_bit(0,B,CI,C,D), 
   			  add2([],Y,Z,D).

add2([A|X],[],[C|Z],CI):- add_bit(A,0,CI,C,D), 
			  add2(X,[],Z,D).

add1([X],[Y],[C]):- add_bit(X,Y,0,C,_).
add1([A|X],[B|Y],[C|Z]):- add_bit(A,B,0,C,D), 
			  add2(X,Y,Z,D). 

/*
[eclipse 32]: add1([1],[0,0,1,1],Sum).

Sum = [1, 0, 1, 1]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Sum = [1, 0, 1, 1, 0]
Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)

[eclipse 33]: add1([1,0,0,1],[0,0,1,1],Sum).

Sum = [1, 0, 1, 0]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Sum = [1, 0, 1, 0, 1]
Yes (0.00s cpu, solution 2, maybe more) ? ;

No (0.00s cpu)
*/

sub1(X,Y,Z):- add1(Y,Z,X).

/*
[eclipse 35]: sub1([1,0,1,1],[1],Sub).

Sub = [0, 0, 1, 1]
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)


[eclipse 36]: sub1([1,0,1,1],[0,0,1,1],Sub).

Sub = [1, 0, 0, 0]
Yes (0.00s cpu, solution 1, maybe more) ? ;

Sub = [1, 0, 0]
Yes (0.00s cpu, solution 2, maybe more) ? ;

Sub = [1, 0]
Yes (0.00s cpu, solution 3, maybe more) ? ;

Sub = [1]
Yes (0.00s cpu, solution 4, maybe more) ? ;

No (0.00s cpu)
*/

prod1([], _, [0]).
prod1([0], _, [0]).
prod1([1], A, A).
prod1(X, Y, Z):- sub1(X,[1],X1), 
		 prod1(X1,Y,A), 
		 add1(A,Y,Z).

factorial1([0],[1]).
factorial1([1],[1]).
factorial1(N,Fact):- sub1(N,[1],N1), 
		     factorial1(N1, Fact1), 
		     prod1(Fact1, N, Fact).

factorial2(0,1).
factorial2(1,1).
factorial2(N,Fact):- Fact is Fact1*N, N1 is N-1, factorial2(N1, Fact1). 


/*ne marchent pas*/

%%%%%%%%%%% Optional part
evaluate_numbers(N1, M1, N2, M2) :-
        evaluate(N1, N2),
        evaluate(M1, M2),
        number(N2),
        number(M2).        

evaluate(N, N) :- number(N).

evaluate(add(N1, M1), N) :-
        evaluate_numbers(N1, M1, N2, M2),
        N is N2 + M2.

evaluate(sub(N1, M1), N) :-
        evaluate_numbers(N1, M1, N2, M2),
        N is N2 - M2.

evaluate(prod(N1, M1), N) :-
        evaluate_numbers(N1, M1, N2, M2),
        N is N2 * M2.

evaluate(eq(N1, M1), Res) :-
        evaluate_numbers(N1, M1, N2, M2),
        (
            N2 = M2, Res = t
        ;
            N2 \= M2, Res = f
        ).

evaluate(fun(X, Body), fun(X, Body)).


fresh_variables(Expr, Res) :-
       fresh_variables(Expr, [], Res).

fresh_variables(X, Assoc, Y) :-
        var(X),
        !,
        assoc(X, Assoc, Y).

fresh_variables(add(X1, Y1), Assoc, add(X2, Y2)) :-
        fresh_variables(X1, Assoc, X2),
        fresh_variables(Y1, Assoc, Y2).

fresh_variables(prod(X1, Y1), Assoc, prod(X2, Y2)) :-
        fresh_variables(X1, Assoc, X2),
        fresh_variables(Y1, Assoc, Y2).

fresh_variables(sub(X1, Y1), Assoc, sub(X2, Y2)) :-
        fresh_variables(X1, Assoc, X2),
        fresh_variables(Y1, Assoc, Y2).

fresh_variables(eq(X1, Y1), Assoc, eq(X2, Y2)) :-
        fresh_variables(X1, Assoc, X2),
        fresh_variables(Y1, Assoc, Y2).

fresh_variables(if(Cond1, X1, Y1), Assoc, if(Cond2, X2, Y2)) :-
        fresh_variables(Cond1, Assoc, Cond2),
        fresh_variables(X1, Assoc, X2),
        fresh_variables(Y1, Assoc, Y2).

fresh_variables(Number, _, Number) :- number(Number).

fresh_variables(fun(X, Body1), Assoc, fun(Y, Body2)) :-
        fresh_variables(Body1, [(X, Y) | Assoc], Body2).

fresh_variables(apply(Fun1, Param1), Assoc, apply(Fun2, Param2)) :-
        fresh_variables(Fun1, Assoc, Fun2),
        fresh_variables(Param1, Assoc, Param2).
        
%Fun = fun(N, fun(F, if(eq(N, 0), 1, prod(N, apply(apply(F, sub(N, 1)), F))))), Factorial = fun(N, apply(apply(Fun, N), Fun)), evaluate(apply(Factorial, 42), Res).
