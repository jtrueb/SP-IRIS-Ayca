function [handles] = IMAGE_Plot_display(handles,data,option)
% IMAGE_loadImage, main function to display image data on handles.mainAxes

set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
cla(handles.axesPlot);
if ischar(option)
    if strcmpi(option,'hist')
        IMAGE_show(data, option);
    elseif strcmpi(option,'image')
        IMAGE_show(data, getParams(handles,'MainImageContrast'));
    elseif strcmpi(option,'plot')
    end
else
    disp('Improper option to IMAGE_Plot_display');
end