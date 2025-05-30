dir=$1
fullpath=$(realpath "$dir")


python3 -m cellpose --image_path $fullpath/registration/addedCytoplasmWithDAPI2.tiff --add_model /Documents/cellpose_FFPE_trainingImages/models  --pretrained_model CP_FFPE_nuclei --chan 1  --save_tif --output_name masks
