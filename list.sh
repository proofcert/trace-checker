#!/bin/sh 
FILES=../problems/aim/goInReport/*
echo ${#FILES[@]}
for f in $FILES
do
  echo "doing $f..."
  bash runInfo.sh $f
done
