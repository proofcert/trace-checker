% for format: wiki 

%true focused
check(_,_,foc(true)).
check(_,_,unfk([true|_])).

%false
check(Cert,SL,unfk([false|Gamma])) :- check(Cert,SL,unfk(Gamma)).

%init... P should be a positive atom
check(_,store(_,NL),foc(x(P))) :-    member(not(x(P)),NL).

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
check(certRight([_|Rest],Chains),store(SL,NL),unfk([not(x(P))|Gamma])) :-
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


%Trace from file: ../booleforce-1.2/traces/comp
main :- check(certRight([8, 7, 6, 5, 4, 3, 1, 2], 
 chains([chain(9,[1,4,5],or(x(4),x(1))),
chain(10,[9,8,3,1],x(1)),
chain(11,[2,10],or(not(x(2)),x(3))),
chain(12,[6,10],or(not(x(3)),not(x(4)))),
chain(13,[7,10],or(x(2),x(4))),
chain(14,[13,12,4],not(x(3))),
chain(15,[11,14],not(x(2))),
chain(16,[13,15],x(4)),
chain(17,[3,14,15,16],false)])), 
 store([],[]), 
  unfk([or(and(x(2),x(4)),or(and(not(x(2)),not(x(4))),or(and(x(3),x(4)),or(and(not(x(3)),not(x(4))),or(and(x(2),x(3)),or(and(x(4),not(x(2))),or(and(x(3),not(x(2))),and(x(2),not(x(3))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
