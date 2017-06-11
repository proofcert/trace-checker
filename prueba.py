import random
# -*- coding: UTF-8 -*-
import sys
from time import sleep
def uselessExponent(a,x):
    useless, n, count = [1], 1, 0
    while count < x:
        count += 1 
        n = a*n
        #random.seed(n) 
        prueba = random.randint(useless[-1],n)
        print "random "+str(prueba)
        for what in useless:
            if prueba%what == 7: 
                #print u"おめでとう、数を見つけた！　{0} is divisible by {1} w 七".format(prueba,what) 
                sleep(prueba/float(100000))
            #else:
                #print u"はい、これは全然必要じゃないのね"
        useless.append(prueba)
    return n, useless
#result, useList = uselessExponent(int(sys.argv[1]),int(sys.argv[2]))
#print "数：{0}, 他の数：{1}".format(result,useList)

#sleep(int(sys.argv[1]))

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

    