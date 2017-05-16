#!/bin/sh 
FILES=$1
echo ${#FILES[@]}
for f in $FILES
do
  echo "doing $f..."
  bash runInfo.sh $f
done
