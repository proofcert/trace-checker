import sys

def writeFormat(string, elements):
    for e in elements:
        space = 8
        newspace = 8 - len(e)
        space = " " * newspace
        string+=str(e)+space
    return string
    
def startLine(info1,info2):
    print('in here')
    file = open('informe','a')
    varnum = info1[0]
    clausenum = info1[1]
    LD = info2[0]
    LC = info2[1]
    file.write(writeFormat('',[varnum,clausenum,LD,LC]))
    file.close()

#startLine('pruebaa',['hi','there'],['a','ver']) so this works independently as it should

def continueLine(success,time): #info should be time and success, but just time for now
    file = open('informe','a')
    file.write(writeFormat('',[success,time]))
    file.close()
def continueLine1(name):
    file = open('informe','a')
    file.write(name+'\n')
    file.close()
   
if len(sys.argv) == 3:
    print('in first condition')
    continueLine(sys.argv[1],sys.argv[2])
elif len(sys.argv) == 5:
    print('in other condition')
    startLine((sys.argv[1],sys.argv[2]),(sys.argv[3],sys.argv[4]))
elif len(sys.argv) == 2:
    continueLine1(sys.argv[1])
else:
    raise ValueError('nope, length of args is '+str(len(sys.argv))+"\n and they are "+str(sys.argv))

