from math import log, factorial as fact
import sys

def satConstraint(k,varNum,clauseNum):
    if (k<=0 or varNum<=0 or clauseNum<=0):
        return False
    elif k>varNum:
        return False
    elif clauseNum > comb(varNum*2,k):
        return False
    else: 
        return True
    
def comb(n,k):
    return fact(n)/float(fact(k)*fact(n-k))

def diffC(k,varNum,clauseNum): # k is literals per clause
    c = clauseNum/float(varNum)
    inside = float(2**k)/((2**k)-1)
    critical = 1/log(inside,2)
    return c-critical 
    # for problem to be likely unsat, we want C to be greater than critical
    
def outside(args):
    k = int(args[1])
    v = int(args[2])
    c = int(args[3])
    if satConstraint(k,v,c):
        print('diff: ')+str(diffC(k,v,c))
    else:
        print("doesn't satisfy constraint. ")

    
    

def give():
    listy = [(k,v,c) for k in range(3,30) for v in range(100) for c in range(100)]
    for e in listy:
        if satConstraint(e[0],e[1],e[2]):
            criticalDif = diffC(e[0],e[1],e[2])
            if criticalDif > 0:
                print 'k={1} v={0} c={2}'.format(e[1],e[0],e[2])+"; "+str(criticalDif)
        else:
            continue

if len(sys.argv[1]) > 1:
    give()
else:
    outside(sys.argv)