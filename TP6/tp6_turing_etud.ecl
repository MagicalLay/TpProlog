
%%%%%%%%%%% First part

copy_prog(program(
                     start, 
                     [stop], 
                     [delta(start, ' ', ' ', right, stop),
                      delta(start, 1, ' ', right, s2),
                      delta(s2, 1, 1, right, s2),
                      delta(s2, ' ', ' ', right, s3),
                      delta(s3, 1, 1, right, s3),
                      delta(s3, ' ', 1, left, s4),
                      delta(s4, 1, 1, left, s4),
                      delta(s4, ' ', ' ', left, s5),
                      delta(s5, 1, 1, left, s5),
                      delta(s5, ' ', 1, right, start)
                     ]
                 )
         ).

initial_state(program(InitialState, _, _), InitialState).

final_states(program(_, FinalStates, _), FinalStates).

transitions(program(_, _, Deltas), Deltas).

/*********************
prédicat next
**********************/
next(Program, S1, N, N2, D, S2) :- transitions(Program, Deltas), parcoursDelta(Deltas, S1, N, N2, D, S2).

parcoursDelta([delta(S1, N, N2, D, S2)|_], S1, N, N2, D, S2).
parcoursDelta([delta(S, _, _, _, _)|X], S1, N, N2, D, S2):- \==(S, S1), parcoursDelta(X, S1, N, N2, D, S2).
parcoursDelta([delta(S1, A, _, _, _)|X], S1, N, N2, D, S2):- \==(N, A), parcoursDelta(X, S1, N, N2, D, S2).

/**************************
test next
***************************
?- next(program(start, [stop], [delta(start, ' ', ' ', right, stop),
		      delta(start, 1, ' ', right, s2),
                      delta(s2, 1, 1, right, s2),
                      delta(s2, ' ', ' ', right, s3),
                      delta(s3, 1, 1, right, s3),
                      delta(s3, ' ', 1, left, s4),
                      delta(s4, 1, 1, left, s4),
                      delta(s4, ' ', ' ', left, s5),
                      delta(s5, 1, 1, left, s5),
                      delta(s5, ' ', 1, right, start)
                     ]), start, 1, NewSymbol, Dir, NextState).

NewSymbol = ' '
Dir = right
NextState = s2
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)
*/

/***************************
prédicat update_tape
****************************/
fusion(X,[],X).
fusion([],X,X).
fusion([X|A],B,[X|C]) :- fusion(A,B,C).

update_tape(tape(Left, [_]), Symb, right, tape(Left2, [''])) :- fusion(Left,[Symb],Left2).

update_tape(tape(Left, [_|Right]), Symb, right, tape(Left2, Right)) :- \==(Right,[]), 
								       fusion(Left,[Symb],Left2).

update_tape(tape([X], [_|Right]), Symb, left, tape([''], [X, Symb|Right])).

update_tape(tape(Left, [_|Right]), Symb, left, tape(Left2, [X, Symb|Right])) :- fusion(Left2,[X],Left), 
										\==(Left2, []).
/**************************
test update_tape
***************************
[eclipse 9]: ?- update_tape(tape([''], [1,'']), '', right, UpdateTape).

UpdateTape = tape(['', ''], [''])
Yes (0.00s cpu)
*/

/***************************
prédicat run_turing_machine
****************************/
fin(X, [X|_]).
fin(X, [Y|B]) :- \==(X,Y),
		 fin(X, B).

run_turing_machine(Prog, Input, Output, OutState) :- initial_state(Prog, InitialState), 
						     final_states(Prog, ListFinalStates), 
						     move(Prog, tape([''], Input), InitialState, tape(Left, Right), OutState, ListFinalStates), 
						     fusion(Left, Right, Output).

move(Prog, tape(Left, [Symb|Right]), CurrentState, Output, OutState, List) :- next(Prog, CurrentState, Symb, NewSymb, Dir, OutState), 
									      fin(OutState, List), 
									      update_tape(tape(Left, [Symb|Right]), NewSymb, Dir, Output).

