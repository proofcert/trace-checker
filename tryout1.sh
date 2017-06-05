#!/bin/sh 
#2 should be the informe file
START=$(date +%s) 
exito=$(prolog -t main $1) 
END=$(date +%s)
DIFF=$((END-START))
python storeInfo2.py $exito $DIFF $2
                

                