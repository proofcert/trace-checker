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




%Trace from file: aim-100-1_6-no-2
main :- check(certRight([56, 55, 54, 53, 51, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 4, 3, 1, 2], 
 chains([chain(163,[28,27],or(x(52),x(90))),
chain(164,[30,29],or(not(x(52)),not(x(82)))),
chain(165,[25,24,23],or(x(80),x(82))),
chain(168,[51,49],or(x(67),not(x(41)))),
chain(169,[55,54],or(x(13),or(not(x(48)),not(x(8))))),
chain(171,[38,39,37],or(x(58),x(93))),
chain(173,[43,42,44],or(x(18),not(x(93)))),
chain(175,[41,40,171],or(not(x(55)),x(93))),
chain(176,[46,47,45,48],or(x(41),not(x(18)))),
chain(177,[2,1],or(x(8),x(4))),
chain(179,[35,34],or(not(x(60)),x(95))),
chain(180,[32,33,31,179,36],or(x(55),not(x(90)))),
chain(181,[26,165],or(x(82),not(x(8)))),
chain(182,[180,56,164,176,54,53,168,169,181,173,163,175,177],x(4)),
chain(183,[3,182],or(x(1),x(33))),
chain(184,[22,182],or(not(x(1)),not(x(36)))),
chain(185,[20,19,18,21],or(x(36),or(not(x(26)),not(x(20))))),
chain(186,[16,17,185,184,10],or(not(x(1)),not(x(59)))),
chain(187,[14,186,183,12,11,184,185,10,15,13],x(33)),
chain(188,[4,187],or(x(56),x(1))),
chain(190,[9,187],or(not(x(83)),not(x(70)))),
chain(193,[8,190],or(not(x(83)),not(x(56)))),
chain(194,[7,6,193],not(x(56))),
chain(195,[188,194],x(1)),
chain(196,[184,195],not(x(36))),
chain(197,[186,195],not(x(59))),
chain(198,[15,196,197],not(x(49))),
chain(199,[10,196,195],x(20)),
chain(200,[185,199,196],not(x(26))),
chain(201,[11,200,196],x(97)),
chain(202,[12,201,198],x(28)),
chain(203,[13,202,198],x(51)),
chain(204,[14,197,202,203],false)])), 
 store([],[]), 
  unfk([or(and(x(48),x(21)),or(and(x(48),x(21)),or(and(not(x(21)),x(48)),or(and(x(67),not(x(48))),or(and(x(69),x(41)),or(and(x(41),not(x(69))),or(and(x(18),x(92)),or(and(x(17),not(x(92))),or(and(not(x(17)),not(x(92))),or(and(not(x(92)),not(x(33))),or(and(x(94),x(93)),or(and(x(93),x(47)),or(and(not(x(47)),not(x(94))),or(and(x(55),x(58)),or(and(not(x(76)),x(58)),or(and(x(32),not(x(58))),or(and(not(x(32)),not(x(58))),or(and(not(x(58)),not(x(20))),or(and(x(95),x(90)),or(and(x(99),x(60)),or(and(x(60),not(x(99))),or(and(x(22),not(x(60))),or(and(x(26),not(x(22))),or(and(x(90),not(x(60))),or(and(x(34),x(82)),or(and(not(x(34)),x(82)),or(and(x(13),not(x(52))),or(and(not(x(52)),not(x(13))),or(and(x(8),x(80)),or(and(x(14),x(54)),or(and(not(x(80)),not(x(14))),or(and(not(x(54)),not(x(80))),or(and(x(1),x(36)),or(and(x(50),x(26)),or(and(x(57),x(73)),or(and(x(57),not(x(73))),or(and(x(26),not(x(57))),or(and(x(40),x(59)),or(and(not(x(40)),x(59)),or(and(x(49),not(x(36))),or(and(x(51),x(28)),or(and(not(x(51)),x(28)),or(and(not(x(28)),x(97)),or(and(not(x(97)),not(x(26))),or(and(not(x(20)),not(x(36))),or(and(x(83),x(70)),or(and(not(x(70)),x(83)),or(and(x(99),not(x(83))),or(and(not(x(99)),not(x(83))),or(and(not(x(1)),not(x(56))),or(and(not(x(1)),not(x(33))),or(and(not(x(8)),not(x(97))),and(x(97),not(x(8)))))))))))))))))))))))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
