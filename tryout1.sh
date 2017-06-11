#!/bin/sh 
#2 should be the informe file
START=$(date +%s%N) 
#exito=$(prolog -t main $1) 
#exito=$(echo "main." | swipl -q -f $1)
exito=$(prolog -q -t main $1)
END=$(date +%s%N)
DIFF=$((END - START))
python storeInfo2.py $exito $DIFF $2
echo 1

                