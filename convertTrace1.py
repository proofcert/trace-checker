from string import whitespace
import copy
from shutil import copyfile
import sys

checker = "template.pl"

class Trace(object):
    def __init__(self,inF):
        self.inF = inF
        self.clauseList = self.setClauseList()  
        self.dexList = []
        self.toPrologList = copy.copy(self.clauseList)
        self.TheoremProlog = self.toPrologTheorem()
        self.theorem = self.theorem()
    
#in the following basic stat-getting functions I'm recounting things unnecessarily. could easily be fixed
    def longestChain(self):
        longest = 0
        for L in self.clauseList:
            test = L.chainLength()
            if test > longest:
                longestDex = self.clauseList.index(L)
                longest = test
        return longest, longestDex
    
    def getChain(self,dex):
        return self.clauseList[dex].getAntecedents()
        
    def longestDerived(self):
        longest = 0
        for L in self.clauseList:
            if not L.original():
                test = L.litLength()
                if test > longest:
                    longest = test
        return longest
        
        
    def avgChain(self):
        suma = 0
        count = 0
        for L in self.clauseList:
            if not L.original():
                suma += L.chainLength()
                count += 1
        return suma/float(count)
        
    def avgDerived(self):
        suma = 0
        count = 0
        for L in self.clauseList:
            if not L.original():
                suma += L.litLength()
                count += 1
        return suma/float(count)
      
    def setClauseList(self):
        file = open(self.inF)
        clauseList = []
        for line in file:
            if line != '\n':
                clause = Clause(line)
                clauseList.append(clause)
        file.close()        
        return clauseList
    
    def getClauseList(self):
        return self.clauseList
        
    def __str__(self):
        toPrint = "Parsed clause list: \n"
        for element in self.clauseList:
            toPrint += ("\t"+str(element)+"\n")
        return toPrint
        
    def theorem(self):
        toPrint = ""
        for c in self.clauseList[:-1]:
            if c.original():
                toPrint += "("+c.stringClause() +")\/"
            else:
                break
        toPrint = toPrint[:-3]
        return toPrint
        
    def toPrologTheorem(self): 
        if len(self.toPrologList) == 1:
            self.dexList.append(self.toPrologList[0].getDex())
            return self.toPrologList[0].toProlog()
        elif len(self.toPrologList) == 2:
            self.dexList.append(self.toPrologList[0].getDex())
            self.dexList.append(self.toPrologList[1].getDex())
            return 'or('+self.toPrologList[0].toProlog()+','+self.toPrologList[1].toProlog()+')'
        else:
            val = self.toPrologList.pop()
            vall = val.toProlog()
            restString = self.toPrologTheorem()
            if val.original(): #this assumes that there are at least two original clauses
                self.dexList.insert(0,val.getDex())
                return 'or('+vall+','+restString+')'
            else:
                return restString
                
    def replaceChain(self,newChain,newChainDex):
        self.clauseList[newChainDex].setAntecedents(newChain)
        #note this uses the index of the python Trace object's list, not the index given in trace file. 
        #this might be confusing for users, except this will be handled interally as Trace 
        #is also the one to decide what chain to replace
    
    def getPrologTheorem(self): #seems like bad coding practice but this is necessary as toPrologTheorem can only be called once
        return self.TheoremProlog
    
    def writeProlog2(self,outF,CNFinfo = "" ):
        writeFile = open(outF,'a')
        string = "%Trace from file: "+self.inF+"\n"
        string += str(CNFinfo)
        chainString = "main :- check(certRight("+str(self.dexList)+", \n chains(["
        for n in range(len(self.clauseList)):
            current = self.clauseList[n]
            if current.original():
                continue
            else:
                chain = current.toPrologChain()
                chainString += "chain("+chain[0]+","+chain[1]+","+chain[2]+")"
                if n < len(self.clauseList)-1:
                    chainString += ",\n"
        chainString += "])), \n store([],[]), \n  unfk(["+self.getPrologTheorem()+"])), print(1), nl ;  \n "
        chainString += "print(0),nl, fail. \n" 
        #chainString += "])), \n store([],[]), \n  unfk(["+self.getPrologTheorem()+"])). \n" without the printed 1 or 0
        writeFile.write(string)
        writeFile.write(chainString)
        writeFile.close()
    
        
