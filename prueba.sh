#!/bin/sh 

timeout $1 python prueba.py $2 $3
exitStat=$? #124 if timed out
if [ $exitStat -eq 124 ]
then
    echo "timed out"
fi