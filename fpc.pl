%init expert
inite(store(SL,NL),not(x(P))) :- member(not(x(P)),NL).

releasee(certLeft(DL),certLeft(DL)).

%cut expert
cute(certRight([],chains([chain(StoreDex, DL, Formula)|RestChains])),certLeft([-1|DL]),
certRight([StoreDex],chains(RestChains)),Formula).

%decide expert
decidee(certLeft(DL),certLeft(DL1),I) :- select(I,DL,DL1).

ande(certLeft(DL),certLeft(DL),certLeft(DL)).

ore(Cert,Cert).

%store expert
storee(certRight([I|Rest],Chains),certRight(Rest,Chains),C,I).  
storee(certLeft(DL),certLeft(DL),C,-1).