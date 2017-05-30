#!/bin/sh 
# $1 is prologFile, $2 is timeout e.g. "10s"
timeout $2 bash tryout1.sh $1
python storeInfo1.py
#the above only executes after the timeout. make it not execute if timeout isn't reached?