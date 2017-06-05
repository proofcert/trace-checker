import sys

def writeFormat(string, elements):
    for e in elements:
        space = 8
        newspace = 8 - len(e)
        space = " " * newspace
        string+=str(e)+space
    return string
    
def startLine(file,info1,info2):
    varnum = info1[0]
    clausenum = info1[1]
    LD = info2[0]
    LC = info2[1]
    file.write(writeFormat('',[varnum,clausenum,LD,LC]))

#startLine('pruebaa',['hi','there'],['a','ver']) so this works independently as it should

def continueLine(file,success,time): #info should be time and success, but just time for now
    file.write(writeFormat('',[success,time]))
    file.close()
def continueLine1(file,name):
    file.write(name+'\n')

#cases
#0 input: prolog timed out 
#two inputs: prolog result (0 or 1), runtime

if len(sys.argv) == 4:
    file = open(sys.argv[3],'a')
    continueLine(file,sys.argv[1],sys.argv[2])
elif len(sys.argv) == 2:
    file = open(sys.argv[1],'a')
    file.write(" timed out \n") 
else:
    raise ValueError('nope, length of args is '+str(len(sys.argv))+"\n and they are "+str(sys.argv))
file.close()