move(Prog, tape(Left, [Symb|Right]), CurrentState, Output, OutState, List) :- next(Prog, CurrentState, Symb, NewSymb, Dir, FinalState), 
									      not fin(FinalState, List),
									      update_tape(tape(Left, [Symb|Right]), NewSymb, Dir, Out), 
									      move(Prog, Out, FinalState, Output, OutState, List).
/*****************************
test run_turing_machine
******************************
ne fonctionne pas
*/

/********************************************
prédicat run_turing_machine étendu
*********************************************/
run_turing_machine2(Prog, Input, Output, OutState, [[Output, OutState]|X]) :- initial_state(Prog, InitialState), 
							   		      final_states(Prog, ListFinalStates), 
							   		      move2(Prog, tape([''], Input), InitialState, tape(Left, Right), OutState, ListFinalStates, X), 
							   		      fusion(Left, Right, Output), 
									      dump_to_mpost(result, [[Output, OutState]|X]).

move2(Prog, tape(Left, [Symb|Right]), CurrentState, Output, OutState, List, _) :- next(Prog, CurrentState, Symb, NewSymb, Dir, OutState), 
									      	  fin(OutState, List), 
										  update_tape(tape(Left, [Symb|Right]), NewSymb, Dir, Output).

move2(Prog, tape(Left, [Symb|Right]), CurrentState, Output, OutState, List, [[Sortie, FinalState]|X]) :- next(Prog, CurrentState, Symb, NewSymb, Dir, FinalState),
													 not fin(FinalState, List), 
									      				 update_tape(tape(Left, [Symb|Right]), NewSymb, Dir, Out), 
									      				 move2(Prog, Out, FinalState, Output, OutState, List, X), 
													 fusion(Left, Right, Sortie).


/********************************
test run_turing_machine étendu
*********************************
ne fonctionne pas non plu
*/

%write to meta post format
%compile result with: 
% mpost filename
% epstopdf filename.1
dump_to_mpost(Filename, Dump) :-
        open(Filename, write, Stream),
	        write_header(Stream),
        write_dump(0, Dump, Stream),
        write_end(Stream),
        close(Stream).

write_header(Stream) :-
        write(Stream, 'prologues := 1;\n'),
        write(Stream, 'input turing;\n'),
        write(Stream, 'beginfig(1)\n').

write_end(Stream) :-
        write(Stream, 'endfig;\n'),
        write(Stream, 'end').

write_dump(_, [], _).
write_dump(Y, [(State, Tape) | Tapes], Stream) :-
        write(Stream, 'tape(0, '),
        write(Stream, Y),
        write(Stream, 'cm, 1cm, \"'),
        write(Stream, State),
        write(Stream, '\", '),
        write_tape(Tape, Stream),
        write(Stream, ');\n'),
        Y1 is Y - 2,
        write_dump(Y1, Tapes, Stream).

write_tape(tape(Left, Right), Stream) :-
        length(Left, N),
        write(Stream, '\"'),
        append(Left, Right, L),
        (param(Stream), foreach(X, L) do 
            write(Stream, X)        
        ),
        write(Stream, '\", '),
        write(Stream, N),
        write('\n').

%%%%%%%%%%% Optional part        

%make_pairs(+, -): 'a list * ('a * 'a) list
make_pairs([], _, []).
make_pairs([X | L], L2, Res) :-
        make_pairs_aux(X, L2, Pairs),
        make_pairs(L, L2, RemainingPairs),
        append(Pairs, RemainingPairs, Res).

%make_pairs_aux(+, +, -): 'a * 'a list * ('a * 'a) list
make_pairs_aux(_, [], []).
make_pairs_aux(X, [Y | Ys], [(X, Y) | Zs]) :-
        make_pairs_aux(X, Ys, Zs).

complete(S1, Sym, Symbols, Directions, States, Res) :-
        member(Sym1, Symbols),
        member(Dir, Directions),
        member(S2, States),
        Res = delta(S1, Sym, Sym1, Dir, S2).

complete_list([], _, _, _, []).
complete_list([(S, Sym) | Pairs], Symbols, Directions, States, [Delta | Deltas]) :-
        complete(S, Sym, Symbols, Directions, States, Delta),
        complete_list(Pairs, Symbols, Directions, States, Deltas).
