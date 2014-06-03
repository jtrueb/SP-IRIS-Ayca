function [handles] = CAMERA_checkPreview(handles)
%Determines if preview is opened and closes it

if getParams(handles,'CameraPreviewStatus')
    camera = getParams(handles,'Camera');
    if strcmpi(camera,'Retiga2000R') || strcmpi(camera,'Retiga4000R')
        closepreview;
    elseif strcmpi(camera,'Grasshopper2')
        CAMERA = getParams(handles,'CameraPointers');
        CAMERA_closePreview(CAMERA);
    end
    pause(0.5);
    [handles] = setParams(handles,'CameraPreviewStatus',0);
    [handles] = LEDS_setState(handles,'off');
end