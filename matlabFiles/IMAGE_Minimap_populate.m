function [handles] = IMAGE_Minimap_populate(handles,data,Stage_pos)
%Down samples the data, updates minimap, and returns
%Data is in [Y X] format. Stage_pos is in [X Y] format
minimap = getParams(handles,'Minimap'); %[Y X]

%Down sample
sampleSize = getParams(handles,'MinimapSamplingSize');%[Y X]
temp  = imresize(data, sampleSize); %Down sample data

%Updates minimap
Minimap_pos = IMAGE_Minimap_convertStagePos(handles,Stage_pos);
width = size(temp,2)-1;
height = size(temp,1)-1;

xStart = size(minimap,2)-(Minimap_pos(2) + width-1);
xEnd = xStart+width;
yStart = size(minimap,1)-(Minimap_pos(1) + height-1);
yEnd = yStart+height;

minimap(yStart:yEnd,xStart:xEnd) = temp;

[handles] = setParams(handles,'Minimap',minimap);