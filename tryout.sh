#!/bin/sh 

START=$(date +%s) 
exito=$(prolog -t main $1) 
END=$(date +%s)
DIFF=$((END-START))
python storeInfo.py $exito $DIFF
                