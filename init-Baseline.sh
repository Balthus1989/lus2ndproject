#!/bin/bash

echo -n "Enter name of the new training set (Baseline algorithm) > "
read newTrain
echo -n "Enter name of the new test set (Baseline algorithm) > "
read newTest

paste NLSPARQL.train.data NLSPARQL.train.feats.txt | awk 'OFS="\t" {print $1, $4, $2}' > $newTrain
paste NLSPARQL.test.data NLSPARQL.test.feats.txt | awk 'OFS="\t" {print $1, $4, $2}' > $newTest