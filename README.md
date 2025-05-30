# Rationale
This provides instructions for image processing of CyCIF data generated in the Alexander Lab.
It uses some of the organization/structure as inspired by [McMICRO](https://mcmicro.org/), developed by the Sorger Lab.

# Imaging
We generally image at 20x with the focal plane determined by DNA Hoesht signal using Software Autofocus.
Tiles should overlap at least 10%.

To keep exposures more consistent between replicates, find a well to serve as a reference for each protein stain/channel. This should be a well with bright signal because we want to avoid overexposure. 

# Marker failure annotation
During imaging, keep track of whether a marker failed. Create a new text document, called "failedMarkers.txt", and add failed markers to the document. 

# Stitching
Perform stitching within the Zeiss microscopy software using the following settings within Parameters:
1. Click "New Output"
2. Check "Fuse tiles"
3. 5% min overlap
4. 5% Max shift
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

For blinded experiments, wellCodes.csv should just have the image number and well position.

# Markers file
The file, markers.csv, will encode which cycle is which marker using the "marker_name" column. For this reason, every marker_name needs to be unique. Cycle number should be two digits, e.g. "01" instead of "1" (edit in text format rather than excel/numbers to avoid autocorrection)

markers.csv file example
```
channel_number,cycle_number,marker_name,filter,excitation wavelength,emission wavelength
1,01,DNA_1,DNA_1,353,465
2,01,A488_background,AF488,493,517
3,01,A647_background,Cy5,650,673
4,02,DNA_2,DNA_2,353,465
5,02,SON,AF488,493,517
6,02,SRRM2,Cy5,650,673
7,03,DNA_3,DNA_3,353,465
8,03,CD8,AF488,493,517
9,03,CD4,AF568,577,603
10,03,CD3D,Cy5,650,673
11,04,DNA_4,DNA_4,353,465
12,04,PAX8,AF488,493,517
13,04,AlphaSMA,AF568,577,603
14,04,CD31,Cy5,650,673
15,05,DNA_5,DNA_5,353,465
16,05,HCS,AF488,493,517
```

Avoid spaces or special characters in the marker_name column. 

# Rename and sort imaging files
The following python script sorts and renames the imaging files so that each imaging sample gets its own directory, with simplified file names according to imaging cycle. 

The Python script will need to be amended depending on the number of rounds (adding or subtracting if statments within for loop)

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

The above script will create a new directory in each well directory, called "registration". It will save the registered images to the registration directory with new names according the the markers file.

## Checking the registration statistics
The registration stats are a key indication of whether cells were lost between cycles or if there's other quality issues with a sample. The peak correlation should be >0.7. If it is lower, check the images in Fiji, comparing the reference DNA channel to the poorly registered cycle. Noisy images may have 0.4, but still be properly registered. Incorrect registration will be 0.3 and lower and should be marked for exclusion from the final analysis. 

Use the Rscript, "registration_stat.R" to generate a table of registration statistics, and "registration_heatmap.R" to visualize the registration statistics.

This will help identify which wells should be excluded from future analysis. Put these wells into a new folder, called "zExcludedWells"

# Nucleus segmentation with CellPose
Used the CellProfiler pipeline, "makeCytoplasmMask" to combine the cytoplasmic stains into one image: 
1. Within CellProfiler, in the Images tab clear the files that are currently there, then right click and browse for folders to select to parent directory that has all of your image directories. Click on "Apply filteres to the file list" to filter the files that will be loaded. 
2. In NamesAndTypes, make sure the desired markers are represented. Delete markers that are not used in this experiment. Click Update
3. Click on "Analyze Images". This will create a new image within each well, called "addedCytoplasmWithDAPI2"

This is then used in combination with the DNA signal to detect nuclei using [CellPose](https://cellpose.readthedocs.io/en/latest/installation.html). Ensure all dependencies are met before starting. 

The makeCytoplasmMask CellProfiler pipeline also outputs cropped images that can be used to train CellPose models. This part can be unchecked within CellProfiler if a model is trained already.

I trained the model, entitled CP_FFPE_nuclei, from the cyto3 CellPose model. It works fairly well for our data and can likely be used for future segmentation without need for additional training. 

To run for all the wells within a folder
```
for dir in */; do ./runCellpose.sh $dir; done
```
The path to to CellPose model will need to be specified. 

The results of this script will output a file ending in "masks.tif" that contains the nucleus segmentations to be loaded into Ilastic for nucleus classification.


# Nucleus classification
[Ilastik](https://www.ilastik.org/) is a machine learning tool that can be trained to recognize pixel classes and object classes from imaging data. While powerful, keep in mind that it will behave as it is trained, meaning that the amount and type of training can influence the output. Models should be saved locally together with the data used for training.

Prior to training, rename the image files to be used for classification:
```
for dir in */; do mv "$dir"registration/AlphaSMA.tiff "$dir"registration/oAlphaSMA.tiff; done
for dir in */; do mv "$dir"registration/CD3D.tiff "$dir"registration/oCD3D.tiff; done
for dir in */; do mv "$dir"registration/CD4.tiff "$dir"registration/oCD4.tiff; done
for dir in */; do mv "$dir"registration/CD8.tiff "$dir"registration/oCD8.tiff; done
for dir in */; do mv "$dir"registration/CD11C.tiff "$dir"registration/oCD11C.tiff; done
for dir in */; do mv "$dir"registration/CD15.tiff "$dir"registration/oCD15.tiff; done
for dir in */; do mv "$dir"registration/CD20.tiff "$dir"registration/oCD20.tiff; done
for dir in */; do mv "$dir"registration/CD31.tiff "$dir"registration/oCD31.tiff; done
for dir in */; do mv "$dir"registration/CD45.tiff "$dir"registration/oCD45.tiff; done
for dir in */; do mv "$dir"registration/CD68.tiff "$dir"registration/oCD68.tiff; done
for dir in */; do mv "$dir"registration/CollagenIV.tiff "$dir"registration/oCollagenIV.tiff; done
for dir in */; do mv "$dir"registration/DNA_2.tiff "$dir"registration/oDNA_2.tiff; done
for dir in */; do mv "$dir"registration/PanCytokeratin.tiff "$dir"registration/oPanCytokeratin.tiff; done
for dir in */; do mv "$dir"registration/SON.tiff "$dir"registration/oSON.tiff; done
for dir in */; do mv "$dir"registration/SRRM2.tiff "$dir"registration/oSRRM2.tiff; done
for dir in */; do mv "$dir"registration/VIM.tiff "$dir"registration/oVIM.tiff; done
```

This makes it easier to select the images for classification.

Within Ilastik
1. Select "Object Classification [Inputs: Raw Data, Segmentation]"
2. Add raw data by clicking, "Add New"
    - Add single 3D/4D Volume from Sequence
    - Choose all of the channels to be used for classification
    - At the bottom, Stack Across C and click "Ok"
    - Double click on the nickname to rename to the well name
3. Within Segmentation Image tab, add the masks.tif file (Add Separate Image). Segmentation images need to be added in the same order as the Raw Data, otherwise it won't know which segmentation belongs to which images.
4. Default feature selection
    - The neighborhood was set to 50x50 pixels (20x objective, with 2x2 binning)
    - The texture features make it take much longer to train and run


## Training
Best practices:
* Train models on diverse sample types within the experiment (eg adjacent and tumor samples, Grade 1 and Grade 2 samples)
* Ensure the training appears accurate across multiple samples

Tips:
* Prior to starting select sample types that have clear representations of the desired classes
* Have a clear idea of which classes involve multiple markers before starting. For example, endothelial cells can be alone, next to SMA, or next to collagen. If you are confused when training, the model will also get confused.
* Choose a small area and try to classify every nucleus in that area. The most common misclassifications are false positives that are next to true positives.
* Start with "easy" classes (e.g. CD4, CD8, CD4CD8), then move on to the more complicated ones (e.g. different types of endothelial cells). 
* Include a class, "disloged" for nuclei that are lost between cycles and missing a subset of the stains. Find a sample with mediocre registration statistics to define these.

The trained model was saved as "nuclearClassificationFFPE.v2.ilp". Then, each of the wells were processed for nuclei classification.

## Running the model
Before running the below script in Terminal, make sure that the registration folder contains the masks.tif file and that each of the markers used in classification are named to begin with "o"

Within the runIlastikNucleiClassification.sh, edit dataDir to reflect the directory that the data is in, edit projectName to reflect the full path and name of the Ilastik project. Ensure that the masks file has the correct name.

Test the classification script on one well:
```
./runIlastikNucleiClassifier.sh A3/
```

Run nuclei classifcation on all wells:
```for dir in */; do ./runIlastikNucleiClassifier.sh $dir; done```

The nuclei classification outputs two files per well:
* "o_Object Predictions.tiff" within the registration folder, which contains each nucleus classifcation. 
* "exportedObjectFeatures_table.csv"

# Per-nucleus measurements in CellProfiler
Used the CellProfiler pipeline, "MeasureIntensityNucleus.cpproj" to measure nucleus features.

This pipeline requires inputs of:
1. "o_Object Prediction.tiff" from Nucleus Classification above
2. "oDNA_2.tiff"
3. "DNA_7.tiff" - This should be the last cycle of DNA imaged. It helps confirm lost nuclei to be discared from analysis.
4. "oSON.tiff"
5. "oSRRM2.tiff"
6. "Ki67.tiff" - Note that Ki67 was not used to classify objects, but is used to described proliferation state of classified objects. This is why it is included here, but not in classifications step.
Include any other cell state markers. 

From the nuclei clasifications, the "o_Object Predictions.tiff" file contains the nucleus classes, in which each nucleus gets a value according to its class.
The values are separated by 0.004, so in the ClassifyObjects module within CellProfiler, a vector of 0.04 spaced values will tell CP which nuclei belong to which class
The classes will be in the order that they were set as classes in Ilastik.

Example with 24 classes. The vector of values is 23 in length.
```
0.004,0.008,0.012,0.016,0.02,0.024,0.028,0.032,0.036,0.04,0.044,0.048,0.052,0.056,0.06,0.064,0.068,0.072,0.076,0.080,0.084,0.088,0.092
CD8,CD4CD8,CD4,CD20,CD20CD11C,CD11C,CD68,CD15CD45,CD15KRT,KRTmed,KRThigh,KRTVIM,VIM,CD31alone,CD31COLIVtight,CD31COIVloose,CD31nearSMA,SMAnearCD31,SMAalone,GlomCD31,SMAKRT,GlomVIM,CD45alone,dislodged
```

In the DisplayDataOnImage module, the Color map range will need to be adjusted depending on the number of classes.

It outputs:
1. A tiff file called "nucleusClasses.tiff"
2. Measurements files, the most important of which being "measurementsnuclei.csv", which contains all the measurements for all the nuclei in the experiment.  

# Calculating per-sample information
With the table, "measurmentsnuclei.csv", we now have speckle measurements, classifications, and proliferation (Ki67) measurements for each nucleus. To relate this to sample metadata, we will need to calculate per-sample values for each item of interest.

For speckle measurements, we want to calculate the median for all the cells in the sample, in cancer/epithelial cells vs non-cancer, and in each cell type. For this reason, we make three files, one for each of these.

For tumor microenvironment, we want to calculate per-sample amounts of each cell type. This is simple, we just add.

The script, "process.R", calculates all this and outputs four files into the directory, "wellLevelProcessedData":
1. nucleiCounts.csv - a counts table of the number of nuclei in each class for each sample.
2. median_totals.csv - medians for all quantitative measurements. Median calcualted for all cell types regardless of classification 
3. median_cancerNonCancer.csv - medians as above, but each sample has the median for the non-cancer and cancer/epithelial cell types calculated.
4. median_per_cellType.csv - medians as above, but each sample has the median calculated for each cell type.

To start, process.R does some quality control to exclude tiny and huge nuclei, nuclei that are strangely shaped, and nuclei classified as dislodged. These settings need to be double checked in each experiment.

Under the section "OUTPUT TABLE OF MEDIAN VALUES PER WELL", the exact classifications that define cancer/epithelial cell types will need to be checked and updated if needed. 

# Relate to sample metadata
With per-sample measurements in hand, we are ready to make graphs! The types of graphs generated depend on the questions to be addressed. In general, we want to have graphs that are sanity checks for our experiment behaving how we expect and graphs that quantify key hypotheses/findings. 

The key variable for defining speckle states is the fraction of SON speckle signal in the center of the nucleus, called "RadialDistribution_FracAtD_SONenhanced_1of4". 


