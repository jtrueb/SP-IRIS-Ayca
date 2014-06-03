function [handles] = IMAGE_MainImage_display(handles,data,option)
% IMAGE_loadImage, main function to display image data on handles.mainAxes

figureHandle = handles.panels.figure;
axesHandle = handles.axesMain;
IMAGE_clearAxis(figureHandle,axesHandle);

if ischar(option)
    if strcmpi(option,'hist')
        IMAGE_show(data, option);
    elseif strcmpi(option,'image')
        IMAGE_show(data, getParams(handles,'MainImageContrast'));
    end
else
    disp('Improper option to IMAGE_MainImage_display');
end