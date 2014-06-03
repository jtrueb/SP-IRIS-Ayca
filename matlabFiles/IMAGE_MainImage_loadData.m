function [handles] = IMAGE_MainImage_loadData(handles)
% IMAGE_loadImage, main function to display image data on handles.mainAxes

% Clear the MainImage
[handles] = IMAGE_MainImage_reset(handles);

% Use Mirror if necessary (MirrorVar)
[handles] = DATA_PopulateMirror(handles);

% Load image into memory (DataVar)
[handles] = DATA_loadData(handles);

% Display valid plot styles
% [handles] = CONTROL_displayRadios(handles);

% Display the file
[handles] = IMAGE_MainImage_loadImage(handles);