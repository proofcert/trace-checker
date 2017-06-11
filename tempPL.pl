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


%Trace from file: ../booleforce-1.2/traces/aim100-2no4
main :- check(certRight([34, 33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 4, 3, 1, 2], 
 chains([chain(207,[34,33],or(not(x(11)),or(not(x(20)),not(x(12))))),
chain(209,[21,19,18,25],or(not(x(85)),x(12))),
chain(215,[13,14,15],or(x(16),or(x(40),not(x(80))))),
chain(216,[6,7,1,2],or(x(37),or(x(11),x(47)))),
chain(217,[10,9,11,12],or(not(x(97)),or(not(x(47)),x(80)))),
chain(218,[13,14,16,217,17,215,216],or(x(37),or(x(11),not(x(97))))),
chain(219,[31,30,34,207],or(not(x(11)),or(not(x(49)),not(x(12))))),
chain(220,[21,19,18,219,24,209,23,218,27],or(x(37),or(x(14),not(x(97))))),
chain(221,[10,11,8,12],or(x(97),or(not(x(47)),x(80)))),
chain(222,[13,14,16,221,17,215,216],or(x(37),or(x(11),x(97)))),
chain(223,[18,22,19,219,220,21,26,222,27,209],or(x(14),x(37))),
chain(224,[222,218],or(x(11),x(37))),
chain(225,[19,18,26,22,209],or(not(x(11)),or(x(97),or(x(12),x(16))))),
chain(226,[29,28,219],or(not(x(11)),or(not(x(14)),not(x(12))))),
chain(227,[20,26,21,225,22,209],or(not(x(11)),or(x(12),x(97)))),
chain(228,[21,226,223,224,18,24,209,23,227,19],x(37)),
chain(229,[3,228],or(x(45),x(62))),
chain(230,[4,228],or(not(x(45)),x(62))),
chain(232,[18,19],or(x(16),or(x(93),x(12)))),
chain(233,[230,229],x(62)),
chain(234,[6,233],or(x(38),x(47))),
chain(235,[7,233],or(not(x(38)),x(11))),
chain(237,[14,13,16,215],or(x(40),not(x(80)))),
chain(238,[221,234,235,237,17,217],x(11)),
chain(240,[27,238],or(x(14),x(49))),
chain(245,[219,238],or(not(x(12)),not(x(49)))),
chain(247,[226,238],or(not(x(12)),not(x(14)))),
chain(248,[227,238],or(x(12),x(97))),
chain(249,[240,245,248,247],x(97)),
chain(251,[23,249],or(x(52),x(85))),
chain(256,[24,232,209,251],or(x(12),x(16))),
chain(257,[240,245,256,247],x(16)),
chain(259,[20,257],or(x(19),x(93))),
chain(260,[21,257],or(not(x(19)),x(12))),
chain(261,[251,209,24,259,260],x(12)),
chain(264,[245,261],not(x(49))),
chain(265,[247,261],not(x(14))),
chain(267,[240,264,265],false)])), 
 store([],[]), 
  unfk([or(and(x(12),x(79)),or(and(x(20),not(x(79))),or(and(x(57),x(49)),or(and(not(x(57)),x(49)),or(and(x(3),x(14)),or(and(not(x(3)),not(x(49))),or(and(not(x(14)),not(x(49))),or(and(x(81),x(93)),or(and(x(85),x(93)),or(and(x(52),not(x(85))),or(and(not(x(85)),not(x(52))),or(and(not(x(81)),not(x(85))),or(and(x(19),not(x(12))),or(and(not(x(19)),not(x(93))),or(and(x(19),not(x(93))),or(and(not(x(93)),not(x(19))),or(and(x(40),x(47)),or(and(x(96),x(80)),or(and(x(96),not(x(40))),or(and(x(52),not(x(96))),or(and(not(x(52)),not(x(96))),or(and(x(39),x(47)),or(and(x(20),not(x(39))),or(and(not(x(80)),x(92)),or(and(not(x(92)),not(x(20))),or(and(not(x(92)),not(x(80))),or(and(x(38),not(x(11))),or(and(not(x(38)),not(x(47))),or(and(x(45),not(x(62))),or(and(not(x(45)),not(x(62))),or(and(not(x(62)),not(x(87))),and(x(87),not(x(47))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
