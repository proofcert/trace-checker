import sys
def getName(cnfName):
    pathParts = cnfName.split('/')
    traceName = pathParts[-1][:-4]
    #~workspace/problems/rksat11.cnf
    
    prologName = traceName+".pl"
    
    return (traceName, prologName)

