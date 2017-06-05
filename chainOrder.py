import permu
import sys
import os
import convertTrace1 as cvTrace
from shutil import copyfile
template = "template.pl"
root = "../booleforce-1.2/traces/"

traceName, prologName, numPermutations, timeOut, methodString = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
#assume timeOut to be an integer in seconds
#assume method to be a string beginning with 'lex', meaning lexicographic. default, therefore, is random shuffle
def Lexicographic(string):
    string = string.strip().lower()
    if string[:3] is "lex":
        return True
    else:
        return False
method_is_lex = Lexicographic(methodString)
print "LEX IS "+str(method_is_lex)
if method_is_lex:
    informeFileName = "informeCadena"
elif not method_is_lex:
    informeFileName = 'informeCadenaRandom'
informeFile = open(informeFileName,'a')
command = "bash timeout.sh "+prologName+" "+str(timeOut)+"s "+informeFileName



trace = cvTrace.Trace(root+traceName)
longestChain, chainDex = trace.longestChain()
averageChain = trace.avgChain() 
infoString = "\n\n %%% PROBLEM: {0}; longest chain length: {1}; average chain length: {2}  \n".format(traceName,longestChain,averageChain)
informeFile.write(infoString)
chains = trace.getChain(chainDex)
sortedChain = permu.mergeSort(chains)
if method_is_lex:
    chainPermu = permu.genPerm(sortedChain)
elif not method_is_lex:
    chainPermu = permu.shuffleUnique(chains)
else:
    print("method should've defaulted to randomShuffle, but somehow hasn't been assigned yet.")

#the above is only run when first opening the problem
#the below is run for each permutation attempted
for n in range(numPermutations):
    trying = next(chainPermu)
    informeFile.write(str(n)+'; trying with Chain: '+str(trying)+"\n")
    trace.replaceChain(trying,chainDex)
    copyfile(template,prologName)
    trace.writeProlog2(prologName)
    os.system(command)
    #for some reason, the results written to the file by the bash "command"
    #are getting written before the python file.write(..) method, even though that line of code comes before. why is that? 



informeFile.close()

#shellcommand = "swipl -q -s init.pl -f "+logicprogram
#os.system(shellcommand)

''' SYNTAX; ESO FUNCIONA
pruebaChain = cvT.Trace(root+problemDict[4])
print pruebaChain.avgChain()
longestChain, chainDex = pruebaChain.longestChain()
print "longest Chain: "+str(longestChain)+"; index: "+str(chainDex)
chains = pruebaChain.getLongestChain(chainDex)
print "chain: "+str(chains)

perms = genPerm(chains)
for i in range(10): 
    print next(perms)'''
    




#get trace, write to prolog file, run prolog file, get output/info
#sort longest chain, try on different permutations