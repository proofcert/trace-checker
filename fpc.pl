%store expert
%negative atom case
storee(certRight([I|Rest],Chains),certRight(Rest,Chains),store(SL,NL),store(SL,[not(x(P))|NL]),
  [not(x(P))|Gamma],Gamma).
%positive formula case
storee(certRight([I|Rest],Chains),certRight(Rest,Chains),store(SL,NL),store([(I,Formula)|SL],NL),[Formula|Gamma],Gamma) :-
    isPositive(Formula).
%negative atom case storing at -1
storee(certLeft(DL),certLeft(DL),store(SL,NL),store(SL,[not(x(P))|NL]),[not(x(P))|Gamma],Gamma).
%positive formula case storing at -1
storee(certLeft(DL),certLeft(DL),store(SL,NL),store([(-1,Formula)|SL],NL),[Formula|Gamma],Gamma) :-
    isPositive(Formula).
    
%decide expert
decidee(certLeft(DL),certLeft(DL1),store(SL,NL),store(SL1,NL),Formula) :-
    select(I,DL,DL1), 
    select((I,Formula),SL,SL1), isPositive(Formula).
    
%cut expert
cute(certRight([],chains([chain(StoreDex, DL, Formula)|RestChains])),certLeft([-1|DL]),
certRight([StoreDex],chains(RestChains)),Formula,NFormula) :-
    negate(Formula,NFormula).
    
%init expert
inite(store(SL,NL),x(P)) :- member(not(x(P)),NL).

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