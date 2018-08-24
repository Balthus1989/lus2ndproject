#!/bin/bash

echo -n "Enter name of the new training set (Suffix algorithm) > "
read newTrain
echo -n "Enter name of the new test set (Suffix algorithm) > "
read newTest

paste NLSPARQL.train.data NLSPARQL.train.feats.txt | awk 'OFS="\t" {print tolower($1), $4, tolower($5), $2}' > train.toSubtract
cat train.toSubtract | gawk '{if (NF!=0) print$0,gensub("["gensub(/([\[\]^-])/,"\\\\\\1","g",$3)"]","","g",$1); else if (NF==0) print $0;}' | awk 'OFS="\t" {print $1, $2, $3, $5, $4}' > train.suffTemp
cat train.suffTemp | awk '{OFS="\t"; if (NF==4) print $1, $2, $3, "IDN", $4; else print $0}' > train2.suffTemp
cat train2.suffTemp | awk '{if ($4!="IDN"){OFS="\t"; if ($3$4!=$1) print $1, $2, $3, "IRR", $5; else if ($3$4==$1) print $0} else if($4=="IDN") print $0;}' > $newTrain

paste NLSPARQL.test.data NLSPARQL.test.feats.txt | awk 'OFS="\t" {print tolower($1), $4, tolower($5), $2}' > test.toSubtract
cat test.toSubtract | gawk '{if (NF!=0) print$0,gensub("["gensub(/([\[\]^-])/,"\\\\\\1","g",$3)"]","","g",$1); else if (NF==0) print $0;}' | awk 'OFS="\t" {print $1, $2, $3, $5, $4}' > test.suffTemp
cat test.suffTemp | awk '{OFS="\t"; if (NF==4) print $1, $2, $3, "IDN", $4; else print $0}' > test2.suffTemp
cat test2.suffTemp | awk '{if ($4!="IDN"){OFS="\t"; if ($3$4!=$1) print $1, $2, $3, "IRR", $5; else if ($3$4==$1) print $0} else if($4=="IDN") print $0;}' > $newTest

rm -f train.toSubtract
rm -f train.suffTemp
rm -f train2.suffTemp
rm -f test.toSubtract
rm -f test.suffTemp
rm -f test2.suffTemp
