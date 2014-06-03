function [dataim] = IMAGE_MainImage_getData(handles)
% from handles. get data from current selected image

dataVar = getParams(handles,'DataVar');
dataim = dataVar.(getParams(handles,'MainPlotType'));

% if (strcmp(handles.gui.plotmain,'intensity'))
%     handles.image.image_mode = 'data';
%     dataim = handles.image.data_average_intensity;
% end
% if (strcmp(handles.gui.plotmain,'contrast'))
%     handles.image.image_mode = 'data_contrast';
%     dataim = handles.image.data_contrast;
% end
% if (strcmp(handles.gui.plotmain,'process'))
%     handles.image.image_mode = 'process';
%     dataim = handles.image.data_process;
% end
% if (getoptions.removeSRmirror)
%     if (~isempty(handles.image.mirror))
%         if (size(dataim) == size(handles.image.mirror))
%             dataim(handles.image.mirror) = -1;
%         end
%     end
% end