%init expert
inite(_).

releasee(certLeft(DL,A),certLeft(DL,A)).

%cut expert
cute(certRight([],chains([chain(StoreDex, DL, Formula)|RestChains])),
  certLeft(DL,1),
  certRight([StoreDex],chains(RestChains)),Formula).

%decide expert
decidee(certLeft(DL,1),certLeft(DL,0),-1).
decidee(certLeft(DL,A),certLeft(DL1,A),I) :- select(I,DL,DL1).

ande(certLeft(DL,A),certLeft(DL,A),certLeft(DL,A)).

ore(Cert,Cert).

%store expert
storee(certRight([I|Rest],Chains),certRight(Rest,Chains),I).
storee(certLeft(DL,A),certLeft(DL,A),-1).

%!!!END OF FPC CODE!!!

%true focused
check(_,_,foc(true)).
check(_,_,unfk([true|_])).

%false
check(Cert,Store,unfk([false|Gamma])) :- check(Cert,Store,unfk(Gamma)).

%init naive
check(Cert,store(_,NL),foc(x(P))) :- inite(Cert), member(not(x(P)),NL).


%release N is a negative literal or formula
check(Cert,SL,foc(Formula)) :-
    isNegative(Formula),
    releasee(Cert,Cert1),
    check(Cert1,SL,unfk([Formula])).

%cut naive
check(Cert,Store,unfk([])) :-
    cute(Cert,Cert1,Cert2,Formula),
    negate(Formula,NFormula),
    check(Cert1,Store,unfk([Formula])),
    check(Cert2,Store,unfk([NFormula])).


%decide naive
check(Cert,store(SL,NL),unfk([])) :-
    decidee(Cert,Cert1,Index),
    member((Index,Formula),SL), isPositive(Formula),
    check(Cert1,store(SL,NL),foc(Formula)).


%and focused
check(Cert,SL,foc(and(A,B))) :-
    ande(Cert,Cert1,Cert2),
    check(Cert1,SL,foc(A)), check(Cert2,SL,foc(B)).

%or unfocused
check(Cert,SL,unfk([or(A,B)|Gamma])) :- %here cert could be left or right
    ore(Cert,Cert1),
    check(Cert1,SL,unfk([A,B|Gamma])).


%store negative atom
check(Cert,store(SL,NL),unfk([not(x(P))|Gamma])) :-
    storee(Cert,Cert1,_),
    check(Cert1,store(SL,[not(x(P))|NL]),unfk(Gamma)).

%store positive formula
check(Cert,store(SL,NL),unfk([C|Gamma])) :-
    isPositive(C),
    storee(Cert,Cert1,Index),
    check(Cert1,store([(Index,C)|SL],NL),unfk(Gamma)).



%helper predicates

negate(x(P),not(x(P))).
negate(not(x(P)),x(P)).
negate(or(A,B), and(NA,NB)) :- negate(A,NA), negate(B,NB).
negate(and(A,B), or(NA,NB)) :- negate(A,NA), negate(B,NB).
negate(true,false).
negate(false,true).

isPositive(and(_,_)).
isPositive(x(_)).

isNegative(not(x(_))).
isNegative(or(_,_)).

%!!!!!!END OF CHECKER CODE!!!!!




%Trace from file: aim-50-2_0-no-1
main :- check(certRight([27, 26, 25, 24, 23, 22, 21, 18, 17, 16, 15, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 1, 2], 
 chains([chain(101,[6,5],or(not(x(48)),or(not(x(16)),x(25)))),
chain(103,[23,22,25],or(not(x(20)),or(x(41),x(50)))),
chain(105,[11,12,17,21,15],or(x(20),or(not(x(19)),or(x(24),x(48))))),
chain(106,[27,26],or(not(x(19)),or(not(x(41)),not(x(20))))),
chain(107,[24,22,103,25,106],or(not(x(19)),not(x(20)))),
chain(108,[11,107,12,7,18,4,15,3,1,101,21,105],or(not(x(27)),x(7))),
chain(110,[17,18],or(not(x(34)),not(x(44)))),
chain(111,[12,21,1,2,108,107,110,16,11],x(7)),
chain(112,[9,111],or(not(x(36)),x(49))),
chain(113,[10,111],or(not(x(49)),x(19))),
chain(115,[8,113,112],x(19)),
chain(116,[107,115],not(x(20))),
chain(118,[16,116,115],x(34)),
chain(119,[21,116,115],not(x(4))),
chain(120,[110,118],not(x(44))),
chain(121,[11,119,120],x(12)),
chain(122,[12,120,119,121],false)])), 
 store([],[]), 
  unfk([or(and(x(32),x(41)),or(and(not(x(32)),x(41)),or(and(x(39),not(x(41))),or(and(x(30),x(50)),or(and(x(30),not(x(39))),or(and(not(x(30)),not(x(39))),or(and(x(4),not(x(20))),or(and(x(24),x(44)),or(and(not(x(24)),x(44)),or(and(not(x(34)),not(x(20))),or(and(not(x(34)),not(x(48))),or(and(x(12),not(x(4))),or(and(not(x(12)),not(x(4))),or(and(not(x(19)),x(49)),or(and(x(36),not(x(49))),or(and(not(x(36)),not(x(49))),or(and(x(16),x(25)),or(and(x(17),not(x(25))),or(and(not(x(17)),x(16)),or(and(not(x(25)),x(11)),or(and(not(x(16)),x(27)),or(and(not(x(19)),not(x(11))),and(x(11),not(x(27)))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
