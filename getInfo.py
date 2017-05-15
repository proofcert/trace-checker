# from critical import diffC out of curiosity, this is running the file and not just getting the method
import sys

def getPrintable(line):
    info = getInfo(line)
    return 'Variables: {0};  clauses: {1}'.format(info[0],info[1])
    

def getInfo(line):
    si = line.split()
    varNum = si[2]
    clauseNum = si[3]
    #I could also try to get clauseNum but that could be more compliated if not constant
    return (varNum,clauseNum)

def findLine(file):
    for line in file.readlines(): 
        if line[0] == "p":
            return line
        elif type(line[0]) is int:
            raise RuntimeError('no p cnf specification line') #shouldn't occur because booleforce wouldn't work otherwise
        else:
            continue
        
        
def main1(doc):
    file = open(doc)
    line = findLine(file)
    file.close()
    string= getInfo(line)
    for s in string:
        print s

main1(sys.argv[1])

