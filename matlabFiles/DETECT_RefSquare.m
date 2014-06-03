function [center] = DETECT_RefSquare(image,th,sq)
%DETECT_RefSquare determines the center location of the reference square
%   A 2D image is the input. A threshold is applied to the image assuming
%   the reference square is saturated. Erosion is used to eliminate any
%   noise areas. To prevent issues with multiple reference squares, the
%   remaining features are labeled and the last labeled object is selected
%   for edge detection.

%% Threshold Image
ref_norm = image./2^16;
ref_bin = im2bw(ref_norm,th);
SE = strel('square',sq);
ref_erode = imerode(ref_bin,SE);
%figure; imshow(ref_bin);
%figure; imshow(ref_erode);
clear ref_norm ref_bin;

%% Label the squares with bwconncomp & labelmatrix
%Isolates 1 square for average analysis
%Time to execute: 0.02s
cc = bwconncomp(ref_erode);
labeled = double(labelmatrix(cc));
labeled_norm = labeled./max(max(labeled));
filtered = im2bw(labeled_norm,0.98);
clear ref_erode;
%figure; imshow(filtered);

[cent] = regionprops(filtered,'Centroid'); %Outputs as X/Y

if isempty(cent)
    [center] = DETECT_RefSquare(image,th,sq-10)
else
    center = [cent(1).Centroid(2) cent(1).Centroid(1)]; %Rearrange to Y/X for images
end

% %% Find step in X
% xVal = mean(filtered,1);
% %figure; stem(xVal);
% xStep1 = find(xVal>=0.001, 1,'First');
% xStep2 = find(xVal>=0.001, 1,'Last');
% if isempty(xStep1)
%     xStep1 = 0;
% end
% if isempty(xStep2)
%     xStep2 = 0;
% end
% left = xStep1;
% right = xStep2;
% xmiddle = floor((right - left)/2 + left);
% 
% %% Find step in Y
% yVal = mean(filtered,2);
% %figure; stem(yVal);
% yStep1 = find(yVal>=0.001, 1,'First');
% yStep2 = find(yVal>=0.001, 1,'Last');
% if isempty(yStep1)
%     yStep1 = 0;
% end
% if isempty(yStep2)
%     yStep2 = 0;
% end
% top = yStep1;
% bottom = yStep2;
% ymiddle = floor((bottom-top)/2 + top);

% center = [ymiddle xmiddle];