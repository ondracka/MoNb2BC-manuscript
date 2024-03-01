#!/bin/bash

echo "#x K(GPa) E(GPa) G(GPa) gamma" > elmod.txt
echo "#x C11 C22 C33 C12 C13 C23 C44 C55 C66" > Cij.dat
DIR=$1

extract_cxy() {
	cat "eps=0.014/Cij.dat" | awk -v x=$1 -v y=$2 '{if($NR == $x) printf "%.3f ", $y}' >> $DIR/Cij.dat
}

parse_elmod() {
	mkdir elmod/eq
	cp pw.out elmod/eq
	cd elmod || exit
	ELASTIC=$(~/dft-utils/Cij/calculate_Cij.py -q)
	E=$(grep "Hills E" <<< "$ELASTIC" | awk '{print $3}')
	K=$(grep "Hills K" <<< "$ELASTIC" | awk '{print $3}')
	G=$(grep "Hills G" <<< "$ELASTIC" | awk '{print $3}')
	gamma=$(grep "Hills gamma" <<< "$ELASTIC" | awk '{print $3}')
	echo "$K $E $G $gamma" >> $DIR/elmod.txt
	extract_cxy 1 1
	extract_cxy 2 2
	extract_cxy 3 3
	extract_cxy 1 2
	extract_cxy 1 3
	extract_cxy 2 3
	extract_cxy 4 4
	extract_cxy 5 5
	extract_cxy 6 6
	echo "" >> $DIR/Cij.dat
	cd ..
}

echo "#x ENE(eV/atom) VOL(A3) A(A) B(A) C(A)" > $DIR/parsed.txt
echo "#x C11 C22 C33 C12 C13 C23 C44 C55 C66" > $DIR/Cxx.txt

for i in 0.0555556 0.125 0.25  0.375  0.5  0.75 
do
	cd $i || exit
	printf "$i " >> $DIR/parsed.txt
	printf "$i " >> $DIR/elmod.txt
	printf "$i " >> $DIR/Cij.dat
	ENE=$(grep "! *total energy" pw.out  | tail -n 1 | awk '{printf "%.5f\n", $5*13.605698066/144}') # *13.6056}'
	COORDINATES=$(grep -A 7 "Begin final coordinates" pw.out)
	VOLUME=$(grep "volume" <<< "$COORDINATES" | awk '{print $8/9}')
	A=$(awk '{if(NR==6){print sqrt($1*$1+$2*$2+$3*$3)/3}}' <<< "$COORDINATES")
	B=$(awk '{if(NR==7){print sqrt($1*$1+$3*$3+$2*$2)}}' <<< "$COORDINATES")
	C=$(awk '{if(NR==8){print sqrt($1*$1+$3*$3+$2*$2)/3}}' <<< "$COORDINATES")
	echo "$ENE $VOLUME $A $B $C" >> $DIR/parsed.txt
	parse_elmod
	cd ..
done

for i in 1 0 
do
	cd $i || exit
	printf "$i " >> $DIR/parsed.txt
	printf "$i " >> $DIR/elmod.txt
	printf "$i " >> $DIR/Cij.dat
	ENE=$(grep "! *total energy" pw.out  | tail -n 1 | awk '{printf "%.5f\n", $5*13.605698066/16}') # *13.6056}'
	COORDINATES=$(grep -A 7 "Begin final coordinates" pw.out)
	VOLUME=$(grep "volume" <<< "$COORDINATES" | awk '{print $8}')
	A=$(awk '{if(NR==6){print sqrt($1*$1+$2*$2+$3*$3)}}' <<< "$COORDINATES")
	B=$(awk '{if(NR==7){print sqrt($1*$1+$3*$3+$2*$2)}}' <<< "$COORDINATES")
	C=$(awk '{if(NR==8){print sqrt($1*$1+$3*$3+$2*$2)}}' <<< "$COORDINATES")
	echo "$ENE $VOLUME $A $B $C" >> $DIR/parsed.txt
	parse_elmod
	cd ..
done
