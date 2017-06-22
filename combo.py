from math import factorial as fact
import permu 

def complexity(setSets):
    r = len(setSets)
    n = 1
    for element in setSets: 
        n *= fact(len(element))
    return n


print complexity([[1,2,3],[1,2],[2],[3]])

def makeOptions(setSets,options=[]):
    if len(setSets) == 1: 
        permNum = fact(len(setSets[0]))
        perms = permu.genPerm(permu.mergeSort(setSets[0]))
        for n in range(permNum):
            option = next(perms)
            options.append(option)
        return options
    else:
        thisSetPermNum = fact(len(setSets[-1]))
        thisSetPerms = permu.genPerm(permu.mergeSort(setSets[-1]))
        makeOptions(setSets[:-1],options)
        for n in range(thisSetPermNum):
            setOption = next(thisSetPerms)
            options.append(setOption)
        return options
#ok, this is actually returning a list of all permutations of each sublist, but alltogether. not combinations thereof.

#result = [o for o in makeOptions([[1,2,3],[1,2],[2],[3]])]
#print result, len(result)

def permsEach(setSets):
    permSet = []
    for sets in setSets:
        permSet.append(permu.genEach(sets))
    return permSet

def combinations(setSets,results=[]):
    if len(setSets)==2:
        for e in setSets[0]:
            for e1 in setSets[1]:
                results.append([e,e1])
        return results
    else:
        for e in setSets[0]:
             results.append([e,combinations(setSets[1:],results)])
        return results

def comb(thisSet,results=[[]]):
    if len(thisSet) == 1:
        for e in thisSet[0]:
            for r in results:
                r.append(e)
        return results
    else:
        for e in thisSet[0]:
            for r in results:
                r.extend([e,comb(thisSet[1:],results)])
            
print comb([[1,2,3],[6,7],[9]])

    
