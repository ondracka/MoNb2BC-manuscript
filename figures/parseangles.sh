#!/bin/bash

rm BB.txt

./angles.py 0 9 >> BB.txt

for i in 0.0555556 0.125 0.25 0.375 0.5 0.75
do
   ./angles.py $i 3 >> BB.txt
done

./angles.py 1 9 >> BB.txt
