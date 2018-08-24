#!/bin/bash

echo -n "Do you want to remove temporary files? The result files will not be deleted (y/n)> "
read del

if [ $del == 'y' ]
then
    for (( i=1; i<=$1; i++)) do
        rm -f train$i*
        rm -f test$i*
        rm -f model$i
        rm -f output$i
        rm -f output.Temp
        rm -f output2.Temp
    done

    rm -f traintotal.numphrase
    rm -f total.temp
fi