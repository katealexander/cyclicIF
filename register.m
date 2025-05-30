%% Image registration
% This pipleline works using bfmatlab, which needs to be downloaded and 
% added to the MATLAB path

%% Make a fresh start
%clear all; close all; clc;

%% User input or changable variables
dataDir = pwd;
%well = 'C1';
xPixels = 8100; % images will be cropped to this # of pixels
yPixels = 8100; % images will be cropped to this # of pixels
outDir = strcat(dataDir,"/",well,'registration/');
disp(outDir)
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

%% Load markers file
opts = detectImportOptions(fullfile(dataDir, 'markers.csv'), ...
    "ReadVariableNames", true, "VariableNamingRule", "preserve");
opts = setvartype(opts, "string");
markers = readtable(fullfile(dataDir, 'markers.csv'), opts);
%markers = readtable(strcat(dataDir,'/markers.csv'), "ReadVariableNames",true, "VariableNamingRule","preserve");

%% Load the image data, process the registration, and save each channel to the "registration" folder
%% Load the image data
files = dir(strcat(dataDir,"/",well,'raw/*.czi'));
validFiles = files(~startsWith({files.name}, '._')); % filter hidden files
validFiles = validFiles(~contains({files.name}, 'cycle-01')); % exclude cycle1
outTable = strings(length(validFiles), 2); % this will contain the peakCorr values from imregcorr, an indication of the registration success
scaleFactor = 0.5; % Reduce the image size by 50% before imregcorr
for i = 1:length(validFiles)
    fileName = strcat(dataDir,"/",well,"raw/",validFiles(i).name);
    fileName = char(fileName);
    t = strsplit(validFiles(i).name, '-'); t = t{1,2};t = strsplit(t, '.'); t = t{1,1};
    [idx] = find(markers.cycle_number==t); nArray = markers.marker_name(idx);
    outTable(i) = validFiles(i).name;
    image = bfopen(fileName);
    for j = 1:length(image{1})
        channelImage = image{1}{j};
        if size(channelImage) > 10000 %this is just for when binning was errantly off
            channelImage = imresize(channelImage, scaleFactor);
        end
        croppedImage = channelImage(1:xPixels,1:yPixels);
        %medianValue = median(croppedImage(:)); % Median of all pixels
        %iqrValue = iqr(croppedImage(:)); % IQR of all pixels
        %scaledImage = (croppedImage - medianValue) / iqrValue; % Apply robust scaling (subtract median and divide by IQR)
        scaledImage = croppedImage; % above can be modified if scaling is desired, with this commented out or not (uncommented will be no scaling)
        marker = nArray{j,1};
        outFileName = strcat(outDir, marker, ".tiff");
        if i == 1 && j == 1 %the reference DNA stain
            fixed = scaledImage;
            fixed_resized = imresize(fixed, scaleFactor); % resized to help imregcorr
            Rfixed = imref2d(size(fixed));
            imwrite(scaledImage,outFileName);
            outTable(i,2) = 1.00;
            continue
        end
        if i == 1 %the reference other channels
            imwrite(scaledImage,outFileName);
        else 
            if j == 1 %the non-reference DNA stain
                moving = scaledImage;
                moving_resized = imresize(moving, scaleFactor); % resized to help imregcorr
                [tformEstimate,peakCorrEstimate] = imregcorr(moving_resized, fixed_resized);

                % Scale the transformation matrix back to the original size
                T = tformEstimate.T;
                T(3,1:2) = T(3,1:2) / scaleFactor;  % Adjust translation components
                tformScaled = affine2d(T);
                movingReg = imwarp(moving, tformScaled,"OutputView",Rfixed);

                imwrite(movingReg,outFileName);
                outTable(i,2) = peakCorrEstimate;
            else %the non-reference other channels
                croppedImageReg = imwarp(scaledImage, tformScaled,"OutputView",Rfixed);
                imwrite(croppedImageReg,outFileName);
            end
        end
    end
end

%% Save the output table
tableName = strcat(dataDir,"/",well,'registration/registrationStats.csv');
writematrix(outTable, tableName);
