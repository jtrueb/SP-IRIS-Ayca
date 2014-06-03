function [handles] = IMAGE_MainImage_loadImage(handles)
% IMAGE_loadImage, main function to display image data on handles.mainAxes

set(gcf,'CurrentAxes',handles.axesMain); %point to main Axes

if ~strcmpi(getParams(handles,'CurrentFileGroup'),'DatasetNone')
    
    [dataim] = IMAGE_MainImage_getData(handles); % Get dataim from selected dataset    
    [handles] = IMAGE_MainImage_display(handles,dataim,'image');
            
    msg = ['Loaded Data: ' getParams(handles,'CurrentFilePath')];
    [handles] = GUI_logMsg(handles,msg,handles.const.log.dataset,handles.txtLog);    
end
