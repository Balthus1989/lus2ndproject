#!/bin/bash

echo -n "Enter name of the new training set (Last 2 Chars algorithm) > "
read newTrain
echo -n "Enter name of the new test set (Last 2 Chars algorithm) > "
read newTest

paste NLSPARQL.train.data NLSPARQL.train.feats.txt | awk 'OFS="\t" {print tolower($1), $4, tolower($5), $2}' > train.lastTemp
cat train.lastTemp | awk '{print $1}' | sed 's/.*\(..\)/\1/' > 2charsWordsTrain
cat train.lastTemp | awk '{print $3}' | sed 's/.*\(..\)/\1/' > 2charsLemmaTrain
paste train.lastTemp 2charsWordsTrain 2charsLemmaTrain | awk '{OFS="\t"; print $1, $2, $3, $5, $6, $4}' > $newTrain

paste NLSPARQL.test.data NLSPARQL.test.feats.txt | awk 'OFS="\t" {print tolower($1), $4, tolower($5), $2}' > test.lastTemp
cat test.lastTemp | awk '{print $1}' | sed 's/.*\(..\)/\1/' > 2charsWordsTest
cat test.lastTemp | awk '{print $3}' | sed 's/.*\(..\)/\1/' > 2charsLemmaTest
paste test.lastTemp 2charsWordsTest 2charsLemmaTest | awk '{OFS="\t"; print $1, $2, $3, $5, $6, $4}' > $newTest

rm -f train.lastTemp
rm -f 2charsWordsTrain
rm -f 2charsLemmaTrain
rm -f test.lastTemp
rm -f 2charsWordsTest
rm -f 2charsLemmaTest