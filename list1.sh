#!/bin/sh 
FILES=$1
echo ${#FILES[@]} #note you gotta do filePath/*
for f in $FILES
do
  echo "doing $f"
  read traceFile plFile <<<$(python getName.py $f)
  ../booleforce-1.2/booleforce -T $traceFile <$f
  if [ -f $traceFile ]; #occurs if a trace was made, which occurs if $1 was unsat
  then
    python chainOrder.py $traceFile $plFile 10 500
    rm $plFile #don't need a bunch of prolog files
    rm $traceFile
  fi
done
