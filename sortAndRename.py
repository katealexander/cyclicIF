#!/usr/bin/python3

## if different number of cycles are used, the renaming may need to be adjusted by adding additional if statements

import sys, os, re

def main(args):
    if not len(args) == 2: sys.exit("USAGE: python3 sortAndRenameForMCMICRO.py wellCodes.csv")

    f = open(args[1])
    line = f.readline()[:-1]
    line = f.readline()[:-1]
    while line != "":
        print(line)
        imageNumber = line.split(",")[0]
        well = line.split(",")[1]
        cmd = "mkdir " + well
        os.system(cmd)
        cmd = "mkdir " + well + "/raw"
        os.system(cmd)
        
        ## rename the ome-tiff files from e.g. "Round3_CD3_CD4_Hoechst-01(1)-OME TIFF-Export.ome.tiff" to "Well_cycle-03.ome.tiff"
        files = os.listdir()
        filesInWell = [item for item in files if ("(" + imageNumber + ")") in item]
        for file in filesInWell:
            if "Round1" in file:
                newName = well + "_cycle-01.czi"
            if "Round2" in file:
                newName = well + "_cycle-02.czi"
            if "Round3" in file:
                newName = well + "_cycle-03.czi"
            if "Round4" in file:
                newName = well + "_cycle-04.czi"
            if "Round5" in file:
                newName = well + "_cycle-05.czi"
            cmd = 'mv "' + file + '" ' + well + '/raw/' + newName
            os.system(cmd)
        line = f.readline()[:-1]

    f.close()

if __name__ == "__main__": main(sys.argv)

    
