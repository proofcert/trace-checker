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
        
def shuffle(L):
    for i in range(0,len(L)-1):
        j = ra.randrange(i,len(L))
        #print "swapping {0} and {1}".format(L[i],L[j])
        L[i], L[j] = L[j], L[i]
        #print "in loop list now "+str(L)
    #print "out look returning "+str(L)
    return L

    
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

'''def shuffleEach(L,n,pL=[]):
    if n == 0:
        print "returning pL "+str(pL)
        return pL
    else:
        L1 = shuffle(L)
        pL.append(L1)
        print "adding {0} to pl. pL is now {1}".format(L1,pL)
        shuffleEach(L,n-1,pL)
#this is so weird! returns none. also when I have a list [[1,2],[1,2]], adding [2,1] changes all the elements in the list to match??  
print shuffleEach([1,2],20)
ok there is something about it reordering the sublists. if theyre tuples then this doesnt happen'''

def shuffleEach(L,n):
    pL = []
    for i in range(n):
        pL.append(tuple(shuffle(L)))
    return (pL)

def genEach(L):
    permList = [] 
    perms = genPerm(L)
    for i in range(ma.factorial(len(L))):
        toAdd = tuple(next(perms))
        permList.append(toAdd)
    return permList
        
def shuffleUnique(L,prevPermu=[]):
    while len(prevPermu)<=ma.factorial(len(L)):
        L1 = shuffle(L)
        if tuple(L1) not in prevPermu:
            prevPermu.append(tuple(L1))
            yield L1 #it's awkward that I'm yielding a list but storing tuples internally (so that python doesn't mess with list order)
            #could just make everything a tuple from the start, but at this point there
            #are a bunch of dependencies in other files so I'd rather do this for now. 
 


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
    
def flatten(deepList):
    result = []
    for n in deepList:
        if type(n) is list:
            result.extend(flatten(n))
        else:
            result.append(n)
    return result

def allOnce(sets):
    if len(sets) == 1:
        return sets[0]
    elif len(sets) == 2:
        paths = []
        for n0 in sets[0]:
            for n1 in sets[1]:
                paths.append([n0,n1]) #different cases for if n0 and n1 are elements or lists themselves?
        return paths
    else:
        paths = allOnce(sets[:2])
        rest = allOnce(sets[2:])
        return allOnce([paths,rest])


def allComboAllChain(allChains):
    chainsPerms = [genEach(chain) for chain in allChains]
    result = allOnce(chainsPerms)
    result1 = [flatten(n) for n in result]
    return result1

'''sets = [[1, 4, 5], [3, 9, 8, 1], [2, 10], [6, 10], [7, 10], [13, 12, 4], [11, 14], [13, 15], [3, 14, 15, 16]]
result = [genEach(chain) for chain in sets]
print result'''

