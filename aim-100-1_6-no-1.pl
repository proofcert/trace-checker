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




%Trace from file: aim-100-1_6-no-1
main :- check(certRight([48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 5, 4, 3, 1, 2], 
 chains([chain(162,[9,8],or(x(52),or(x(73),x(9)))),
chain(165,[32,31,33,46],or(not(x(84)),or(not(x(35)),or(not(x(68)),x(19))))),
chain(166,[34,31,48,47],or(not(x(35)),or(not(x(19)),not(x(68))))),
chain(168,[5,4],or(x(95),or(not(x(78)),not(x(30))))),
chain(171,[24,25],or(x(84),or(x(11),x(96)))),
chain(172,[21,22,23,20],or(x(35),or(not(x(40)),not(x(55))))),
chain(175,[27,30,171],or(x(96),or(not(x(35)),or(not(x(29)),x(84))))),
chain(177,[165,166],or(not(x(35)),or(not(x(68)),not(x(84))))),
chain(178,[35,36],or(x(68),or(x(48),x(81)))),
chain(181,[3,168,1],or(x(35),or(x(95),x(16)))),
chain(182,[16,15],or(not(x(52)),or(not(x(66)),x(73)))),
chain(185,[28,29,27,175,171],or(not(x(35)),or(x(84),x(96)))),
chain(186,[45,44],or(x(68),or(not(x(84)),not(x(3))))),
chain(189,[42,43],or(x(68),or(not(x(18)),not(x(81))))),
chain(191,[21,22,23,19,172],or(not(x(55)),x(35))),
chain(192,[162,10],or(not(x(8)),or(x(73),x(52)))),
chain(193,[7,18,192,13,11,182,181,191,12],or(x(35),or(x(83),x(16)))),
chain(194,[24,26,27,185],or(not(x(35)),or(x(23),x(84)))),
chain(195,[28,29,30,194],or(x(84),not(x(35)))),
chain(196,[38,37,178,35],or(x(68),or(x(3),x(81)))),
chain(197,[40,41,39,196,189,186,177,195],not(x(35))),
chain(198,[191,197],not(x(55))),
chain(199,[3,197],or(not(x(30)),x(78))),
chain(201,[7,198],or(x(8),not(x(95)))),
chain(205,[181,197],or(x(95),x(16))),
chain(208,[193,197],or(x(83),x(16))),
chain(209,[14,208,17,18,201,205,192,182],x(16)),
chain(210,[2,209],or(x(30),x(95))),
chain(212,[199,168,201,210],x(8)),
chain(214,[18,212],or(not(x(73)),not(x(95)))),
chain(216,[192,212],or(x(52),x(73))),
chain(217,[199,168,214,216,210],x(52)),
chain(218,[13,217],or(not(x(87)),x(83))),
chain(221,[17,217],or(x(73),not(x(74)))),
chain(222,[182,217],or(x(73),not(x(66)))),
chain(223,[199,168,210],x(95)),
chain(224,[214,223],not(x(73))),
chain(226,[221,224],not(x(74))),
chain(227,[222,224],not(x(66))),
chain(228,[14,226,227],not(x(83))),
chain(229,[218,228],not(x(87))),
chain(230,[11,228,227],x(38)),
chain(231,[12,228,229,230],false)])), 
 store([],[]), 
  unfk([or(and(x(70),x(74)),or(and(x(19),x(68)),or(and(x(70),not(x(19))),or(and(x(84),x(77)),or(and(not(x(77)),x(3)),or(and(x(47),x(18)),or(and(not(x(47)),x(18)),or(and(not(x(3)),not(x(18))),or(and(x(7),not(x(56))),or(and(x(81),not(x(18))),or(and(not(x(3)),x(48)),or(and(not(x(93)),x(48)),or(and(not(x(48)),x(22)),or(and(not(x(22)),not(x(81))),or(and(x(54),not(x(70))),or(and(not(x(19)),x(84)),or(and(x(54),not(x(70))),or(and(not(x(54)),not(x(70))),or(and(x(23),x(29)),or(and(x(65),not(x(29))),or(and(x(23),not(x(29))),or(and(x(11),not(x(23))),or(and(x(75),not(x(23))),or(and(x(75),not(x(11))),or(and(not(x(75)),not(x(11))),or(and(x(82),x(90)),or(and(not(x(82)),x(90)),or(and(not(x(25)),not(x(82))),or(and(not(x(90)),x(40)),or(and(not(x(90)),not(x(40))),or(and(x(73),x(95)),or(and(not(x(73)),x(74)),or(and(not(x(73)),x(89)),or(and(x(66),not(x(89))),or(and(x(83),not(x(74))),or(and(x(87),not(x(83))),or(and(x(38),not(x(87))),or(and(not(x(38)),not(x(83))),or(and(x(9),not(x(52))),or(and(not(x(9)),x(100)),or(and(not(x(100)),not(x(9))),or(and(x(95),not(x(8))),or(and(x(85),x(78)),or(and(not(x(85)),x(78)),or(and(not(x(78)),x(30)),or(and(not(x(30)),not(x(95))),and(not(x(30)),not(x(95)))))))))))))))))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
