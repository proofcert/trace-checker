import pickle
metaList = []
import sys

oF = sys.argv[1]
iF = sys.argv[2]

with open(iF) as F:
    skippingLines = True 
    for line in F:
        print line
        if (not line.split()) and skippingLines:
            continue
        elif line.strip()[0] == "%": #title line
            skippingLines = False
            lineInfo = line.split(";")
            revInf = []
            for info in lineInfo:
                revInf.append(info.split()[-1])
            ID = {"name":revInf[0], "runTimes":[], "avgChain": revInf[2], "medChain": None, "longChain": revInf[1], "timeout": revInf[3]}
        elif not line.split(): #empty line marks the end of that problem, start of another one
            metaList.append(ID)
            ID = None #it should get reassigned anyway, but just to make sure
            skippingLines = True
        elif line.split()[0][-1] == ";": #line that gives the permutation being tried
            continue
        elif line.strip()[:4] == "time":
            ID["runTimes"].append(ID["timeout"]+"+")
        elif line[0] == "1":
            if len(line.split()[1]) > 3: #this was when I implemented it in nanoseconds 
                want = line.split()[1]
                want = "".join(want.split(",")) #because I put damn commas in some of them smh 
                ID["runTimes"].append(round(int(want)/1000000000.0,5))
            else: #in seconds
                ID["runTimes"].append(int(line.split()[1]))
        
print('got to this point 0')
            
with open("pickles.pickle",'wb') as filee:
        pickle.dump(metaList,filee,protocol=pickle.HIGHEST_PROTOCOL)                
print('got to this point 1')

with open(oF,'a') as helpme:
    for report in metaList:
        print('got to loop')
        performances = sorted(report["runTimes"])
        reportString = "{0} & {1} & {2} & {3} & {4} & {5} \\\\ \n".format(report["name"],report["avgChain"],report["medChain"], \
        report["longChain"],performances[0],performances[-1])
        helpme.write(reportString)


