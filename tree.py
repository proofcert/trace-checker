class Node(object):
    def __init__(self,name):
        self.name = name
        self.children = []
        self.parent = None
        self.flag = False
    
    
    def addChild(self,child):
        self.children.append(child)
        child.setParent(self)
    
    
    def setParent(self,newParent):
        self.parent = newParent
    
    def firstUnflaggedChild(self):
        if self.children == []:
            print "no children, yay"
        else: 
            for ch in self.children:
                if not ch.flagged():
                    return ch
        print "all children are flagged"
        
    def flagged(self):
        return self.flag
    
    def flag(self):
        if self.flag == True:
            print str(self)+" is already flagged? but ok"
        else:
            self.flag = True
    
    def unflag(self):
        if self.flag == False:
            print str(self)+" is already unflagged but kk"
        else:
            self.flag = False
    
    def getChildren(self):
        return self.children
    
    def getParent(self):
        return self.parent
        
    def isRoot(self):
        return self.parent == None
    
    def __str__(self):
        return str(self.name)
    
    def isLeaf(self):
        return self.children == []
        
def traverse(root, leaves = []):
    if root.isLeaf():
        root.flag
        leaves.append(root)
        return root
    else: 
        toTraverse = root.getChildren()
        for child in Children: 
            if not child.flagged():
                child.flag()
                traverse(child,leaves)
                
def createTree(setSet,root,originalRoot):
    if len(setSet) == 1:
        for ses in setSet[0]:
            root.addChild(Node(ses))
        return 
        

n1 = Node(1)

print str(n1)+" is leaf: "+str(n1.isLeaf())
print str(n1)+" is root : "+str(n1.isRoot())


m2 = Node(7) 
n1.addChild(m2)
n2 = Node(2)
n2.addChild(m2)
print m2.getChildren()
print n2.getChildren()
print m2.getChildren()
print n1.getParent()
print m2.getParent()
print n1.isLeaf()
print m2.isLeaf()
print m2.isRoot()
print n1.isRoot()