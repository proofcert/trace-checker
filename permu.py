import random as ra
import math as ma
import convertTrace1 as cvT


root = "../booleforce-1.2/traces/"
problemDict = {0: 'rksat7', 1: 'dubois20', 2: 'pigeonhole6.txt', 3: 'pret6025', 4: 'randomKsat', 5: 'rKsat2', 
6: 'rksat4', 7: 'rksat5', 8: 'rksat7', 9: 'madeup2', 10: 'rksat9', 11: 'pret6040', 12: 'rksat10', 13: 'rksat11', 
14: 'rksat12', 15: 'rksat13', 16: 'aim50no1', 17: 'aim50no2', 18: 'aim50no3', 19: 'aim50no4', 20: 'aim50-2no1',
    21: 'aim50-2no2', 22:'aim50-2no3', 23:'aim50-2no4', 24:'aim100no1', 25:'aim100-2no1', 26:'aim100-2no2', 27:'aim100-2no3',
    28:'aim100-2no4', 29:'aim200no1', 30:'aim200no2', 31:'aim200no3', 32:'aim200no4'
}

def mergeSort(L): #ASCENDING
    if len(L) == 1:
        return L
    else:
        k = len(L)/2
        a = mergeSort(L[:k])
        b = mergeSort(L[k:]) #a and b length should be at most 1 element different
        return merge(a,b)

def merge(a,b):    
    if not b: 
        return a
    if not a:
        return b
    elif a[len(a)-1] <= b[0]:
        a.extend(b)
        return a
    elif b[len(b)-1] <= a[0]:
        b.extend(a)
        return b
    else:
        if a[0] < b[0]:
            first = [a[0],b[0]]
        else:
            first = [b[0],a[0]]
        first.extend(merge(a[1:],b[1:]))
        return first
    
    
def onePerm(L):
    I = None
    for i in range(len(L)-2,-1,-1):
        if L[i] < L[i+1]:
            I = i
            break
    if I == None:
        return None
    for p in range(len(L)-1,I,-1):
        if L[I] < L[p]:
            P = p
            break
    L[i], L[p] = L[p], L[i]
    newTail = [L[k] for k in range(len(L)-1,I,-1)]
    new = L[:I+1]
    new.extend(newTail)
    return new

def genPerm(L):
    new = L
    while new != None:
        yield new
        new = onePerm(new)
 
 
          
# SYNTAX; ESO FUNCIONA
'''pruebaChain = cvT.Trace(root+problemDict[4])
print pruebaChain.avgChain()
longestChain, chainDex = pruebaChain.longestChain()
print "longest Chain: "+str(longestChain)+"; index: "+str(chainDex)
chains = pruebaChain.getChain(chainDex)
print "chain: "+str(chains)

perms = genPerm(mergeSort(chains))
for i in range(10): 
    print next(perms)'''
    
