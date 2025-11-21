dataDir=$(pwd)
projectName=$(echo "/Users/kalexander/Documents/MATLAB/cyclicIF/classifyNuclei.v8.ilp")
well=$1

#echo $dataDir/$well/registration/o*.tiff
/Applications/ilastik-1.4.1rc2-arm64-OSX.app/Contents/MacOS/ilastik --headless \
--project="$projectName" \
--table_filename="$dataDir/"$well"exportedObjectFeatures.csv" \
--export_source="Object Predictions" \
--stack_along="c" \
"$dataDir/"$well"registration/o*.tiff" \
--segmentation_image "$dataDir/"$well"registration/addedCytoplasmWithDAPI7masks.tif"
