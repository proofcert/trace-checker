#!/bin/sh 
#takes longest chain, tries with permutations initially sorted and increasing in lexicographic order. 
#command for doing all small problems: bash list1.sh problems/report/small all 30 lex false fpc
FILES=$1


numPerm=$2 #either integer or "all"
timeOut=$3
method=$4 #should begin with 'lex' or 'rand'
allChains=$5 #should be true or false
version=$6 #should be either "order" or "fpc" ; "template" to use old code. 

for f in $FILES/* 
do
  echo "doing $f"
  read traceFile plFile <<<$(python getName.py $f)
  booleforce-1.2/booleforce -T $traceFile <$f
  read varNum clauseNum <<<$(python getInfo1.py $f)
  if [["$version" == "order"]] ; then
    informe="performanceNew/$traceFile"
  else 
    informe="performance/$traceFile"
  fi
  # if method is order: use newPerformance/$traceFile for dest
  # else: use performance/$traceFile 
  if [ -f $traceFile ]; #occurs if a trace was made, which occurs if $1 was unsat
  then
    python chainOrder.py $traceFile $plFile $numPerm $timeOut $method $informe $allChains $varNum $clauseNum $version
    #10 permutations, 500 seconds for timeout
    rm $plFile #don't need a bunch of prolog files
    rm $traceFile
  fi
done
