#!/bin/sh 
# $1 is prologFile, $2 is timeout e.g. "10s". $3 is which informe file we store to. 
timeout $2 bash tryout1.sh $1 $3
exitStat=$? #124 if timed out
if [ $exitStat -eq 124 ] 
then #the other case, that it didn't time out, is taken care of in tryout1.sh
    python storeInfo2.py $3 
fi

