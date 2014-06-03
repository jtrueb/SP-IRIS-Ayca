function [handles] = IMAGE_MainImage_reset(handles)

figureHandle = handles.figureMain;
axesHandle = handles.axesMain;
IMAGE_clearAxis(figureHandle,axesHandle);

width = getParams(handles,'Width');
height = getParams(handles,'height');
data = zeros(height,width);
option = 'image';

[handles] = IMAGE_MainImage_display(handles,data,option);
end