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
decidee(certLeft(1,DL), certLeft(0,DL), -1). %the one chance to decide on -1
decidee(certLeft(1,[I|Rest]), certLeft(1,Rest), I). 
decidee(certLeft(0,[I|Rest]),certLeft(0,Rest), I).
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

%Trace from file: booleforce-1.2/traces/readme
main :- check(certRight([4, 3, 1, 2], 
 chains([chain(5,[3,1],x(1)),
chain(6,[5,4,2],false)])), 
 store([],[]), 
  unfk([or(and(x(1),x(2)),or(and(not(x(1)),x(2)),or(and(not(x(1)),not(x(2))),and(x(1),not(x(2))))))])), print(1), nl ;  
 print(0),nl, fail. 
