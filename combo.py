from math import factorial as fact
import permu 

def complexity(setSets): #what is this for though? with the permutations
    r = len(setSets)
    n = 1
    for element in setSets: 
        n *= fact(len(element))
    return n

def combinationsComplexity(sets):
    n = 1
    for element in sets:
        n *= len(element)
    return n

            
def onePath(path,matrix, mdex=0, ldex=0):
    while True:
        path.append(matrix[mdex][ldex])
        if mdex == len(matrix) - 1: #reached a leaf
            yield path
            
            if ldex == len(matrix[mdex]) - 1: #last thingy in this set 
                del path[-2:]
                addPath(path, matrix, mdex-1)
            else: #just recreate path with next element in this set 
                del path[-1]
                addPath(path,matrix,mdex,ldex + 1)
            
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

        


def flatten(deepList):
    result = []
    for n in deepList:
        if type(n) is list:
            result.extend(flatten(n))
        else:
            result.append(n)
    return result

sets = [[1,2,3],[7,8,9],[5,6]]
setsPerms = [permu.genEach(oneSet) for oneSet in sets]
print "SETS PERMS: "
print setsPerms
result = allOnce(setsPerms)
print flatten(result[0])
print "ALL OF COMBINATIONS OF PERMUTATIONS??!?"
for r in result:
    print flatten(r)
print len(result)
print complexity(sets)

