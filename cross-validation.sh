#!/bin/bash

echo -n "Enter k for cross-validation > "
read k
echo -n "Enter the hyperparameter > "
read hyper
echo -n "Enter the number of threads > "
read threads
echo -n "Specify the template to be used > "
read tmpl
echo -n "Training set (file name)> "
read trainSet
echo -n "Test set (file name)> "
read testSet
echo -n "What features strategy did you use? (1 - Baseline, 2 - Lemma, 3 - Suffix, 4 - Last 2 Chars)> "
read strategy

dir=$(pwd)

# split from a line to a line: awk 'NR >= 1 && NR <= 10' train.tosplit
# put a # when the sentence ends (splits from line to line could not be useful): awk '!NF{$0="#"}1' train.tosplit

#numerating sentences awk 'BEGIN{i=0} !NF{$0=i++}1' train.tosplit

#frasi divise per tre, 1112 frasi per i nuovi 3 test set. awk '{if($2 == 1112) print}' train.numphrase | awk '{print $1}' 
#memorizzagta la variabile (num riga), printo dall'inizio a quella riga, e si somma: awk 'NR >= 1 && NR <= 8315' train.numphrase
# awk 'BEGIN{i=0} !NF{$0=i++}1' train.tosplit | awk '{OFS="\t"; print NR, $0}' > train.numphrase
#paste NLSPARQL.train.data NLSPARQL.train.feats.txt | awk 'OFS="\t" {print $1, $4, $2}' > train.newformat
#paste NLSPARQL.test.data NLSPARQL.test.feats.txt | awk 'OFS="\t" {print $1, $4, $2}' > test.newformat

# cat train.newformat test.newformat > total.temp
cat $trainSet $testSet > total.temp

# SHUFFLING DATASET
$dir/shuffling.sh total.temp

awk 'BEGIN{i=1} !NF{$0=i++}1' total.dataset | awk '{OFS="\t"; print NR, $0}' > traintotal.numphrase

# $(cat traintotal.numphrase | wc -l) > $lastline
read lastline < <(cat traintotal.numphrase | wc -l)
read totalphrase < <(cat traintotal.numphrase | awk '{if ($1 == '$lastline') {print $2}}')

# echo $lastline


read foldDim < <(echo $totalphrase / $k | bc)

#cat traintotal.numphrase | awk 'NR >= 1 && NR <= '$foldDim'' > test.enum
#echo $foldDim number of phrases of the fold


for (( i=1; i<=$k; i++)) do
    let a=$foldDim*$i

    read line2 < <(cat traintotal.numphrase | awk 'NF==2{if($2=='$a') {print $1}}')
    
    if [ $i -eq 1 ]
    then
        cat traintotal.numphrase | awk 'NR >= 1 && NR <= '$line2'' > test1.numphrase
	let train1Line=$line2+1
        cat traintotal.numphrase | awk 'NR >= '$train1Line' && NR <= '$lastline'' > train1.numphrase

        if [ $strategy -eq 1 ]
        then
            cat train1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4}' > train1.clean
            cat test1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4}' > test1.clean
        fi

        if [ $strategy -eq 2 ]
        then
	    cat train1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5}' > train1.clean
            cat test1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5}' > test1.clean
        fi

        if [ $strategy -eq 3 ]
        then
	    cat train1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6}' > train1.clean
            cat test1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6}' > test1.clean
        fi

        if [ $strategy -eq 4 ]
        then
	    cat train1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6, $7}' > train1.clean
            cat test1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6, $7}' > test1.clean
        fi
    fi

    if [ $i -gt 1 ]
    then
        cat traintotal.numphrase | awk 'NR >= '$lineToMem' && NR <= '$line2'' > test$i.numphrase
        let train1Line=$lineToMem-1
        let train2Line=$line2+1
        cat traintotal.numphrase | awk 'NR >= 1 && NR <= '$train1Line'' > train$i.numphrase
        cat traintotal.numphrase | awk 'NR >= '$train2Line' && NR <= '$lastline'' >> train$i.numphrase

        if [ $strategy -eq 1 ]
        then
	    cat train$1.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4}' > train$i.clean
            cat test$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4}' > test$i.clean
        fi

        if [ $strategy -eq 2 ]
        then
	    cat train$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5}' > train$i.clean
            cat test$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5}' > test$i.clean
        fi

        if [ $strategy -eq 3 ]
        then
	    cat train$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6}' > train$i.clean
            cat test$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6}' > test$i.clean
        fi

        if [ $strategy -eq 4 ]
        then
	    cat train$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6, $7}' > train$i.clean
            cat test$i.numphrase | awk '{if (NF==2) print $0=""; else print $0}' | awk 'OFS="\t" {print $2, $3, $4, $5, $6, $7}' > test$i.clean
        fi
    fi

    let lineToMem=$line2+1

    echo "Training started for K = $i ..."
    crf_learn -c $hyper -p $threads $tmpl train$i.clean model$i
    echo "Done! Test started for K = $i ..."
    crf_test -m model$i test$i.clean > output$i
    echo "Done! Evalutaion printed on outputKFold for K = $i"
    $dir/conlleval.pl -d "\t" < output$i >> outputFold$k.param$hyper.strategy$strategy
    #./conlleval.pl -d "\t" < output3 | awk 'NR==2{print}' | sed 's/://g;s/%//g;s/;//g' | awk 'OFS="\t" {print $2, $4, $6, $8}' >> output.Temp for saving row with results
    $dir/conlleval.pl -d "\t" < output$i | awk 'NR==2{print}' | sed 's/://g;s/%//g;s/;//g' | awk 'OFS="\t" {print $2, $4, $6, $8}' >> output.Temp
done

#AVERAGE SCORES AND VARIANCES
$dir/sum.sh $k output.Temp $hyper $strategy

#CLEANING TEMPORARY FILES
$dir/clean.sh $k