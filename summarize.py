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
        #print line
        if not line: #end of file
            return performances
        elif len(line) == 1: #must've run out of time or CPU to continue. effectively end of file
            return performances
        elif line[1] == "Timeout":
            performances[int(line[0])] = int(timeout[:-1]) #converting the timeout to just a regular number. needs to be note
        else:
            performances[int(line[0])] = round(int(line[2])/1000000000.0,5) #conversion from nanoseconds to seconds
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
    

    
def getBestWorst(sortedList):  #assumes sorted already
    best = sortedList[0]
    worst = sortedList[-1]
    return best[1], worst[1]

def medTime(pdsort):
    length = len(pdsort)
    if length%2==0:
        med1 = pdsort[length/2][1]
        med2 = pdsort[(length/2)-1][1]
        return round(float(med1+med2)/2,5)
    else:
        return pdsort[length/2][1]
        

def avgTime(di):
    total = sum(di.values()) 
    return round(float(total)/len(di),5)

def writeSummary(inF,outF):
    inFile = open(inF)
    outFile = open(outF,'a')
    lines = inFile.readlines()
    infoString = lines[0] #this is an assumption. just make sure it is always the first line
    infoList = infoString.split('&')
    
    timeout = infoList[-1].split()[-1] #this will be a string while nontimeouts will be values. it will thus be sorted last
    problemName = infoList[0].split()[-1]
    longestChain = infoList[1].split()[-1]
    avgChain = infoList[2].split()[-1]
    medChain = infoList[3].split()[-1]
    
    
    pd =  getPerformanceDict(lines,timeout)
    pdsort =  sorted(pd.items(), key=lambda x: x[1])
    best, worst = getBestWorst(pdsort)
    avg = avgTime(pd)
    med = medTime(pdsort)
    
    outString = "{0} \t{1} \t{2} \t{3} \t{4} \t{5} \t{6} \t{7}\n".format(problemName, longestChain, avgChain, medChain, best, worst, avg, med)
    print outString
#PROBLEM: comp & longest chain length: 4 & average chain length: 2.6667 & median chain length: 2 & varNum: ('4', & clauseNum: '8') & chains: 9 & timeout: 30s 

    
    
    
    
    outFile.write(outString)
    inFile.close()
    outFile.close()
    
#writeSummary('performance/aim200no4.txt','newInforme',7)
writeSummary(sys.argv[1],sys.argv[2])

    
    


