class Node(object):
    def __init__(self,name, children = [], parent = None):
        self.name = name
        if not children:
            self.children = children
        else:
            self.children = []
        if not parent:
            self.parent = parent #can only have one parent
        else:
            self.parent = None
        self.flag = False
    
    def addChild(self,child):
        self.children.append(child)
    
    
    
    def addParent(self,newParent):
        if self.parent != None:
            print "warning, overriding parent from "+str(self.parent)+" to "+str(newParent)
            self.parent = newParent
            newParent.addChild(self)
        else:
            self.parent = newParent
            newParent.addChild(self)
    
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

n1 = Node(1)

for x in [7,8]:
    n1.addChild(Node(x))

print [str(n) for n in n1.getChildren()]
print n1.isLeaf()
print n1.firstUnflaggedChild()
print n1.getChildren()[0].getChildren()[1]
    
    