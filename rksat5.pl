:- discontiguous check/3.

%true focused
check(_,_,foc(true)). 
check(_,_,unfk([true|_])).

%false
check(Cert,Store,unfk([false|Gamma])) :- check(Cert,Store,unfk(Gamma)).

%init naive
check(Cert,store(_,NL),foc(x(P))) :- inite(Cert), member(not(x(P)),NL).
inite(_).



%release N is a negative literal or formula
check(Cert,SL,foc(Formula)) :- 
    isNegative(Formula),
    releasee(Cert,Cert1),
    check(Cert1,SL,unfk([Formula])).
releasee(certLeft(X,DL),certLeft(X,DL)).


%cut naive
check(Cert,Store,unfk([])) :- 
    cute(Cert,Cert1,Cert2,Formula),
    negate(Formula,NFormula),
    check(Cert1,Store,unfk([Formula])),
    check(Cert2,Store,unfk([NFormula])).
cute(certRight([],chains([chain(StoreDex, DL, Formula)|RestChains])),certLeft(1,DL),
certRight([StoreDex],chains(RestChains)),Formula).


%decide naive
check(Cert,store(SL,NL),unfk([])) :- 
    decidee(Cert,Cert1,Index),
    member((Index,Formula),SL), isPositive(Formula),
    check(Cert1,store(SL,NL),foc(Formula)).
decidee(certLeft(1,[I|Rest]), certLeft(1,Rest), I). 
decidee(certLeft(0,[I|Rest]),certLeft(0,Rest), I).
decidee(certLeft(1,DL), certLeft(0,DL), -1). %the one chance to decide on -1

%added an additional case because we won't necessarily always be able to decide on -1 before deciding on any ofthe DL things

%and focused
check(Cert,SL,foc(and(A,B))) :-
    ande(Cert,Cert1,Cert2),
    check(Cert1,SL,foc(A)), check(Cert2,SL,foc(B)).
ande(certLeft(X,DL),certLeft(X,DL),certLeft(X,DL)).


%or unfocused
check(Cert,SL,unfk([or(A,B)|Gamma])) :- %here cert could be left or right
    ore(Cert,Cert1),
    check(Cert1,SL,unfk([A,B|Gamma])). 
ore(Cert,Cert).


  
%store negative atom
check(Cert,store(SL,NL),unfk([not(x(P))|Gamma])) :- 
    storee(Cert,Cert1,_), 
    check(Cert1,store(SL,[not(x(P))|NL]),unfk(Gamma)).

%store positive formula    
check(Cert,store(SL,NL),unfk([C|Gamma])) :- 
    isPositive(C),
    storee(Cert,Cert1,Index),
    check(Cert1,store([(Index,C)|SL],NL),unfk(Gamma)).
storee(certRight([I|Rest],Chains),certRight(Rest,Chains),I).  
storee(certLeft(X,DL),certLeft(X,DL),-1).

  
  
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

%Trace from file: rksat5
main :- check(certRight([99, 98, 79, 75, 72, 57, 45, 44, 35, 31, 27, 22, 15, 14, 13, 3, 5], 
 chains([chain(100,[5,75,14],or(not(x(5)),x(9))),
chain(101,[44,27,100,79,99,72,15],x(9)),
chain(103,[22,101],or(not(x(7)),x(6))),
chain(107,[45,101],or(x(7),not(x(6)))),
chain(113,[98,101],or(x(7),not(x(10)))),
chain(114,[57,113,31,107],x(7)),
chain(115,[103,114],x(6)),
chain(116,[3,115],or(x(4),x(5))),
chain(117,[5,114],or(not(x(5)),x(8))),
chain(118,[13,114],or(x(10),not(x(13)))),
chain(121,[35,115],or(not(x(10)),not(x(13)))),
chain(132,[99,114],or(not(x(8)),x(13))),
chain(133,[72,117,116],x(8)),
chain(135,[132,133],x(13)),
chain(140,[118,135],x(10)),
chain(141,[121,135,140],false)])), 
 store([],[]), 
  unfk([or(and(x(8),not(x(13))),or(and(not(x(7)),x(10)),or(and(x(13),not(x(5))),or(and(not(x(7)),x(5)),or(and(x(4),not(x(5))),or(and(not(x(11)),not(x(10))),or(and(x(6),not(x(7))),or(and(not(x(7)),x(10)),or(and(x(10),x(13)),or(and(x(11),not(x(10))),or(and(not(x(5)),not(x(10))),or(and(not(x(6)),x(7)),or(and(not(x(4)),not(x(5))),or(and(x(5),x(8)),or(and(not(x(10)),x(13)),or(and(not(x(4)),not(x(5))),and(x(5),not(x(8)))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
