function [handles] = IMAGE_Minimap_init(handles)
MaxPixels = getParams(handles,'MaxPixels');

FOV = getParams(handles,'FOV'); %[Y X]
binning = getParams(handles,'Binning');%[X Y]

[numImages] = [21 17]; %[Y X]
[TotalArea] = numImages.*FOV; %[Y X]
[TotalPixels] = MaxPixels.*[binning(2) binning(1)]; %[Y X]
[ROI] = TotalPixels./[4 4];%Pixels in one image. Binned 4x4 [Y X]
% [sampleSize] = fix(ROI./numImages); %# pixels per image in minimap [pixel]


% [minimap] = 30000.*ones(sampleSize.*numImages);%Initialize minimap array [Y X]
[placeholder] = getParams(handles,'MinimapPlaceholder');
load(placeholder);

[conversion] = TotalArea./size(minimap);%Determine Stage to Minimap conversion [Y X]
[sampleSize]=fix(size(minimap)./numImages);



[handles] = setParams(handles,'MinimapSize',TotalArea);
[handles] = setParams(handles,'StageToMinimapConversion',conversion);
[handles] = setParams(handles,'MinimapImageNumber',numImages);
[handles] = setParams(handles,'MinimapSamplingSize',sampleSize);
[handles] = setParams(handles,'Minimap',minimap);
end