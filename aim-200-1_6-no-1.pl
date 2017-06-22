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




%Trace from file: aim-200-1_6-no-1
main :- check(certRight([70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 1, 6], 
 chains([chain(323,[18,17],or(x(74),not(x(87)))),
chain(324,[34,33],or(not(x(102)),x(66))),
chain(325,[67,66,60,62],or(x(79),or(x(51),x(143)))),
chain(326,[69,68,70],or(not(x(8)),not(x(79)))),
chain(328,[20,21,19,323],or(not(x(87)),not(x(174)))),
chain(329,[40,41],or(not(x(192)),or(x(8),x(87)))),
chain(330,[32,324],or(x(66),x(115))),
chain(331,[36,37,35,330],or(x(115),x(192))),
chain(332,[39,38,331],x(192)),
chain(335,[329,332],or(x(8),x(87))),
chain(338,[64,63],or(x(79),or(x(93),not(x(143))))),
chain(339,[23,22],or(not(x(43)),x(161))),
chain(340,[8,9,10,12,7,6,1,11,13,14,15],or(x(43),x(174))),
chain(341,[61,325,62],or(x(143),x(79))),
chain(342,[340,339,16,65,338,66,341,326,335],or(x(87),x(188))),
chain(343,[338,65,341,66,339,340,328,342],or(x(79),x(188))),
chain(345,[26,27,29,30,31,25,24],or(x(14),not(x(161)))),
chain(347,[45,44],or(x(28),x(116))),
chain(348,[52,50,49,51],or(not(x(118)),not(x(116)))),
chain(349,[47,48,46,348],or(not(x(116)),x(180))),
chain(350,[55,54,53,58,57],or(not(x(58)),or(x(169),not(x(28))))),
chain(351,[43,42],or(x(180),or(x(58),not(x(14))))),
chain(352,[349,345,343,326,340,59,57,347,56,339,350,58,328,351,342],x(188)),
chain(353,[67,352],or(not(x(16)),x(79))),
chain(355,[16,65,353,338,341,340,339,328],x(79)),
chain(356,[326,355],not(x(8))),
chain(358,[335,356],x(87)),
chain(360,[328,358],not(x(174))),
chain(363,[340,360],x(43)),
chain(364,[339,363],x(161)),
chain(365,[345,364],x(14)),
chain(366,[59,365,356],not(x(180))),
chain(367,[351,365,366],x(58)),
chain(368,[349,366],not(x(116))),
chain(369,[347,368],x(28)),
chain(370,[57,369,367],x(27)),
chain(371,[350,369,367],x(169)),
chain(372,[58,370,369],not(x(95))),
chain(373,[56,369,371,372],false)])), 
 store([],[]), 
  unfk([or(and(x(60),x(8)),or(and(x(39),not(x(60))),or(and(not(x(39)),not(x(60))),or(and(x(16),not(x(79))),or(and(x(16),not(x(79))),or(and(x(93),not(x(16))),or(and(x(129),not(x(93))),or(and(not(x(129)),not(x(93))),or(and(x(120),not(x(143))),or(and(x(51),not(x(120))),or(and(not(x(51)),not(x(120))),or(and(x(180),x(14)),or(and(x(95),x(27)),or(and(not(x(27)),x(28)),or(and(not(x(95)),x(169)),or(and(x(25),x(107)),or(and(not(x(25)),x(107)),or(and(not(x(107)),not(x(95))),or(and(x(49),x(179)),or(and(x(155),x(49)),or(and(not(x(155)),x(49)),or(and(not(x(49)),x(118)),or(and(x(35),x(57)),or(and(x(35),not(x(57))),or(and(not(x(35)),not(x(118))),or(and(x(38),not(x(28))),or(and(not(x(38)),not(x(28))),or(and(x(6),not(x(58))),or(and(not(x(6)),not(x(58))),or(and(x(149),not(x(8))),or(and(not(x(149)),not(x(87))),or(and(x(188),x(115)),or(and(not(x(188)),x(115)),or(and(x(141),x(146)),or(and(not(x(141)),x(146)),or(and(not(x(146)),x(66)),or(and(x(163),x(102)),or(and(not(x(163)),x(102)),or(and(not(x(102)),not(x(66))),or(and(x(110),x(189)),or(and(not(x(189)),x(190)),or(and(x(110),x(122)),or(and(not(x(122)),x(132)),or(and(not(x(122)),not(x(132))),or(and(not(x(189)),not(x(190))),or(and(not(x(110)),not(x(14))),or(and(x(6),not(x(161))),or(and(not(x(6)),not(x(161))),or(and(x(124),x(74)),or(and(x(174),not(x(124))),or(and(not(x(159)),x(74)),or(and(x(3),not(x(74))),or(and(not(x(3)),not(x(74))),or(and(not(x(87)),x(174)),or(and(x(175),x(172)),or(and(not(x(175)),x(172)),or(and(x(130),x(172)),or(and(x(123),not(x(130))),or(and(not(x(123)),not(x(130))),or(and(x(68),x(48)),or(and(x(68),x(135)),or(and(not(x(135)),not(x(144))),or(and(not(x(68)),not(x(144))),or(and(not(x(169)),not(x(43))),and(not(x(172)),not(x(43)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
