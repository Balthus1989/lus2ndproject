#!/bin/bash

for (( i=1; i<=4; i++)) do
    cat $2 | awk '{ SUM += $'$i'} END { print SUM/'$1' }' >> output2.Temp
done

cat output2.Temp | awk 'BEGIN{print "\nAVERAGE SCORES"} NR==1{print "Accuracy: " $0"%"} NR==2{print "Precision: " $0"%"} NR==3{print "Recall: " $0"%"} NR==4{print "FB-1: " $0"%"}'

read avgAcc < <(awk 'NR==1{print $0}' output2.Temp)
read avgPrec < <(awk 'NR==2{print $0}' output2.Temp)
read avgRec < <(awk 'NR==3{print $0}' output2.Temp)
read avgF1 < <(awk 'NR==4{print $0}' output2.Temp)

let kDen="$1 * ($1 - 1)"

declare -a var=( $(for i in {1..$1}; do echo 0; done))

echo -e "\nUNBIASED VARIANCES"
#Average Accuracy
for (( i=1; i<=$1; i++)) do
    read val< <(cat $2 | awk 'NR=='$i'{VAL = $1-'$avgAcc'} END {print VAL * VAL}')
    var[$i]=$val
done

#for ((j=1; j<=5; j++))do
#    echo "${var[$j]}"
#done 
 
let sumTot=0
let pippo=0

for (( i=1; i<=$1; i++ )) do
    read sumTot< <(awk "BEGIN {print $sumTot+${var[i]}; exit}")
done

read varAccFloat< <(awk "BEGIN {print $sumTot/$kDen; exit}")
read varAcc< <(awk "BEGIN {print $varAccFloat*100; exit}")
#read varAcc< <(echo $varAccPerc | awk '{print substr($0, 1, 10);}') 
echo "Accuracy: $varAcc%"

#Average Precision
declare -a var=( $(for i in {1..$1}; do echo 0; done))

for (( i=1; i<=$1; i++)) do
    read val< <(cat $2 | awk 'NR=='$i'{VAL = $2-'$avgPrec'} END {print VAL * VAL}')
    var[$i]=$val
done

let sumTot=0

for (( i=1; i<=$1; i++ )) do
    read sumTot< <(awk "BEGIN {print $sumTot+${var[i]}; exit}")
done

read varPrecFloat< <(awk "BEGIN {print $sumTot/$kDen; exit}")
read varPrec< <(awk "BEGIN {print $varPrecFloat*100; exit}")
#read varPrec< <(echo $varPrecPerc | awk '{print substr($0, 1, 10);}') 
echo "Precision: $varPrec%"

#Average Recall
declare -a var=( $(for i in {1..$1}; do echo 0; done))

for (( i=1; i<=$1; i++)) do
    read val< <(cat $2 | awk 'NR=='$i'{VAL = $3-'$avgRec'} END {print VAL * VAL}')
    var[$i]=$val
done

let sumTot=0

for (( i=1; i<=$1; i++ )) do
    read sumTot< <(awk "BEGIN {print $sumTot+${var[i]}; exit}")
done

read varRecFloat< <(awk "BEGIN {print $sumTot/$kDen; exit}")
read varRec< <(awk "BEGIN {print $varRecFloat*100; exit}")
#read varRec< <(echo $varRecPerc | awk '{print substr($0, 1, 10);}') 
echo "Recall: $varRec%"

#Average F1
declare -a var=( $(for i in {1..$1}; do echo 0; done))

for (( i=1; i<=$1; i++)) do
    read val< <(cat $2 | awk 'NR=='$i'{VAL = $4-'$avgF1'} END {print VAL * VAL}')
    var[$i]=$val
done

let sumTot=0

for (( i=1; i<=$1; i++ )) do
    read sumTot< <(awk "BEGIN {print $sumTot+${var[i]}; exit}")
done

read varF1Float< <(awk "BEGIN {print $sumTot/$kDen; exit}")
read varF1< <(awk "BEGIN {print $varF1Float*100; exit}")
# read varF1< <(echo $varF1Perc | awk '{print substr($0, 1, 10);}') 
echo "F-1: $varF1%"

echo -e "AVERAGE SCORES" > score.variancesFolds$1Param$3strategy$4
echo -e "Accuracy: "$avgAcc"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "Precision: "$avgPrec"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "Recall: "$avgRec"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "F-1: "$avgF1"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "\nUNBIASED VARIANCES" >> score.variancesFolds$1Param$3strategy$4
echo -e "Accuracy: "$varAcc"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "Precision: "$varPrec"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "Recall: "$varRec"%" >> score.variancesFolds$1Param$3strategy$4
echo -e "F-1: "$varF1"%" >> score.variancesFolds$1Param$3strategy$4