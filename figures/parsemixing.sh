#!/bin/bash

DATADIR=/run/media/ondracka/DATA/DFT/MoXBC/MoXBC/MoNb2BC/

Mo2BC=$(grep "!" $DATADIR/0/pw.out | tail -n 1 | awk '{print $5*9}')
Nb2BC=$(grep "!" $DATADIR/1/pw.out | tail -n 1 | awk '{print $5*9}')

echo 0 0 0

for i in 0.0555556 0.125 0.25 0.375 0.5 0.75
do
   ENE=$(grep "!" $DATADIR/$i/pw.out | tail -n 1 | awk '{print $5}')
   ENEMo=$(grep "!" $DATADIR/$i/Mo2BC/*pw.out | tail -n 1 | awk '{print $5*9}')
   ENENb=$(grep "!" $DATADIR/$i/Nb2BC/*pw.out | tail -n 1 | awk '{print $5*9}')
   awk "{print $i, ($ENE - $Mo2BC*(1-$i) - $Nb2BC * $i)*13.605703976/144, ($ENE - $ENEMo*(1-$i) - $ENENb * $i)*13.605703976/144}" <<< ""
done

echo 1 0 0
