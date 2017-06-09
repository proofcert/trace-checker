#!/bin/sh 
START=$(date +%s%N | cut -b1-13) 
#exito=$(prolog -t main $1) 
#exito=$(echo "main." | swipl -q -f $1)
exito=$(python prueba.py $1)
END=$(date +%s%N | cut -b1-13)
DIFF=$((END - START)) #should be divided by 1000 in receiving code, maintaining decimals
echo $DIFF