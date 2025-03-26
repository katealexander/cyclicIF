dataDir=$(echo "/Volumes/KAA2025/KD244a/Rep3_20250219")
projectName=$(echo "/Users/kalexander/Documents/IlastikModels/pixelClassification/FFPE_DNAclassifier_2/FFPE_DNAclassifier_2.ilp")
well=$1

#echo /Volumes/KAA2025/Rep1_20250129/A1/registration/o*.tiff
#echo $dataDir/$well/registration/o*.tiff
/Applications/ilastik-1.4.1rc2-arm64-OSX.app/Contents/MacOS/ilastik --headless \
--project="$projectName" \
--export_source="Probabilities" \
--output_format="tiff" \
--output_filename_format={dataset_dir}/{nickname}_probabilities.tiff \
"$dataDir/"$well"registration/DNA_2.tiff"
