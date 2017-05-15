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


%Trace from file: aim-100-2_0-no-2
main :- check(certRight([44, 43, 41, 40, 39, 38, 37, 36, 35, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 4, 3, 1, 2], 
 chains([chain(201,[18,17],or(x(12),not(x(62)))),chain(205,[26,25],or(not(x(8)),not(x(86)))),chain(206,[33,32],or(x(76),or(not(x(7)),x(24)))),chain(207,[29,28,31,206,27,43,40],or(x(62),or(x(76),or(not(x(94)),or(x(20),x(84)))))),chain(208,[24,205],or(not(x(86)),x(94))),chain(209,[29,28,31,206,23,208,37,38,39],or(not(x(54)),or(x(76),or(x(84),x(94))))),chain(210,[29,28,31,206,27,44,207,40],or(not(x(94)),or(x(76),or(x(84),x(62))))),chain(211,[12,13,11,10],or(x(28),x(82))),chain(212,[14,15,211,16,22,209,210],or(x(76),or(not(x(75)),x(62)))),chain(213,[31,30,206,23,209,37,38,39,208],or(x(76),or(x(94),not(x(54))))),chain(214,[44,43],or(not(x(24)),not(x(96)))),chain(215,[31,30,27,206,210,214,213,40,1,212],or(x(40),or(x(62),x(76)))),chain(216,[14,15,211,1,16,22],or(x(40),or(x(62),x(54)))),chain(217,[208,23,27,36,35],or(not(x(76)),or(x(24),not(x(54))))),chain(218,[37,38,39,217,40,216,214,215],or(x(62),x(40))),chain(219,[19,21,20,211],or(not(x(12)),x(82))),chain(220,[22,1,219,201,218],or(x(54),x(40))),chain(221,[29,30,28,31,206,27,214,213,41],or(x(76),or(not(x(62)),not(x(54))))),chain(222,[37,217,220,221,218,39,41,214,38],x(40)),chain(223,[2,222],or(x(58),x(54))),chain(224,[3,222],or(not(x(58)),x(69))),chain(225,[4,222],or(not(x(69)),x(95))),chain(226,[201,219,212,22,9,8,225,224,223],or(x(54),x(76))),chain(227,[31,27,213,226,214,40,221,206,30,210],x(76)),chain(230,[217,227],or(x(24),not(x(54)))),chain(231,[16,9,225,224,223,8,15,14,211,22,201,219],x(54)),chain(232,[230,231],x(24)),chain(233,[214,232],not(x(96))),chain(237,[37,232],or(x(6),x(98))),chain(238,[39,231],or(not(x(6)),x(94))),chain(239,[40,233],or(x(62),not(x(94)))),chain(240,[41,233],or(not(x(62)),not(x(94)))),chain(243,[38,239,238,237],x(62)),chain(244,[240,243],not(x(94))),chain(246,[238,244],not(x(6))),chain(249,[237,246],x(98)),chain(250,[38,244,246,249],false)])),  store([],[]), 
  unfk([or(and(x(20),x(96)),or(and(not(x(20)),x(96)),or(and(x(62),x(94)),or(and(not(x(62)),x(94)),or(and(x(6),not(x(94))),or(and(x(98),not(x(6))),or(and(not(x(6)),not(x(98))),or(and(x(93),x(77)),or(and(not(x(93)),not(x(24))),or(and(x(63),x(7)),or(and(not(x(63)),x(7)),or(and(x(4),not(x(7))),or(and(not(x(4)),not(x(7))),or(and(x(78),not(x(4))),or(and(not(x(78)),not(x(4))),or(and(not(x(24)),not(x(77))),or(and(x(36),x(8)),or(and(not(x(36)),x(8)),or(and(not(x(8)),x(86)),or(and(not(x(77)),not(x(86))),or(and(x(82),x(75)),or(and(x(43),x(28)),or(and(x(65),not(x(82))),or(and(not(x(43)),not(x(65))),or(and(x(51),not(x(12))),or(and(not(x(51)),not(x(12))),or(and(x(75),x(84)),or(and(not(x(84)),x(28)),or(and(x(28),x(75)),or(and(x(11),x(14)),or(and(not(x(14)),x(23)),or(and(x(11),not(x(23))),or(and(not(x(11)),not(x(28))),or(and(x(26),not(x(75))),or(and(not(x(26)),x(69)),or(and(x(69),not(x(95))),or(and(x(58),not(x(69))),or(and(not(x(75)),not(x(54))),and(not(x(54)),not(x(58)))))))))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
