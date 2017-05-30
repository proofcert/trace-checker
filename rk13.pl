% for format: wiki 

%true focused
check(_,_,foc(true)).
check(_,_,unfk([true|_])).

%false
check(Cert,SL,unfk([false|Gamma])) :- check(Cert,SL,unfk(Gamma)).

%init... P should be a positive atom
check(_,store(SL,NL),foc(x(P))) :-    member(not(x(P)),NL).

%release N is a negative literal or formula
check(certLeft(DL),SL,foc(Formula)) :- 
    isNegative(Formula),
    check(certLeft(DL),SL,unfk([Formula])).

%cut rule
check(certRight([],chains([chain(StoreDex, DL, Cut)|RestChains])),  SL,  unfk([])) :-  %called when nothing unfk, all storable formulas have been stored
    negate(Cut,NCut),   %this ensures cut rule fails on left branch, as an integer in DL can't be negated. however it will not match at all now if I wrap the Chainlist in chains(...)
    check(certLeft([-1|DL]),SL,unfk([Cut])), 
    check(certRight([StoreDex],chains(RestChains)),SL,unfk([NCut])). 

%decide. P is positive atom or formula
check(certLeft(DL),store(SL,NL),unfk([])) :- %only can decide on -1 once each branch. 
    select(I,DL,DL1),
    select((I,F),SL,SL1), isPositive(F), 
    check(certLeft(DL1),store(SL1,NL),foc(F)).

%store.. works if C is either a positive formula or negative atom. this is negative atom case
check(certRight([I|Rest],Chains),store(SL,NL),unfk([not(x(P))|Gamma])) :-
    check(certRight(Rest,Chains),store(SL,[not(x(P))|NL]),unfk(Gamma)). 
    
%this is positive formula case
check(certRight([I|Rest],Chains), store(SL,NL), unfk([Formula|Gamma])) :-
    isPositive(Formula), 
    check(certRight(Rest,Chains), store([(I,Formula)|SL],NL), unfk(Gamma)).
    
% store but case where formulas should be stored at -1
check(certLeft(DL),store(SL,NL),unfk([not(x(P))|Gamma])) :-
    check(certLeft(DL),store(SL,[not(x(P))|NL]),  unfk(Gamma)). 
check(certLeft(DL),store(SL,NL),unfk([Formula|Gamma])) :-
    isPositive(Formula), 
    check(certLeft(DL),store([(-1,Formula)|SL],NL),   unfk(Gamma)).
    
    
    
%and focused
check(certLeft(DL),SL,foc(and(A,B))) :-
    check(certLeft(DL),SL,foc(A)), check(certLeft(DL),SL,foc(B)).
        
    
%and unfocused
%check(certLeft(DL),SL,unfk([and(A,B)|Gamma])) :- 
%    check(certLeft(DL),SL,unfk([A|Gamma])),
%    check(certLeft(DL),SL,unfk([B|Gamma])).
    
%or focused
%check(Cert,SL,foc(or(A,B))) :- check(DL,SL,foc(A)).
%check(certLeft(DL),SL,foc(or(A,B))) :- check(DL,SL,foc(B)).
    
%or unfocused
check(Cert,SL,unfk([or(A,B)|Gamma])) :- %here cert could be left or right
    check(Cert,SL,unfk([A,B|Gamma])). 



isPositive(and(_,_)).
isPositive(x(_)). 

isNegative(not(x(_))).
isNegative(or(_,_)).

negate(x(P),not(x(P))).
negate(not(x(P)),x(P)).
negate(or(A,B), and(NA,NB)) :- negate(A,NA), negate(B,NB).  
negate(and(A,B), or(NA,NB)) :- negate(A,NA), negate(B,NB).
negate(true,false). 
negate(false,true).


%!!!end of checker code !!!


%Trace from file: ../booleforce-1.2/traces/rksat13
main :- check(certRight([94, 90, 85, 82, 80, 75, 69, 67, 66, 60, 59, 54, 53, 52, 51, 50, 49, 48, 45, 43, 36, 35, 30, 29, 26, 24, 21, 17, 11, 1, 9], 
 chains([chain(100,[1,52,60,49,66,75,80,69],or(x(7),or(not(x(11)),x(3)))),
chain(101,[11,54,67,53,59,100],or(x(3),x(7))),
chain(102,[82,80,51,101,29],or(x(14),x(7))),
chain(103,[48,50,101,66,102,45,30,24],x(7)),
chain(105,[9,103],or(not(x(11)),x(13))),
chain(106,[26,103],or(x(3),x(12))),
chain(107,[35,103],or(x(1),x(14))),
chain(108,[36,103],or(not(x(12)),not(x(15)))),
chain(112,[90,103],or(not(x(5)),not(x(13)))),
chain(113,[85,105,53,106,52,108],x(3)),
chain(115,[21,113],or(x(2),x(5))),
chain(119,[43,113],or(not(x(1)),x(14))),
chain(126,[94,113],or(not(x(2)),x(5))),
chain(127,[107,119],x(14)),
chain(129,[17,127],or(not(x(5)),x(11))),
chain(139,[126,115],x(5)),
chain(140,[129,139],x(11)),
chain(142,[112,139],not(x(13))),
chain(145,[105,142,140],false)])), 
 store([],[]), 
  unfk([or(and(x(2),not(x(5))),or(and(x(5),x(13)),or(and(not(x(4)),x(13)),or(and(not(x(9)),not(x(10))),or(and(x(9),x(5)),or(and(not(x(4)),not(x(8))),or(and(x(4),x(15)),or(and(x(8),not(x(11))),or(and(not(x(13)),x(14)),or(and(not(x(5)),not(x(8))),or(and(x(1),not(x(11))),or(and(not(x(1)),not(x(11))),or(and(not(x(11)),not(x(3))),or(and(x(4),not(x(15))),or(and(x(5),x(10)),or(and(x(8),x(13)),or(and(not(x(9)),x(13)),or(and(x(6),not(x(8))),or(and(not(x(4)),x(15)),or(and(x(1),not(x(14))),or(and(x(12),x(15)),or(and(not(x(1)),not(x(14))),or(and(x(4),x(13)),or(and(not(x(5)),not(x(14))),or(and(not(x(3)),not(x(12))),or(and(not(x(6)),not(x(8))),or(and(not(x(2)),not(x(5))),or(and(x(5),not(x(11))),or(and(not(x(8)),not(x(12))),or(and(x(8),x(11)),and(x(11),not(x(13)))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
