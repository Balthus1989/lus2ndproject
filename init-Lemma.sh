#!/bin/bash

echo -n "Enter name of the new training set (Lemma algorithm) > "
read newTrain
echo -n "Enter name of the new test set (Lemma algorithm) > "
read newTest

paste NLSPARQL.train.data NLSPARQL.train.feats.txt | awk 'OFS="\t" {print $1, $4, $5, $2}' > $newTrain
paste NLSPARQL.test.data NLSPARQL.test.feats.txt | awk 'OFS="\t" {print $1, $4, $5, $2}' > $newTest