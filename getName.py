import sys
def getName(cnfName):
    pathParts = cnfName.split('/')
    traceName = pathParts[-1][:-4]
    #~workspace/problems/rksat11.cnf
    
    prologName = traceName+".pl"
    
    print traceName
    print prologName

getName(sys.argv[1])