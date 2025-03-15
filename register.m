%% Image registration
% This pipleline works using bfmatlab, which needs to be downloaded and 
% added to the MATLAB path

%% Make a fresh start
%clear all; close all; clc;

%% User input or changable variables
dataDir = pwd;
%well = 'C1';
xPixels = 5315; % images will be cropped to this # of pixels
yPixels = 5280;
outDir = strcat(dataDir,"/",well,'registration/'); 
disp(outDir)
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

%% Load markers file
markers = readtable(strcat(dataDir,'/markers.csv'), "ReadVariableNames",true, "VariableNamingRule","preserve");

%% Load the image data, process the registration, and save each channel to the "registration" folder
files = dir(strcat(dataDir,"/",well,'raw/*.czi'));
outTable = strings(length(files), 2); % this will contain the peakCorr values from imregcorr, an indication of the registration success
for i = 1:length(files)
    fileName = strcat(dataDir,"/",well,"raw/",files(i).name);
    fileName = char(fileName);
    t = strsplit(files(i).name, '-'); t = t{1,2};t = strsplit(t, '.'); t = t{1,1}; cycle = str2double(t); [idx] = find(markers.cycle_number==cycle); nArray = markers.marker_name(idx);
    outTable(i) = files(i).name;
    image = bfopen(fileName);
    for j = 1:length(image{1})
        channelImage = image{1}{j};
        croppedImage = channelImage(1:xPixels,1:yPixels);
        marker = nArray{j,1};
        outFileName = strcat(outDir, marker, ".tiff");
        if i == 1 && j == 1 %the reference DNA stain
            fixed = croppedImage; 
            Rfixed = imref2d(size(fixed));
            imwrite(croppedImage,outFileName);
            outTable(i,2) = 1.00;
            continue
        end
        if i == 1 %the reference other channels
            imwrite(croppedImage,outFileName);
        else 
            if j == 1 %the non-reference DNA stain
                moving = croppedImage;
                [tformEstimate,peakCorrEstimate] = imregcorr(moving, fixed);
                movingReg = imwarp(moving, tformEstimate,"OutputView",Rfixed);
                imwrite(movingReg,outFileName);
                outTable(i,2) = peakCorrEstimate;
            else %the non-reference other channels
                croppedImageReg = imwarp(croppedImage, tformEstimate,"OutputView",Rfixed);
                imwrite(croppedImageReg,outFileName);
            end
        end
    end
end

%% Save the output table
tableName = strcat(dataDir,"/",well,'registration/registrationStats.csv');
writematrix(outTable, tableName);
