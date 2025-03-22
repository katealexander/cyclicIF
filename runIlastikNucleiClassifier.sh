dataDir=$(echo "/Volumes/KAA2025/Rep2_20250205")
projectName=$(echo "/Users/kalexander/Documents/ilastikModels/nuclearClassification/nuclearClassificationFFPE.v2/nuclearClassificationFFPE.v2.ilp")
well=$1

#echo /Volumes/KAA2025/Rep1_20250129/A1/registration/o*.tiff
#echo $dataDir/$well/registration/o*.tiff
/Applications/ilastik-1.4.1rc2-arm64-OSX.app/Contents/MacOS/ilastik --headless \
--project="$projectName" \
--table_filename="$dataDir/"$well"exportedObjectFeatures.csv" \
--export_source="Object Predictions" \
--stack_along="c" \
"$dataDir/"$well"registration/o*.tiff" \
--prediction_maps "$dataDir/"$well"registration/DNA_2_Probabilities.tiff"
