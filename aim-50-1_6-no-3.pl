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




%Trace from file: aim-50-1_6-no-3
main :- check(certRight([32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 1, 2], 
 chains([chain(81,[18,17],or(x(13),or(x(36),not(x(1))))),
chain(82,[21,20,19,81],or(x(13),not(x(1)))),
chain(83,[30,29],or(not(x(19)),x(37))),
chain(84,[25,26],or(not(x(44)),not(x(13)))),
chain(85,[4,3],or(not(x(41)),x(7))),
chain(86,[15,13],or(x(19),not(x(20)))),
chain(87,[10,9],or(not(x(22)),x(45))),
chain(89,[6,5],or(x(50),not(x(7)))),
chain(90,[11,87,12,89,7],or(not(x(7)),x(35))),
chain(91,[32,31],or(not(x(23)),not(x(37)))),
chain(92,[11,90,87,12,89,8],not(x(7))),
chain(93,[85,92],not(x(41))),
chain(94,[1,93],or(x(15),x(20))),
chain(95,[2,93],or(not(x(15)),x(20))),
chain(96,[95,94,86,83],x(37)),
chain(97,[91,96],not(x(23))),
chain(98,[27,97],or(x(33),not(x(49)))),
chain(99,[28,97],or(not(x(33)),not(x(49)))),
chain(101,[18,16],or(x(1),or(x(36),x(13)))),
chain(102,[21,20,19,101],or(x(13),x(1))),
chain(103,[24,23,22],or(x(44),x(49))),
chain(104,[102,82,84,103,98],x(33)),
chain(105,[99,104],not(x(49))),
chain(106,[103,105],x(44)),
chain(107,[84,106],not(x(13))),
chain(108,[82,107],not(x(1))),
chain(110,[102,108,107],false)])), 
 store([],[]), 
  unfk([or(and(x(29),x(23)),or(and(not(x(29)),x(23)),or(and(x(42),x(19)),or(and(not(x(42)),x(19)),or(and(x(49),x(33)),or(and(x(49),not(x(33))),or(and(x(31),x(13)),or(and(not(x(31)),x(13)),or(and(x(17),x(4)),or(and(not(x(17)),x(4)),or(and(not(x(4)),not(x(44))),or(and(x(5),x(3)),or(and(not(x(5)),x(3)),or(and(not(x(3)),x(36)),or(and(x(14),not(x(36))),or(and(not(x(14)),not(x(36))),or(and(not(x(14)),not(x(36))),or(and(x(21),x(20)),or(and(not(x(21)),x(20)),or(and(x(33),x(50)),or(and(x(45),not(x(33))),or(and(x(18),x(22)),or(and(not(x(18)),x(22)),or(and(x(35),not(x(45))),or(and(x(50),not(x(35))),or(and(x(42),not(x(50))),or(and(not(x(42)),not(x(50))),or(and(x(8),x(41)),or(and(not(x(8)),x(41)),or(and(not(x(20)),not(x(15))),and(x(15),not(x(20)))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