class Clause(object):
    def __init__(self,line):
        self.clause = self.digest(line)
        self.dex = self.clause[0]
        self.literals = self.clause[1]
        self.antecedents = self.clause[2]
        self.toPrologList = copy.copy(self.literals)
        if self.original():
            self.inProlog = self.toProlog()
        else:
            self.inProlog = self.toPrologDerived()

    def litLength(self):
        return len(self.literals)
    def chainLength(self):
        return len(self.antecedents)
    
    def __str__(self):
        toPrint = ""
        for lit in self.literals: 
            toPrint += str(lit)+"  "
        toPrint += "|  "
        for element in self.antecedents:
            toPrint += str(element)+"  "
        return toPrint
    def stringClause(self):
        toPrint = ""
        for lit in self.literals[:-1]:
            toPrint+=str(lit)+" & "
        if self.literals==[]:
            toPrint += "true" #it's the concluding thingy
        else: 
            toPrint+=str(self.literals[-1])
        return toPrint
        
    def original(self):
        return (not self.antecedents)
    def getLiterals(self):
        return self.literals
    def getAntecedents(self):
        return self.antecedents
    def setAntecedents(self,newChain):
        self.antecedents = newChain
    def getDex(self):
        return int(self.dex)
    def digest(self,line): 
        rawLiterals=line.split()
        dex = rawLiterals.pop(0) #removing the thing that used to be index. more efficient to do this when it's still a string??
        literals=[]
    
        for element in rawLiterals:  #shouldn't be reached. just to avoid infinite  in case of bad input.
            if element == '0':
                startAntecedents = rawLiterals.index(element) + 1
                restList = rawLiterals[startAntecedents:]
                antecedents = addAntecedents(restList)
                return [dex,literals,antecedents]
            else: #the literal is just a number
                literal = Lit(element)
                literals.append(literal)
        print("in process of getting literals in line '"+line+"', reached length before finding a 0.")
                
        
    def toProlog(self): 
            if len(self.toPrologList) == 1:
                return self.toPrologList[0].toProlog()
            elif len(self.toPrologList) == 2:
                return 'and('+self.toPrologList[0].toProlog()+','+self.toPrologList[1].toProlog()+')'
            elif not self.toPrologList: #final clause; false
                return "true"
            else:
                val = self.toPrologList.pop()
                vall = val.toProlog()
                restString = self.toProlog()
                return 'and('+vall+','+restString+')'
    
    def toPrologDerived(self): 
            if len(self.toPrologList) == 1:
                self.toPrologList[0].negate()
                return self.toPrologList[0].toProlog()
            elif len(self.toPrologList) == 2:
                self.toPrologList[0].negate()
                self.toPrologList[1].negate()
                return 'or('+self.toPrologList[0].toProlog()+','+self.toPrologList[1].toProlog()+')'
            elif not self.toPrologList: #final clause; false
                return "false"
            else:
                val = self.toPrologList.pop()
                val.negate()
                vall = val.toProlog()
                restString = self.toPrologDerived()
                return 'or('+vall+','+restString+')'


    def toPrologChain(self): #only should get input from derived clauses
        decideList = "["
        for c in self.antecedents[:-1]:
            decideList += str(c)+","
        decideList += str(self.antecedents[-1])+"]"
        chain = [self.dex,decideList,self.inProlog]
        return chain
        
    
        
class Lit(object):
    def __init__(self,string):
        self.number = string.strip("-")
        self.value = self.sign(string)
        
    def sign(self,string): #default is negated from the trace
        if string[0] == "-":
            return True
        else:
            return False
            
    def negate(self):
        x = self.value
        newval = not x
        self.value = newval
    
    def getNumber(self):
        return self.number
    def getValue(self):
        return self.value
    
    def __str__(self):
        if self.value:
            return self.number
        else:
            return "not("+self.number+")"
    
    def toProlog(self):
        if self.value:
            return 'x('+self.number+')'
        else: 
            return 'not(x('+self.number+'))'
            
   
        


    

def addAntecedents(restList):
    antecedents=[]
    for element in restList: #this is an inexact measure that shouldn't be reached anyway. mostly to stop from going into infinite loop if something wrong 
        if element == '0':
            return antecedents
        antecedents.append(int(element))
    print("In getting antecedents in chain '"+str(restList)+"', exceeded line length without finding a 0.")



problemlist = ["../booleforce-1.2/traces/rksat7","../booleforce-1.2/traces/dubois20", "../booleforce-1.2/traces/pigeonhole6.txt",
"../booleforce-1.2/traces/pret6025", "../booleforce-1.2/traces/randomKsat", "../booleforce-1.2/traces/rKsat2", 
"../booleforce-1.2/traces/rksat4", "../booleforce-1.2/traces/rksat5", "../booleforce-1.2/traces/rksat7", "../booleforce-1.2/traces/madeup2",
"rksat9", "pret6040", "rksat10","rksat11", "rksat12", "rksat13", "aim50no1","aim50no2",'aim50no3','aim50no4',
'aim50-2no1']
root = "../booleforce-1.2/traces/"
problemDict = {0: 'rksat7', 1: 'dubois20', 2: 'pigeonhole6.txt', 3: 'pret6025', 4: 'randomKsat', 5: 'rKsat2', 
6: 'rksat4', 7: 'rksat5', 8: 'rksat7', 9: 'madeup2', 10: 'rksat9', 11: 'pret6040', 12: 'rksat10', 13: 'rksat11', 
14: 'rksat12', 15: 'rksat13', 16: 'aim50no1', 17: 'aim50no2', 18: 'aim50no3', 19: 'aim50no4', 20: 'aim50-2no1',
    21: 'aim50-2no2', 22:'aim50-2no3', 23:'aim50-2no4', 24:'aim100no1', 25:'aim100-2no1', 26:'aim100-2no2', 27:'aim100-2no3',
    28:'aim100-2no4', 29:'aim200no1', 30:'aim200no2', 31:'aim200no3', 32:'aim200no4'
}
'''for n in range(29,33):
    test = Trace(root+problemDict[n])
    test.writeProlog2("testList2.pl")'''
    

    
def main():
        traceFile = sys.argv[1]
        toFile = sys.argv[2]
        copyfile(checker,toFile)
        tra = Trace(traceFile)
        tra.writeProlog2(toFile)
        print tra.longestDerived() 
        print tra.longestChain() #to be collected by bash script 

'''
main()    

pruebaChain = Trace(root+problemDict[4])
#pruebaChain.writeProlog2('pruebaChain.pl')
print pruebaChain.avgChain()
longestChain, chainDex = pruebaChain.longestChain()
print "longest Chain: "+str(longestChain)+"; index: "+str(chainDex)
print "longest chain list: "+str(pruebaChain.getChain(chainDex))
pruebaChain.replaceChain([7,7,7,7,7,7],chainDex)
#pruebaChain.writeProlog2('pruebaChain.pl') 
'''

#oclause = Clause('1 2 3 4 4 0 0')
#print oclause.toProlog()

#tclause = Clause('1 2 3 4 4 0 4 2 0')
#print "regular derived: " + tclause.toPrologDerived()
#print tclause.toPrologChain() #is it still negated when it shouldn't be? 