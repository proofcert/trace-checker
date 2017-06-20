import permu
import sys
import os
import convertTrace2 as cvTrace
from shutil import copyfile
from math import factorial
KERNEL = "focSep.pl"
FPC = "fpc.pl"
#TEMPLATE = "template.pl"
TEMPLATE = "all1.pl"



#root = "../booleforce-1.2/traces/"
if len(sys.argv) == 1: #default test case with booleforce-1.2/traces/madeup2
    traceName, prologName, numPermString, timeOut, methodString, informeFileName = 'booleforce-1.2/traces/readme', "TEMP1.pl", "all", "10", "lex", "performance/readme.txt"
else:
    traceName, prologName, numPermString, timeOut, methodString, informeFileName = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6]
#assume timeOut to be an integer in seconds
#assume method to be a string beginning with 'lex', meaning lexicographic. default, therefore, is random shuffle
#version with separated prolog. 
'''copyfile(FPC,prologName)
toFile = open(prologName,'a')
kernel = open(KERNEL,'r')
toFile.write(kernel.read())
toFile.flush()
toFile.close()
kernel.close()'''

#version with nonseaparted prolog

#toFile is now prepared w all the checker code necessary

def Lexicographic(iostring):
    iostring = iostring.strip().lower()
    if iostring[:3] == "lex":
        return True
    else:
        return False

#the following allows user to indicate whether to check all permutations or only a few. obviously checking all permutations 
#would make lexicographic generation greatly preferable, but as it is the program does allow this. 
def getPermNum(iostring,antecedents): #iostring can be either "all" or an integer
    iostring = iostring.strip().lower()
    if iostring == "all":
        return factorial(len(antecedents))
    else:
        return int(iostring)
    
method_is_lex = Lexicographic(methodString)
'''print "LEX IS "+str(method_is_lex)
if method_is_lex:
    informeFileName = "informeCadena"
elif not method_is_lex:
    informeFileName = 'informeCadenaRandom''' 
    #the above is for if I'm adding all reports to one long file
informeFile = open(informeFileName,'a')
command = "bash timeout.sh "+prologName+" "+str(timeOut)+"s "+informeFileName



trace = cvTrace.Trace(traceName)
longestChain, chainDex = trace.longestChain()
averageChain = trace.avgChain() 
medChain = trace.medianChain()
infoString = "\n\n#PROBLEM: {0} & longest chain length: {1} & average chain length: {2} & median chain length: {4}'\
    'timeout: {3}s \n".format(traceName,longestChain,averageChain,str(timeOut),medChain)
#NOTE: if adding other info to infoString, keep timeout last. its position is use in summarize.py
#keep & signs so can later do split('&') where necessary
informeFile.write(infoString)
informeFile.flush()
chains = trace.getChain(chainDex)

informeFile.write("#original chain with index {0}: {1} \n".format(chainDex,chains))
informeFile.flush()
sortedChain = permu.mergeSort(chains)
if method_is_lex:
    chainPermu = permu.genPerm(sortedChain)
elif not method_is_lex:
    chainPermu = permu.shuffleUnique(chains)
else:
    print("method should've defaulted to randomShuffle, but somehow hasn't been assigned yet.")
    
numPermutations = getPermNum(numPermString,chains) 

#the above is only run when first opening the problem
#the below is run for each permutation attempted
for n in range(numPermutations):
    trying = next(chainPermu)
    informeFile.write("#trying: "+str(trying)+"\n")
    informeFile.write(str(n)+"\t")
    informeFile.flush()
    trace.replaceChain(trying,chainDex)
    copyfile(TEMPLATE,prologName)
    trace.writeProlog2(prologName)
    os.system(command)
    
 
    #for some reason, the results written to the file by the bash "command"
    #are getting written before the python file.write(..) method, even though that line of code comes before. why is that? 



informeFile.close()

#shellcommand = "swipl -q -s init.pl -f "+logicprogram
#os.system(shellcommand)
