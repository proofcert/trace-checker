#!/bin/sh 
#takes longest chain, tries with permutations initially sorted and increasing in lexicographic order. 
FILES=$1


numPerm=$2 #either integer or "all"
timeOut=$3
method=$4 #should begin with 'lex' or 'rand'
allChains=$5 #should be true or false

for f in $FILES/* 
do
  echo "doing $f"
  read traceFile plFile <<<$(python getName.py $f)
  booleforce-1.2/booleforce -T $traceFile <$f
  read varNum clauseNum <<<$(python getInfo1.py $f)
  if [ -f $traceFile ]; #occurs if a trace was made, which occurs if $1 was unsat
  then
    python chainOrder.py $traceFile $plFile $numPerm $timeOut $method "performance/$traceFile" $allChains $varNum $clauseNum
    #10 permutations, 500 seconds for timeout
    rm $plFile #don't need a bunch of prolog files
    rm $traceFile
  fi
done
