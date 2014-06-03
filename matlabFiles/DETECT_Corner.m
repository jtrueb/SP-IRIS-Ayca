function [handles, offset] = DETECT_Corner(handles)
%DETECT_Corner determines the XY displacement of the chip w.r.t. the UR
%oxide corner
%   Images are acquired in a 3x3 grid around the assumed corner location.
%   After thresholding, the X then Y directions are summed. The step in the
%   summed image indicated the edge of the oxide region.

%%Load necessary variables
stages = getParams(handles,'StagePointers');
axes = {stages.axis.x,stages.axis.y};
effPixel = getParams(handles,'EffPixel');
curOffset = getParams(handles,'ChipOffset');
image_stitching_correction = [8 4];%[X Y]Offset in 3x3images for the NSF AIR Prototype

%Lower exposure time
[curExp] = getParams(handles,'Exposure');
[prevExp] = getParams(handles,'PreviewExposure');
[handles] = setParams(handles,'Exposure',prevExp);

%Move to assumed corner location
[initial_pos] = getParams(handles,'StageHomePos');
[handles] = STAGE_MoveAbsolute(handles,axes,[initial_pos(1) initial_pos(2)] );

%Acquire a 3x3 grid of images
[handles,data_out] = ACQUIRE_scan3x3(handles);
%[handles,data_out] = ACQUIRE_scan(handles,'focus');

if FLAG_StopBtn('check')
    [handles] = setParams(handles,'Exposure',curExp);
    [smart_flag] = getParams(handles,'SmartMove');
    if smart_flag
        [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
    else
        [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
    end
    offset = 0;
    return;
end
%% Threshold Image
data_norm = data_out./2^16;
thresh = 0.5;
% thresh = graythresh(data_norm);
data_bin = im2bw(data_norm,thresh);

%% Find step in X
xVal = mean(data_bin,1);
xStep = find(xVal>=0.9, 1,'first');
if isempty(xStep)
    xStep = 0;
end
% xOffset = xStep.*effPixel;

%% Find step in Y
yVal = mean(data_bin,2);
yStep = find(yVal>=0.95, 1,'last');
if isempty(yStep)
    yStep = 0;
end
% yOffset = yStep.*effPixel;

%% Determine offset
initial_pix = fix(size(data_bin)/2);
% offset_pix = [initial_pix(2) initial_pix(1)] - [xStep yStep] + image_stitching_correction;
offset_pix = [initial_pix(2) initial_pix(1)] + image_stitching_correction;
offset = curOffset + offset_pix.*effPixel;

[handles] = setParams(handles,'Exposure',curExp);
[handles] = setParams(handles,'ChipOffset',offset);