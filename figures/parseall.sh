#!/bin/bash

CPWD=$PWD

for i in MoNb2BC
do
	cd /run/media/ondracka/DATA/DFT/MoXBC/MoXBC/$i
	bash $CPWD/parse.sh $CPWD
	cd  $CPWD
done

mv Cij.dat tmp
(head -n 1 tmp && tail -n +2 tmp | sort -n) > Cij.dat
mv parsed.txt tmp
(head -n 1 tmp && tail -n +2 tmp | sort -n) > parsed.txt
mv elmod.txt tmp
(head -n 1 tmp && tail -n +2 tmp | sort -n) > elmod.txt
rm tmp

