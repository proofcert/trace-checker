#!/bin/sh 
#takes longest chain, tries with permutations initially sorted and increasing in lexicographic order. 
FILES=$1
method=$2 #should begin with 'lex' or 'rand'
timeOut=$3
numPerm=$4
for f in $FILES/* 
do
  echo "doing $f"
  read traceFile plFile <<<$(python getName.py $f)
  ../booleforce-1.2/booleforce -T $traceFile <$f
  if [ -f $traceFile ]; #occurs if a trace was made, which occurs if $1 was unsat
  then
    python chainOrder.py $traceFile $plFile $numPerm $timeOut $method
    #10 permutations, 500 seconds for timeout
    rm $plFile #don't need a bunch of prolog files
    rm $traceFile
  fi
done
