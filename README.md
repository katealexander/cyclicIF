# Rationale
This provides instructions for image processing of CyCIF data generated in the Alexander Lab.
It uses some of the organization/structure as inspired by [McMICRO](https://mcmicro.org/), developed by the Sorger Lab.

# Imaging
We generally image at 20x with the focal plane determined by DNA Hoesht signal using Software Autofocus.
Tiles should overlap at least 10%.

# Stitching
Perform stitching within the Zeiss microscopy software using the following settings within Parameters:
1. Click "New Output"
2. 5% min overlap
3. 5% Max shift
Ensure that DNA channel is selected.   

# Needed files
Within your data directory, you need the following files:
1. Imaging files: Based on how we name our files, we have "Round[cycleNumber]", "(imageNumber)", and ".czi" present in each file name. If they are named differently, the sortingAndRenaming step below will need to be modified. If they are not ".czi" files, the MATLAB script "register.m" will need to be modified.
2. wellCodes.csv
3. markers.csv

# Well codes file
The file, wellCodes.csv, matches the imaging name to the sample. It is critical that wellCodes.csv accurately reflects which image belongs to which sample. Double check that this is accurate while imaging.

wellCodes.csv file example
```
imageNumber,well,Age,Sex,Organ/Anatomic Site,PathologyDiagnosis,TNM,Grade,Stage,Type,TissueID
6,A1,54,M,Kidney,Clear cell carcinoma,T1N0M0,1,I,Malignant,Ukn120014
5,A2,54,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn120014
4,A3,40,M,Kidney,Clear cell carcinoma,T1N0M0,1,I,Malignant,Ukn030023
3,A4,40,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030023
2,A5,59,F,Kidney,Clear cell carcinoma,T1N0M0,1,I,Malignant,Ukn030078
1,A6,59,F,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030078
7,B1,33,M,Kidney,Clear cell carcinoma,T1N0M0,1,I,Malignant,Ukn030349
8,B2,33,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030349
9,B3,76,M,Kidney,Clear cell carcinoma,T1N0M0,1,I,Malignant,Ukn030590
10,B4,76,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030590
11,B5,59,F,Kidney,Clear cell carcinoma,T3N0M0,1,III,Malignant,Ukn030159
12,B6,59,F,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030159
18,C1,46,M,Kidney,Clear cell carcinoma,T1N0M0,2,I,Malignant,Ukn030332
17,C2,46,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030332
16,C3,64,M,Kidney,Clear cell carcinoma,T1N0M0,2,I,Malignant,Ukn030586
15,C4,64,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030586
14,C5,57,M,Kidney,Clear cell carcinoma,T2N0M0,2,II,Malignant,Ukn030291
13,C6,57,M,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn030291
19,D1,35,F,Kidney,Chromophobe renal cell carcinoma,T1N0M0,2,I,Malignant,Ukn060101
20,D2,35,F,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn060101
21,D3,49,M,Kidney,Papillary renal cell carcinoma (type I),T1N0M0,-,I,Malignant,Ukn090017
22,D4,49,M,Kidney,Adjacent normal kidney tissue,-,-,-,NAT,Ukn090017
23,D5,71,F,Kidney,Papillary renal cell carcinoma (type I),T1N0M0,-,I,Malignant,Ukn070024
24,D6,71,F,Kidney,Cancer adjacent kidney tissue,-,-,-,AT,Ukn070024
```
In the above example, imaging occured as a snake, accounting for the count down then count up of wells matching the imaging number. The imaging number in wellCodes.csv should match the number present in the image file name. In addition to imageNumber and wells columns, it is useful later to have the sample information in this file. The first two columns are what's needed for sorting and renaming the files, the later columns are used after calculating per-nucleus measurements in CellProfiler.

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
    
* ensure cyclicIF is also added to the MATLAB path and within Documents > MATLAB
* In MATLAB, Install Image Processing Toolbox Add-Ons. From HOME window in MATLAB, click "Add-ons"
* In "runRegistration.sh", you will need to make sure that the path to MATLAB is correct

## Runing the Registration
In terminal, navigate to the directory that has all of the sample directories. This directory should have each of the wells as a directory, with image ".czi" files stored in well/raw. This directory should also have the "markers.csv" file.

From the command line, the following will loop through each well directory to run the registration.

```for dir in */; do ./runRegistration.sh $dir; done```

The above script will create a new directory in each well directory, called "registration". It will save the registered images to the registration directory with new names according the the markers file. It will also output registrationStats.csv. In our initial tests, we noted that when the DNA staining quality was poor, with low signal to noise, the peak correlation statistic was lower; however, the images were still accurately aligned. 

CRITICAL STEP: Check registrationStats.csv for each well. The peak correlation should be >0.7. If it is lower, check the images in Fiji, comparing the reference DNA channel to the poorly registered cycle. Noisy images may have 0.4, but still be properly registered. Incorrect registration will be 0.3 and lower. 

NOTE: Registration will fail if stitching was not optimal, or if stitching was done using different parameters for different cycles. Another reason for registration failure is poor image quality of one round.

# Using Ilastik
[Ilastik](https://www.ilastik.org/) is a machine learning tool that can be trained to recognize pixel classes and object classes from imaging data. While powerful, keep in mind that it will behave as it is trained, meaning that the amount and type of training can influence the output.

To re-use the same trained model between replicates or different wells in an experiment, models should be saved locally together with the data used for training. Create the directories Documents>IlasticModels>pixelClassification and Documents>IlasticModels>nucleiClassification. This will be where trained models and training data are stored. Give each model its own directory, called the same name as the .ilp file (without ".ilp") that contains the ilastik model together with a "data" folder. The data folder will be where the training data is kept. 

Best practices:
* Train models on diverse sample types within the experiment (eg adjacent and tumor samples, Grade 1 and Grade 2 samples)
* Include the same sample from all replicates to ensure that the model is robust across replicates
* Ensure the training appears accurate across multiple samples
* Use the same trained model on all the samples and replicates within an experiment


# Segmentation
Used [ilastik](https://www.ilastik.org/) pixel classifier to segment nuclei stain. Here, setting three labels works best: background, in between, and nucleus. The "in between" label should be drawn in between two adjoining nuclei. This assists with distinguishing clumped nuclei later. 
After training the classifier, save the results to "DNA_2_Probabilities.tiff" within each well's registration folder by using batch processing within the GUI.
Model used: "FFPE_DNAclasifier_2.ilp"

# Nucleus classification
In ilastik, nuclei were classified into alphaSMA, CD31+SMA+, CD31, CD4, CD4/CD8 (double positive), CD8, and epithelial using the below channels. 

Notes on training:
* Intensity and neighborhood features were used
* The texture features make it take much longer to train and run

The trained model was saved as "nuclearClassificationFFPE.v2.ilp". Then, each of the wells were processed for nuclei classification.

Before processing, they needed to be renamed so that they could be called to using "o\*.tiff" within the script.

Renaming the tiff files that are used for nuclei classification:
```
for dir in */; do mv "$dir"registration/AlphaSMA.tiff "$dir"registration/oAlphaSMA.tiff; done
for dir in */; do mv "$dir"registration/CD31.tiff "$dir"registration/oCD31.tiff; done
for dir in */; do mv "$dir"registration/CD4.tiff "$dir"registration/oCD4.tiff; done
for dir in */; do mv "$dir"registration/CD8.tiff "$dir"registration/oCD8.tiff; done
for dir in */; do mv "$dir"registration/DNA_2.tiff "$dir"registration/oDNA_2.tiff; done
for dir in */; do mv "$dir"registration/SON.tiff "$dir"registration/oSON.tiff; done
for dir in */; do mv "$dir"registration/SRRM2.tiff "$dir"registration/oSRRM2.tiff; done
```

Before running the below script in Terminal, make sure that the registration folder contains "DNA_2_Probabilities.tiff" and that each of the desired tiff files above were correctly renamed to begin with "o"

Within the runIlastikNucleiClassification.sh, edit dataDir to reflect the directory that the data is in, edit projectName to reflect the full path and name of the Ilastik project.

Running nuclei classifcation:
```for dir in */; do /Users/kalexander/Documents/MATLAB/cyclicIF/runIlastikNucleiClassifier.sh $dir; done```

The nuclei classification outputs two files per well:
* "o_Object Predictions.tiff" within the registration folder, which contains each nucleus classifcation. 
* "exportedObjectFeatures_table.csv"

# Per-nucleus measurements in CellProfiler
Used the CellProfiler pipeline, "MeasureIntensityNucleus.cpproj" to measure nucleus features.

This pipeline requires inputs of:
1. "o_Object Prediction.tiff" from Nucleus Classification above
2. "oDNA_2.tiff"
3. "oSON.tiff"
4. "oSRRM2.tiff"

It outputs:
1. A tiff file
