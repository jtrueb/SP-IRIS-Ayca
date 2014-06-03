function [handles] = IMAGE_Minimap_display(handles)
figure(handles.figureMain);
set(handles.panels.figure,'CurrentAxes',handles.axesMinimap);
cla(handles.axesMinimap,'reset');

[frame m b] = IMAGE_show(handles.Minimap.data, getParams(handles,'MinimapContrast'));
[handles] = IMAGE_Minimap_drawbox(handles);
end