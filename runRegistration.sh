PATH="$PATH:/Applications/MATLAB_R2024b.app/bin/"
well=$1
echo "well='$1'"
matlab -nosplash -nodesktop -r "disp('$well'); well='$well'; register; exit"
