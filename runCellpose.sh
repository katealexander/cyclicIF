dir=$1
fullpath=$(realpath "$dir")


python3 -m cellpose --image_path $fullpath/registration/addedCytoplasmWithDAPI7.tiff --pretrained_model CP_FFPE_nuclei13 --chan 1 --chan2 2 --save_tif --output_name masks --verbose --use_gpu --diameter 30
