#!/bin/bash

# SHUFFLING
shuffle=y

while [ "$shuffle" != "n" ]
do
    cat $1 | awk '
    BEGIN{srand(); n=rand()}
      {print n, NR, $0}
      !NF {n=rand()}
      END {if (NF) print n, NR+1, ""}' |
      sort -nk1 -k2 |
      cut -d' ' -f3- > total.dataset 
    echo -n "Do you want to keep shuffle? (y/n) > "
    read shuffle
done

