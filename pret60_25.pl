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


%Trace from file: pret60_25
main :- check(certRight([160, 159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 149, 148, 147, 146, 145, 144, 143, 142, 141, 140, 139, 138, 137, 136, 135, 134, 133, 132, 131, 130, 129, 128, 127, 126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112, 111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 1, 2], 
 chains([chain(169,[20,63,58],or(x(42),or(x(13),or(x(41),not(x(43)))))),
chain(170,[19,60,61,169],or(x(42),or(x(13),not(x(43))))),
chain(175,[17,59,63],or(not(x(43)),or(x(41),or(not(x(13)),not(x(42)))))),
chain(179,[18,62,58],or(x(43),or(x(42),or(x(41),not(x(13)))))),
chain(181,[18,61,57,175],or(not(x(42)),or(not(x(13)),not(x(43))))),
chain(188,[19,59,62],or(x(13),or(x(43),or(x(41),not(x(42)))))),
chain(216,[20,57,64,188],or(not(x(42)),or(x(13),x(43)))),
chain(222,[17,60,64,179],or(x(42),or(not(x(13)),x(43)))),
chain(262,[52,154,157],or(x(37),or(x(43),or(x(59),x(60))))),
chain(263,[51,155,159,262],or(x(43),or(x(37),x(59)))),
chain(265,[105,110,36],or(x(51),or(x(25),or(not(x(26)),not(x(42)))))),
chain(271,[108,35,111,265],or(not(x(42)),or(x(25),x(51)))),
chain(273,[132,43,135],or(x(31),or(x(55),or(x(32),not(x(48)))))),
chain(274,[129,134,44,273],or(not(x(48)),or(x(31),x(55)))),
chain(275,[86,26,84],or(not(x(19)),or(x(46),or(x(21),x(48))))),
chain(277,[28,82,88],or(x(48),or(not(x(46)),or(x(47),x(19))))),
chain(278,[27,85,84,277],or(x(48),or(x(19),not(x(46))))),
chain(281,[87,25,82,275],or(x(48),or(not(x(19)),x(46)))),
chain(309,[136,131,44],or(x(31),or(x(48),or(x(33),not(x(55)))))),
chain(310,[133,130,43,309],or(x(48),or(not(x(55)),x(31)))),
chain(311,[83,87,27],or(x(19),or(not(x(48)),or(x(20),x(46))))),
chain(312,[81,86,28,311],or(not(x(48)),or(x(19),x(46)))),
chain(321,[81,88,26],or(not(x(19)),or(not(x(48)),or(not(x(46)),x(20))))),
chain(336,[83,25,85,321],or(not(x(48)),or(not(x(19)),not(x(46))))),
chain(382,[151,4,147],or(not(x(59)),or(x(1),or(x(3),x(40))))),
chain(383,[150,3,145,382],or(x(1),or(x(40),not(x(59))))),
chain(404,[42,134,130],or(x(55),or(x(48),or(x(56),not(x(31)))))),
chain(406,[41,136,132],or(not(x(31)),or(not(x(48)),or(x(56),not(x(55)))))),
chain(414,[50,153,159],or(not(x(37)),or(not(x(43)),or(not(x(60)),x(59))))),
chain(415,[49,156,157,414],or(not(x(43)),or(not(x(37)),x(59)))),
chain(416,[68,71,22],or(x(17),or(x(10),or(x(13),not(x(16)))))),
chain(418,[152,4,148],or(x(1),or(not(x(40)),or(x(3),x(59))))),
chain(419,[149,3,146,418],or(x(1),or(not(x(40)),x(59)))),
chain(420,[51,158,156],or(not(x(43)),or(not(x(59)),or(x(60),x(37))))),
chain(421,[52,160,153,420],or(not(x(43)),or(x(37),not(x(59))))),
chain(422,[67,72,21,416,222,55,421],or(x(42),or(not(x(59)),or(x(10),or(x(37),not(x(40))))))),
chain(423,[50,154,158],or(not(x(37)),or(not(x(59)),or(x(60),x(43))))),
chain(424,[49,155,160,423],or(x(43),or(not(x(37)),not(x(59))))),
chain(425,[24,70,68],or(x(16),or(not(x(13)),or(x(44),x(10))))),
chain(433,[66,71,23],or(x(17),or(not(x(10)),or(x(13),x(16))))),
chain(437,[53,421,433,216],or(not(x(10)),or(not(x(40)),or(not(x(42)),or(not(x(59)),or(x(13),x(17))))))),
chain(438,[22,55,65,424,70,181,437],or(x(17),or(not(x(42)),or(not(x(10)),or(not(x(40)),not(x(59))))))),
chain(443,[70,170,67,263,23,56],or(x(42),or(x(10),or(x(59),or(x(16),or(x(17),x(40))))))),
chain(444,[222,415,416,54,443],or(x(59),or(x(10),or(x(17),or(x(42),x(40)))))),
chain(450,[34,110,106],or(x(51),or(x(42),or(x(52),not(x(25)))))),
chain(451,[33,111,107,450],or(x(42),or(x(51),not(x(25))))),
chain(452,[181,263,433,56],or(x(17),or(x(40),or(not(x(42)),or(not(x(10)),or(x(16),x(59))))))),
chain(453,[216,70,415,65,54,22,452],or(x(40),or(not(x(42)),or(not(x(10)),or(x(17),x(59)))))),
chain(454,[181,72,263,65,453,56,24],or(x(59),or(not(x(42)),or(not(x(10)),or(x(16),x(40)))))),
chain(455,[216,69,415,66,453,54,21,454,419],or(x(1),or(not(x(10)),or(x(59),not(x(42)))))),
chain(456,[181,72,424,65,438,55,24],or(not(x(59)),or(not(x(40)),or(not(x(10)),or(x(16),not(x(42))))))),
chain(458,[170,69,263,68,444,56,24],or(x(59),or(x(40),or(x(42),or(x(16),x(10)))))),
chain(459,[222,72,415,67,444,54,21,458,419],or(x(1),or(x(42),or(x(59),x(10))))),
chain(460,[23,67,69,53,425,170,424,422,459,383],or(x(10),or(x(1),x(42)))),
chain(465,[105,112,34],or(not(x(51)),or(not(x(25)),or(x(26),not(x(42)))))),
chain(467,[112,107,36],or(x(25),or(x(42),or(x(27),not(x(51)))))),
chain(468,[109,106,35,467],or(x(42),or(x(25),not(x(51))))),
chain(478,[108,109,33,465],or(not(x(42)),or(not(x(51)),not(x(25))))),
chain(483,[216,69,421,66,438,53,455,21,456,383],or(not(x(10)),or(x(1),not(x(42))))),
chain(604,[12,98,104],or(x(51),or(x(7),or(not(x(28)),x(50))))),
chain(620,[39,117,604,271],or(not(x(42)),or(x(50),or(not(x(30)),or(x(7),or(not(x(53)),x(51))))))),
chain(621,[102,37,11,119,99,478,620],or(not(x(42)),or(not(x(30)),or(x(7),or(not(x(53)),x(50)))))),
chain(622,[97,271,12,621,117,103,39],or(not(x(42)),or(not(x(30)),or(x(7),or(not(x(53)),x(28)))))),
chain(623,[100,478,11,621,119,101,37,622],or(not(x(42)),or(x(7),or(not(x(53)),not(x(30)))))),
chain(626,[144,139,46],or(x(31),or(x(7),or(not(x(34)),x(36))))),
chain(637,[281,96,75,31,7,80],or(x(4),or(x(48),or(x(49),or(x(5),or(not(x(24)),x(45))))))),
chain(638,[94,278,29,74,78,90,8,637],or(x(4),or(x(48),or(not(x(1)),or(x(49),x(45)))))),
chain(639,[8,80,74,32,278,95],or(x(4),or(x(48),or(x(45),or(not(x(49)),or(x(19),x(24))))))),
chain(640,[7,78,75,30,281,93,89,639,638],or(not(x(1)),or(x(48),or(x(4),x(45))))),
chain(641,[29,94,90],or(not(x(19)),or(not(x(1)),or(x(49),not(x(22)))))),
chain(642,[30,93,89,79,641,278,76,7,640],or(not(x(1)),or(x(48),or(x(4),x(5))))),
chain(643,[90,31,95],or(x(22),or(not(x(1)),or(x(19),x(23))))),
chain(644,[89,32,96,643,77,281,73,8,640,642],or(x(48),or(x(4),not(x(1))))),
chain(645,[143,45,140,626],or(x(7),or(x(31),not(x(34))))),
chain(646,[271,99,118,11,40,102],or(x(7),or(x(50),or(not(x(42)),or(x(53),or(x(30),x(28))))))),
chain(647,[478,120,604,38,646],or(x(7),or(x(50),or(x(53),or(x(30),not(x(42))))))),
chain(648,[97,271,12,647,118,103,40],or(x(7),or(x(28),or(x(53),or(x(30),not(x(42))))))),
chain(649,[100,478,11,647,120,101,38,648,116],or(x(7),or(x(53),or(x(4),not(x(42)))))),
chain(650,[115,623,649],or(x(7),or(x(4),not(x(42))))),
chain(651,[13,127,124],or(x(34),or(x(55),or(not(x(10)),not(x(54)))))),
chain(652,[14,126,122,651],or(not(x(10)),or(x(34),x(55)))),
chain(653,[460,650,644],or(x(7),or(x(10),or(x(4),x(48))))),
chain(657,[74,79,6],or(not(x(4)),or(x(22),or(x(46),x(5))))),
chain(658,[76,5,78,657],or(not(x(4)),or(x(46),x(22)))),
chain(659,[96,30,91],or(x(1),or(not(x(22)),or(x(19),x(24))))),
chain(660,[95,29,92,659,658,278],or(x(48),or(not(x(4)),or(x(19),x(1))))),
chain(661,[91,31,94],or(not(x(19)),or(x(22),or(x(1),x(23))))),
chain(662,[92,93,32,661],or(not(x(19)),or(x(1),x(22)))),
chain(663,[73,80,6],or(not(x(4)),or(not(x(46)),or(not(x(22)),x(5))))),
chain(664,[75,5,77,281,663,662,660],or(x(48),or(not(x(4)),x(1)))),
chain(667,[67,23,70],or(not(x(13)),or(x(10),or(x(17),x(16))))),
chain(668,[68,69,24,667],or(x(10),or(not(x(13)),x(16)))),
chain(669,[95,90,32],or(x(24),or(not(x(1)),or(x(19),x(22))))),
chain(670,[96,89,31,669],or(not(x(1)),or(x(19),x(22)))),
chain(671,[2,150,146],or(x(58),or(not(x(1)),or(x(40),x(59))))),
chain(672,[1,151,148,671,53,263],or(not(x(16)),or(not(x(1)),or(x(59),x(43))))),
chain(673,[145,152,2],or(not(x(1)),or(not(x(59)),or(x(2),not(x(40)))))),
chain(674,[147,149,1,672,673,54,424],or(not(x(1)),or(not(x(16)),x(43)))),
chain(675,[11,99,102],or(x(7),or(x(28),or(not(x(51)),x(50))))),
chain(676,[12,103,97,675,451,119,40],or(x(7),or(x(28),or(x(42),or(not(x(53)),x(30)))))),
chain(677,[11,101,100,604,676,468,117,38,114],or(x(7),or(not(x(4)),or(x(30),x(42))))),
chain(678,[120,451,39,675],or(x(7),or(x(53),or(x(28),or(x(42),or(not(x(30)),x(50))))))),
chain(679,[468,118,604,37,678],or(x(7),or(x(53),or(x(42),or(not(x(30)),x(50)))))),
chain(680,[97,451,12,679,120,103,39],or(x(7),or(x(28),or(x(42),or(not(x(30)),x(53)))))),
chain(681,[11,310,37,653,100,645,101,652,113,664,118,668,181,674,679,677,468,680],or(x(7),or(x(48),or(x(31),not(x(13)))))),
chain(682,[79,8,75],or(x(4),or(not(x(46)),or(x(6),x(22))))),
chain(683,[78,7,73,682],or(x(4),or(x(22),not(x(46))))),
chain(684,[94,91,32],or(x(24),or(x(1),or(not(x(19)),x(22))))),
chain(685,[93,92,31,312,684,683],or(not(x(48)),or(x(1),or(x(22),x(4))))),
chain(686,[92,30,95],or(x(1),or(x(23),or(x(19),not(x(22)))))),
chain(687,[91,96,29,686],or(x(1),or(x(19),not(x(22))))),
chain(688,[76,80,7],or(x(46),or(x(4),or(x(5),not(x(22)))))),
chain(689,[74,77,8,336,688,685,687],or(x(1),or(x(4),not(x(48))))),
chain(690,[15,123,126],or(not(x(55)),or(x(10),or(x(34),x(54))))),
chain(691,[16,121,127,690],or(x(10),or(x(34),not(x(55))))),
chain(692,[100,468,11,679,118,483,101,37,113,680,677,689],or(x(7),or(not(x(10)),or(x(1),not(x(48)))))),
chain(693,[65,70,22],or(not(x(10)),or(not(x(16)),or(not(x(13)),x(17))))),
chain(694,[66,69,21,693],or(not(x(10)),or(not(x(13)),not(x(16))))),
chain(695,[1,151,148,671,421,56],or(not(x(43)),or(not(x(1)),or(x(40),x(16))))),
chain(696,[147,149,1,415,673,695,55],or(not(x(1)),or(x(16),not(x(43))))),
chain(697,[40,118,116],or(not(x(25)),or(x(4),or(x(53),x(28))))),
chain(698,[39,117,115,697],or(x(4),or(x(28),not(x(25))))),
chain(699,[12,97,103,675,271,698],or(x(7),or(not(x(42)),or(x(28),x(4))))),
chain(700,[120,38,115],or(not(x(28)),or(x(4),or(x(30),x(25))))),
chain(701,[119,37,116,700],or(x(4),or(x(25),not(x(28))))),
chain(702,[11,101,100,604,699,478,701],or(x(7),or(x(4),not(x(42))))),
chain(704,[6,74,78],or(x(45),or(not(x(4)),or(x(22),x(46))))),
chain(705,[5,79,76,704,336,670],or(not(x(48)),or(not(x(4)),or(x(22),not(x(1)))))),
chain(706,[89,30,94],or(not(x(1)),or(x(23),or(not(x(19)),not(x(22)))))),
chain(707,[90,93,29,706],or(not(x(1)),or(not(x(19)),not(x(22))))),
chain(708,[5,80,75],or(x(45),or(not(x(4)),or(not(x(22)),not(x(46)))))),
chain(709,[6,73,77,702,708,312,705,707,681,692,222,696,694,691,274,645],or(x(7),or(x(31),not(x(13))))),
chain(710,[652,310,460,689],or(x(42),or(x(1),or(x(4),or(x(34),x(31)))))),
chain(711,[71,24,66],or(x(16),or(not(x(10)),or(x(18),x(13))))),
chain(712,[72,23,65,711],or(not(x(10)),or(x(13),x(16)))),
chain(713,[274,691,653,712,645,674,709,710,170,702],or(x(7),or(x(31),x(4)))),
chain(714,[691,692,274,645,664,713],or(x(7),or(x(31),x(1)))),
chain(715,[468,100,118,11,679,37,113,101,680,677],or(x(7),or(x(42),not(x(4))))),
chain(716,[72,22,67],or(not(x(16)),or(x(10),or(x(18),x(13))))),
chain(717,[71,21,68,716],or(x(10),or(x(13),not(x(16))))),
chain(718,[6,73,77,713,708,312,705,707,310,714,652,717,645,709,696,216,715],or(x(31),x(7))),
chain(720,[47,141,139,718],or(x(7),or(not(x(57)),x(34)))),
chain(721,[48,142,140,720,718],or(x(34),x(7))),
chain(722,[16,128,122],or(not(x(34)),or(x(10),or(x(55),x(54))))),
chain(723,[15,125,124,722],or(x(10),or(x(55),not(x(34))))),
chain(724,[42,133,129,718,406,723,653,721],or(x(7),or(x(4),x(10)))),
chain(725,[41,135,131,404],or(x(48),or(x(55),not(x(31))))),
chain(726,[222,696,712],or(not(x(1)),or(not(x(10)),or(x(16),x(42))))),
chain(727,[170,694,674,726],or(not(x(10)),or(not(x(1)),x(42)))),
chain(728,[13,123,128],or(not(x(55)),or(not(x(10)),or(not(x(34)),x(54))))),
chain(729,[14,121,125,724,728,725,721,692,718,727,702],or(x(4),x(7))),
chain(730,[42,133,129,406],or(not(x(48)),or(not(x(55)),not(x(31))))),
chain(731,[216,696,668],or(not(x(42)),or(x(10),or(x(16),not(x(1)))))),
chain(732,[181,717,674,731,664,730,723],or(not(x(42)),or(not(x(34)),or(x(10),or(not(x(4)),not(x(31))))))),
chain(733,[6,73,77,708,312,705,707],or(not(x(48)),or(not(x(1)),not(x(4))))),
chain(734,[14,732,715,729,718,721,125,728,725,733,483,121],x(7)),
chain(735,[9,734],or(not(x(8)),not(x(9)))),
chain(736,[10,734],or(x(8),x(9))),
chain(737,[137,734],or(not(x(36)),not(x(57)))),
chain(738,[138,734],or(x(36),x(57))),
chain(741,[48,143,737],or(x(31),or(x(34),not(x(57))))),
chain(742,[47,144,738,741],or(x(31),x(34))),
chain(743,[736,102,98],or(x(28),or(x(51),x(50)))),
chain(744,[735,103,100,743,38,478,119],or(not(x(42)),or(not(x(53)),or(x(29),x(30))))),
chain(745,[735,104,99],or(not(x(51)),or(not(x(28)),x(50)))),
chain(746,[736,101,97,745,271,40,117,744,113],or(not(x(42)),or(not(x(53)),not(x(4))))),
chain(747,[735,103,100,743,478,120,39],or(not(x(42)),or(x(28),or(not(x(30)),x(53))))),
chain(748,[736,101,97,745,271,747,118,37,746,114],or(not(x(4)),not(x(42)))),
chain(749,[723,742,310],or(x(10),or(x(48),x(31)))),
chain(750,[141,46,738],or(not(x(34)),or(not(x(31)),x(36)))),
chain(751,[142,45,737,749,750,691,725],or(x(48),x(10))),
chain(752,[735,103,100,743,468,698],or(x(4),or(x(28),x(42)))),
chain(753,[736,101,97,745,451,752,701,733,460,751],or(x(42),x(10))),
chain(754,[181,753,674,689,751,748,731,717],x(10)),
chain(756,[14,754],or(x(11),x(12))),
chain(760,[483,754],or(x(1),not(x(42)))),
chain(761,[652,754],or(x(34),x(55))),
chain(767,[727,754],or(not(x(1)),x(42))),
chain(768,[728,754],or(not(x(34)),or(not(x(55)),x(54)))),
chain(769,[756,125,121,768,742,274],or(x(31),not(x(48)))),
chain(770,[142,45,737,769,750,761,730],not(x(48))),
chain(775,[278,770],or(x(19),not(x(46)))),
chain(776,[281,770],or(not(x(19)),x(46))),
chain(779,[664,770],or(not(x(4)),x(1))),
chain(781,[736,97,451,701,779,767,752,745,101],x(42)),
chain(782,[748,781],not(x(4))),
chain(783,[760,781],x(1)),
chain(786,[7,782],or(x(5),not(x(6)))),
chain(787,[8,782],or(not(x(5)),x(6))),
chain(801,[670,783],or(x(19),x(22))),
chain(816,[707,783],or(not(x(19)),not(x(22)))),
chain(820,[801,776,80,75,787],or(x(45),x(6))),
chain(821,[816,79,787,820,775,76],x(6)),
chain(822,[786,821],x(5)),
chain(823,[73,821],or(not(x(45)),not(x(46)))),
chain(824,[74,821],or(x(45),x(46))),
chain(825,[77,822],or(not(x(22)),not(x(45)))),
chain(826,[78,822],or(x(22),x(45))),
chain(827,[816,826,775,824],x(45)),
chain(828,[823,827],not(x(46))),
chain(829,[825,827],not(x(22))),
chain(830,[776,828],not(x(19))),
chain(831,[801,829,830],false)])), 
 store([],[]), 
  unfk([or(and(not(x(38)),x(60)),or(and(x(38),x(60)),or(and(x(38),not(x(60))),or(and(not(x(38)),not(x(60))),or(and(not(x(39)),not(x(60))),or(and(not(x(39)),x(60)),or(and(x(39),not(x(60))),or(and(x(39),x(60)),or(and(not(x(2)),x(40)),or(and(not(x(2)),not(x(40))),or(and(x(2),not(x(40))),or(and(x(2),x(40)),or(and(not(x(3)),not(x(59))),or(and(not(x(3)),x(59)),or(and(x(3),not(x(59))),or(and(x(3),x(59)),or(and(not(x(57)),x(35)),or(and(not(x(35)),x(57)),or(and(not(x(35)),not(x(57))),or(and(x(31),x(57)),or(and(x(36),not(x(57))),or(and(x(57),not(x(36))),or(and(not(x(36)),not(x(57))),or(and(x(36),x(57)),or(and(not(x(32)),not(x(56))),or(and(not(x(32)),x(56)),or(and(x(32),not(x(56))),or(and(x(32),x(56)),or(and(not(x(33)),not(x(56))),or(and(not(x(33)),x(56)),or(and(x(33),not(x(56))),or(and(x(33),x(56)),or(and(not(x(11)),not(x(54))),or(and(not(x(11)),x(54)),or(and(not(x(34)),x(11)),or(and(x(54),x(11)),or(and(x(54),not(x(12))),or(and(x(55),not(x(12))),or(and(x(12),not(x(54))),or(and(x(12),x(54)),or(and(x(29),not(x(53))),or(and(x(53),not(x(29))),or(and(x(25),not(x(29))),or(and(x(29),x(53)),or(and(x(30),not(x(53))),or(and(not(x(30)),x(53)),or(and(not(x(30)),not(x(53))),or(and(x(30),x(53)),or(and(not(x(52)),not(x(26))),or(and(x(52),not(x(26))),or(and(not(x(52)),x(26)),or(and(x(52),x(26)),or(and(not(x(52)),not(x(27))),or(and(x(52),not(x(27))),or(and(not(x(52)),x(27)),or(and(x(52),x(27)),or(and(x(28),not(x(8))),or(and(x(50),not(x(8))),or(and(x(8),not(x(50))),or(and(x(8),x(50)),or(and(not(x(9)),x(50)),or(and(not(x(9)),not(x(50))),or(and(not(x(51)),x(9)),or(and(x(50),x(9)),or(and(not(x(19)),x(23)),or(and(not(x(19)),not(x(23))),or(and(x(19),not(x(23))),or(and(x(19),x(23)),or(and(x(24),not(x(49))),or(and(not(x(24)),x(49)),or(and(not(x(24)),not(x(49))),or(and(x(24),x(49)),or(and(not(x(20)),not(x(47))),or(and(not(x(20)),x(47)),or(and(x(20),not(x(47))),or(and(x(20),x(47)),or(and(not(x(21)),x(47)),or(and(not(x(21)),not(x(47))),or(and(x(21),not(x(47))),or(and(x(21),x(47)),or(and(x(22),not(x(45))),or(and(not(x(22)),x(45)),or(and(not(x(22)),not(x(45))),or(and(x(22),x(45)),or(and(not(x(46)),x(45)),or(and(not(x(45)),x(46)),or(and(not(x(46)),not(x(45))),or(and(x(46),x(45)),or(and(x(17),not(x(44))),or(and(not(x(17)),x(44)),or(and(not(x(17)),not(x(44))),or(and(x(17),x(44)),or(and(x(18),not(x(44))),or(and(x(44),not(x(18))),or(and(not(x(44)),not(x(18))),or(and(x(18),x(44)),or(and(not(x(14)),not(x(43))),or(and(not(x(14)),x(43)),or(and(x(14),not(x(43))),or(and(x(14),x(43)),or(and(not(x(15)),x(41)),or(and(not(x(15)),not(x(41))),or(and(x(15),not(x(41))),or(and(x(15),x(41)),or(and(x(37),not(x(40))),or(and(not(x(37)),x(40)),or(and(not(x(37)),not(x(40))),or(and(x(37),x(40)),or(and(x(38),not(x(39))),or(and(not(x(38)),x(39)),or(and(not(x(38)),not(x(39))),or(and(x(38),x(39)),or(and(not(x(34)),x(35)),or(and(not(x(35)),x(36)),or(and(not(x(35)),not(x(36))),or(and(x(36),x(35)),or(and(x(32),not(x(33))),or(and(not(x(32)),x(33)),or(and(not(x(32)),not(x(33))),or(and(x(32),x(33)),or(and(x(29),not(x(30))),or(and(x(30),not(x(29))),or(and(x(28),not(x(30))),or(and(x(29),x(30)),or(and(x(26),not(x(27))),or(and(not(x(26)),x(27)),or(and(not(x(26)),not(x(27))),or(and(x(26),x(27)),or(and(x(23),not(x(24))),or(and(not(x(23)),x(24)),or(and(not(x(23)),not(x(24))),or(and(x(23),x(24)),or(and(x(20),not(x(21))),or(and(not(x(20)),x(21)),or(and(not(x(20)),not(x(21))),or(and(x(20),x(21)),or(and(x(17),not(x(18))),or(and(not(x(17)),x(18)),or(and(not(x(17)),not(x(18))),or(and(x(17),x(18)),or(and(x(14),not(x(13))),or(and(not(x(14)),not(x(13))),or(and(not(x(14)),x(13)),or(and(x(14),x(13)),or(and(not(x(12)),x(11)),or(and(not(x(11)),x(12)),or(and(not(x(11)),not(x(12))),or(and(x(11),x(12)),or(and(x(8),not(x(9))),or(and(x(9),not(x(8))),or(and(not(x(8)),not(x(9))),or(and(x(8),x(9)),or(and(x(5),not(x(6))),or(and(not(x(5)),x(6)),or(and(not(x(5)),not(x(6))),or(and(x(5),x(6)),or(and(x(2),not(x(3))),or(and(not(x(2)),x(3)),or(and(x(2),x(3)),and(not(x(2)),not(x(3))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))])), print(1), nl ;  
 print(0),nl, fail. 
