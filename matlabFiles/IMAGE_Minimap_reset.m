function [handles] = IMAGE_Minimap_reset(handles)


figureHandle = handles.figureMain;
axesHandle = handles.axesMinimap;
IMAGE_clearAxis(figureHandle,axesHandle);

[handles] = IMAGE_Minimap_init(handles);
end