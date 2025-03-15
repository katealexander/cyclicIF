# Rationale
This provides instructions for image processing of CyCIF data generated in the Alexander Lab.
It uses some of the organization/structure as inspired by [McMICRO](https://mcmicro.org/), developed by the Sorger Lab.

# Imaging
We generally image at 20x with the focal plane determined by DNA Hoesht signal using Software Autofocus.
Tiles should overlap at least 10%.

# Stitching
Perform stitching within the Zeiss microscopy software.

# Needed files
Within your data directory, you need the following files:
1. Imaging files: Based on how we name our files, we have "Round[cycleNumber]", "(imageNumber)", and ".czi" present in each file name. If they are named differently, the sortingAndRenaming step below will need to be modified. If they are not ".czi" files, the MATLAB script "register.m" will need to be modified.
2. wellCodes.csv
3. markers.csv

# Well codes file
The file, wellCodes.csv, matches the imaging name to the sample. It is critical that wellCodes.csv accurately reflects which image belongs to which sample. Double check that this is accurate while imaging.

wellCodes.csv file example
```
imageNumber,well
1,A6
2,A5
3,A4
4,A3
5,A2
6,A1
7,B1
8,B2
9,B3
10,B4
11,B5
12,B6
13,C6
14,C5
15,C4
16,C3
17,C2
18,C1
19,D1
20,D2
21,D3
22,D4
23,D5
24,D6
```
In the above example, imaging occured as a snake, accounting for the count down then count up of wells matching the imaging number. The imaging number in wellCodes.csv should match the number present in the image file name.

# Markers file
The file, markers.csv, will encode which cycle is which marker using the "marker_name" column. For this reason, every marker_name needs to be unique.

markers.csv file example
```
channel_number,cycle_number,marker_name,filter,excitation wavelength,emission wavelength
1,1,DNA_1,DNA_1,353,465
2,1,A488_background,AF488,493,517
3,1,A647_background,Cy5,650,673
4,2,DNA_2,DNA_2,353,465
5,2,SON,AF488,493,517
6,2,SRRM2,Cy5,650,673
7,3,DNA_3,DNA_3,353,465
8,3,CD8,AF488,493,517
9,3,CD4,AF568,577,603
10,3,CD3D,Cy5,650,673
11,4,DNA_4,DNA_4,353,465
12,4,PAX8,AF488,493,517
13,4,AlphaSMA,AF568,577,603
14,4,CD31,Cy5,650,673
15,5,DNA_5,DNA_5,353,465
16,5,HCS,AF488,493,517
```

Also avoid spaces or special characters in the marker_name column. 

# Rename and sort imaging files
The following python script sorts and renames the imaging files so that each imaging sample gets its own directory, with simplified file names according to imaging cycle. Note that the Python script may need to be amended depending on the number of rounds (adding or subtracting if statments within for loop)

```python3 sortAndRename.py wellCodes.csv```


# Registration
## Before running registration
The following will just need to be set up before the first use:
* MATLAB 2024b was used. If downloading for Mac, make sure that the Downloaded version matches your processor (Intel vs Silicon; About This Mac > Chip tells you this info). For CSHL, intranet search for "software" gets you to the link for the CSHL MATLAB liscence.
* Download [bfmatlab](https://www.openmicroscopy.org/bio-formats/downloads/) 
  * Upon downloading, move bfmatlab to your Documents > MATLAB folder. Create a new MATLAB folder there if it doesn't exist
  * Within MATLAB command line, need to add bfmatlab to your path:
  
    ```
    addpath('/path/to/bfmatlab')
    savepath
    ```
    
* ensure registrationCyCIF is also added to the MATLAB path and within Documents > MATLAB
* In MATLAB, Install Image Processing Toolbox Add-Ons. From HOME window in MATLAB, click "Add-ons"
* In "runRegistration.sh", you will need to make sure that the path to MATLAB is correct

## Runing the Registration
In terminal, navigate to the directory that has all of the sample directories. This directory should have each of the wells as a directory, with image ".czi" files stored in well/raw. This directory should also have the "markers.csv" file.

From the command line, the following will loop through each well directory to run the registration.
```for dir in */; do ./runRegistration.sh $dir; done```

The above script will create a new directory in each well directory, called "registration". 
