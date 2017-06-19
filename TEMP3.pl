%Trace from file: booleforce-1.2/traces/simpleTrace
main :- check(certRight([3, 1, 2], 
 chains([chain(4,[1,3],x(2)),
chain(5,[4,2],false)])), 
 store([],[]), 
  unfk([or(x(1),or(and(not(x(1)),not(x(2))),x(2)))])), print(1), nl ;  
 print(0),nl, fail. 
