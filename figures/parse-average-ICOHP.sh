#!/bin/bash

rm average-ICOHP.txt
A1S=" B   B     B     C     Mo,Nb"
A2S=" B   Nb,Mo Mo,Nb Mo,Nb Mo,Nb"
MINS="1.7 2.2   2.6   2.0   2.5"
MAXS="2.0 2.5   3.3   2.4   3.8"  
A1S=($A1S)
A2S=($A2S)
MINS=($MINS)
MAXS=($MAXS)

printf "# " >> average-ICOHP.txt
for j in 0 1 2 3 4
do
	printf "${A1S[$j]}-${A2S[$j]} " >> average-ICOHP.txt
done
echo "" >> average-ICOHP.txt

echo ${MINS[0]}
for i in 0 0.0555556 0.125 0.25 0.375 0.5 0.75 1
do
	printf "$i " >> average-ICOHP.txt
	for j in 0 1 2 3 4
	do
		echo "~/dft-utils/average-iCOOHP.py -min ${MINS[$j]} -max ${MAXS[$j]} -a1 ${A1S[$j]} -a2 ${A2S[$j]} $i/ICOHPLIST.lobster"
        	~/dft-utils/average-iCOOHP.py -min ${MINS[$j]} -max ${MAXS[$j]} -a1 ${A1S[$j]} -a2 ${A2S[$j]} $i/ICOHPLIST.lobster | tr '\n' ' ' >> average-ICOHP.txt
	done
	echo "" >> average-ICOHP.txt
done
