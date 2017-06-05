#!/bin/sh 
# $1 is prologFile, $2 is timeout e.g. "10s". $3 is which informe file we store to. 
timeout $2 bash tryout1.sh $1 $3
python storeInfo2.py  $3 #this is already called by tryout to store stats, if tryout succeeds (meaning the prolog program did)
#this is just an unelegant way to write something ('timed out') when the prolog doesn't terminate. 
#however, it also writes 'timed out' when prolog program terminates; therefore reading the file the difference is in whether
#there are performance stats before the 'timed out' message or not
#the above only executes after the timeout. make it not execute if timeout isn't reached?