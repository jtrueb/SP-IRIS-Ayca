function [handles] = IMAGE_Minimap_drawbox(handles)

[pos] = getParams(handles,'Stage_XYPos');
[Minimap_pos] = IMAGE_Minimap_convertStagePos(handles,pos);

if ~isnan(Minimap_pos) & ~isempty(Minimap_pos)
    set(gcf,'CurrentAxes',handles.axesMinimap);
    
    [sampleSize] = getParams(handles,'MinimapSamplingSize');
    [minimap] = getParams(handles,'Minimap');

    width = sampleSize(2)-1;
    height = sampleSize(1)-1;
    xStart = size(minimap,2)-(Minimap_pos(2) + width-1);
    
%     yStart = size(minimap,1)-(Minimap_pos(1) + height-1);  %legacy
%     minimap y position
    yStart = 0+(Minimap_pos(1) + height-1); %updated for reversal of y axis

    h = rectangle('Position',[xStart,yStart,sampleSize(2),sampleSize(1)],'EdgeColor',[1 0 0]); %[x y w h]
end