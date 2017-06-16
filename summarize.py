#input: informe file
#output: one or two lines on report 
#PROBLEM: ../booleforce-1.2/traces/aim200no4; longest chain length: 14; average chain length: 3.72916666667; timeout: 7 
#line in output file will look like this: 0	1       36,612,079. index, success, number.
# also need to deal with lines that look like [index timeout]
import sys

def getBest(bestN,lines):
    bests = []
    for line in lines:
        if line[0] != "#":
            line = line.split()
            if line[1] == "Timeout":
                continue #when returning, all lines may have been timeout. 
            elif len(bests) < bestN:
                bests.append((line[0],int(line[2])))
            #elif int(line[2]) > bests[-1][1]: #no need checking the rest if it's worse than the worst in the list
                #continue
            else:
                for n in range(len(bests)):
                    if int(line[2]) <= bests[n][1]:
                        bests.insert(n,(line[0],int(line[2]))) #tuple of (permutation index, performance)
                        if len(bests) > bestN: #keep only the top N
                            del bests[-1]
                    break
    return bests
                            
def getWorst(N,lines,timeout):
    worsts = []
    for line in lines:
        if line[0] != "#":
            line = line.split()
            if line[1] == "Timeout":
                line.append(timeout) #replacing string w the actual timeout number from above. 
            elif len(worsts)==0:
                worsts.append((line[0],line[2]))
            elif line[2] < worsts[-1][1]: 
                continue
            else:
                for n in range(len(worsts)): 
                    if line[2] >= worsts[n][1]:
                        worsts.insert(n,(line[0],line[2])) #tuple of (permutation index, performance)
                        if len(worsts) > N: #keep only the top N
                            del worsts[-1]
    return worsts
                     
def getPerformanceDict(lines,timeout):
    performances = {}
    for line in lines:
        if line[0] == "#":
            continue
        line = line.split()
        if line[1] == "Timeout":
            performances[int(line[0])] = timeout+"+"
        else:
            performances[int(line[0])] = round(int(line[2])/1000000000.0,5)
    return performances
    



def formatNum(digits):
    counter = 0
    digits = list(str(digits))
    originalLen = len(digits)
    for index in range(originalLen-1,0,-1):
        counter += 1
        if counter == 3:
            digits.insert(index,",")
            counter = 0
    return ''.join(digits)
    

    
def writeSummary(inF,outF,bestN):
    inFile = open(inF)
    outFile = open(outF,'a')
    lines = inFile.readlines()
    infoString = lines[0]
    timeout = infoString.split()[-1] #this will be a string while nontimeouts will be values. it will thus be sorted last
    pd =  getPerformanceDict(lines,timeout)
    pdsort =  sorted(pd.items(), key=lambda x: x[1])
    print "best "+str(bestN)
    print "chain permu and time: "+str(pdsort[:bestN])
    outString = infoString + "\nbest {0} chain permutations and time: {1}\n".format(str(bestN),str(pdsort[:bestN]))
    outString += "worst {0} chain permutations and time: {1}\n".format(str(bestN),str(pdsort[len(pdsort)-bestN:]))
    outFile.write(outString)
    inFile.close()
    outFile.close()
    
#writeSummary('performance/aim200no4.txt','newInforme',7)
writeSummary(sys.argv[1],sys.argv[2],int(sys.argv[3]))

    
    


