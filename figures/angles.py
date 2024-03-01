#!/bin/env python3

import numpy as np
from sys import argv
from ase import io
from ase.geometry.analysis import Analysis
from ase.build import make_supercell

mol = io.read("/run/media/ondracka/DATA/DFT/MoXBC/MoNb2BC-lobster/" + argv[1] + "/MoNb2BC.cif")
mol.set_pbc([1,1,1]) 
spc = make_supercell(mol, [[int(argv[2]),0,0],[0,1,0],[0,0,int(argv[2])]])
ana = Analysis(spc)
CCBonds = ana.get_bonds('B', 'B', unique=True)
CCCAngles = ana.get_angles('B', 'B', 'B', unique=True)
#print("There are {} B-B bonds in C60.".format(len(CCBonds[0])))
#print("There are {} B-B-B angles in C60.".format(len(CCCAngles[0])))

CCBondValues = ana.get_values(CCBonds)
CCCAngleValues = ana.get_values(CCCAngles)

iCOHPs = []
for line in open("/run/media/ondracka/DATA/DFT/MoXBC/MoNb2BC-lobster/" + argv[1] + "/lobsteranalysis/BB.txt"):
    l = line.split()
    if float(l[0]) > 1.5 and float(l[0]) < 2.0:
        iCOHPs.append(float(l[1]))
        
metaliCOHPs = []
for line in open("/run/media/ondracka/DATA/DFT/MoXBC/MoNb2BC-lobster/" + argv[1] + "/lobsteranalysis/BNb.txt"):
    l = line.split()
    if float(l[0]) > 2.6 and float(l[0]) < 3.2:
        metaliCOHPs.append(float(l[1]))

for line in open("/run/media/ondracka/DATA/DFT/MoXBC/MoNb2BC-lobster/" + argv[1] + "/lobsteranalysis/BMo.txt"):
    l = line.split()
    if float(l[0]) > 2.6 and float(l[0]) < 3.2:
        metaliCOHPs.append(float(l[1]))

print("{} {} {} {} {} {} {} {} {}".format(argv[1], np.average(CCBondValues), np.std(CCBondValues), np.average(CCCAngleValues), np.std(CCCAngleValues), np.average(iCOHPs), np.std(iCOHPs), np.average(metaliCOHPs), np.std(metaliCOHPs)))
