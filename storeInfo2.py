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

if len(sys.argv) == 4: #prolog did not time out. now returning success (1,0) and time
    file = open(sys.argv[3],'a')
    timeFormat = formatNum(sys.argv[2])
    continueLine(file,sys.argv[1],timeFormat)
elif len(sys.argv) == 2: #prolog timed out
    file = open(sys.argv[1],'a')
    file.write(" timed out \n") 
else:
    raise ValueError('nope, length of args is '+str(len(sys.argv))+"\n and they are "+str(sys.argv))
file.close()