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




%Trace from file: aim-50-1_6-no-4
main :- check(certRight([22, 21, 20, 19, 18, 17, 16, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 1, 2], 
 chains([chain(83,[9,5],or(x(43),or(not(x(3)),not(x(32))))),
chain(85,[2,4],or(x(32),or(not(x(34)),x(4)))),
chain(87,[3,85,4],or(x(32),not(x(34)))),
chain(88,[8,5,83],or(x(1),or(x(43),not(x(32))))),
chain(90,[87,1],or(x(32),x(1))),
chain(91,[7,6],or(not(x(32)),or(not(x(43)),x(29)))),
chain(92,[90,9,8,88,91],x(1)),
chain(93,[10,92],or(x(24),x(39))),
chain(94,[11,92],or(x(24),not(x(39)))),
chain(96,[94,93],x(24)),
chain(97,[12,96],or(x(7),x(18))),
chain(98,[16,96],or(x(18),not(x(28)))),
chain(99,[22,21,17,18],or(not(x(18)),x(40))),
chain(100,[13,97,98],x(18)),
chain(101,[99,100],x(40)),
chain(102,[19,101],or(x(2),x(39))),
chain(103,[20,101],or(x(2),not(x(39)))),
chain(104,[21,100],or(not(x(2)),x(35))),
chain(105,[22,100],or(not(x(2)),not(x(35)))),
chain(107,[103,102,104],x(35)),
chain(108,[105,107],not(x(2))),
chain(109,[102,108],x(39)),
chain(110,[103,109,108],false)])), 
 store([],[]), 
  unfk([or(and(x(35),x(2)),or(and(not(x(35)),x(2)),or(and(x(39),not(x(2))),or(and(not(x(2)),not(x(39))),or(and(x(17),not(x(40))),or(and(not(x(2)),not(x(17))),or(and(x(28),not(x(18))),or(and(x(7),not(x(18))),or(and(not(x(7)),not(x(18))),or(and(not(x(24)),x(39)),or(and(not(x(24)),not(x(39))),or(and(x(3),x(29)),or(and(not(x(3)),x(29)),or(and(x(36),x(32)),or(and(x(43),not(x(36))),or(and(x(32),not(x(29))),or(and(x(34),x(5)),or(and(x(4),not(x(5))),or(and(not(x(32)),not(x(34))),and(not(x(5)),not(x(4))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
