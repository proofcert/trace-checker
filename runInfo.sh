#!/bin/sh 
#this assumes we're in the directory that has booleforce, and the other addresses are in full. 1 is the cnf file, 2 is trace output file
read traceFile plFile <<<$(python getName.py $1)
../booleforce-1.2/booleforce -T $traceFile <$1 
if [ -f $traceFile ]; #occurs if a trace was made, which occurs if $1 was unsat
then
#var=$(/path/to/command arg1 arg2)
    info=$(python getInfo.py $1) #returns varnum,clausenum
    echo "info variable: "
    echo $info 
    echo $traceFile ; echo $plFile
    chainInfo=$(python convertTrace.py $traceFile $plFile) #3 is destination prolog file . returns (longestDerived,longestChain)
    echo "chainInfo var: "
    echo $chainInfo
    python storeInfo.py $info $chainInfo
    echo "writing info "
     # this doesn't give time if program terminates before
    #function tryout {
        #local START=$(date +%s) #this isn't given better than seconds, but at my level of performance it doesn't matter yet
        #local exito=$(prolog -t main $1) #prolog file has now been created to give 1 for true, 0 for false
        #local END=$(date +%s)
        #DIFF=$((END-START))
        #echo "time will be"
        #echo $DIFF
        #python storeInfo.py $exito $DIFF} 
    #( cmdpid=$BASHPID; (sleep 500; kill $cmdpid) & tryout $plFile)
    timeout 5m bash tryout.sh $plFile
    python storeInfo.py $traceFile #the name will be recorded either way
    rm $plFile #don't need a bunch of prolog files
    rm $traceFile
    #exito=$(time prolog -t main $3) 
fi

