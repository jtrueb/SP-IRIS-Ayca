function [handles] = CONTROL_displayRadios(handles)
% Determines what radio buttons are available
offStr = 'off';
onStr = 'on';

enIntensity = offStr;
enContrast = offStr;
enProcess = offStr;

%Verify we have data
dataVar = getParams(handles,'DataVar');
if isfield(dataVar,'data')
    if isfield(dataVar,'process')
%         enProcess = onStr;
        [handles] = setParams(handles,'MainPlotType','Process');
    elseif isfield(dataVar,'contrast')
%         enContrast = onStr;
        [handles] = setParams(handles,'MainPlotType','Contrast');
    else
%         enIntensity = onStr;
        [handles] = setParams(handles,'MainPlotType','Intensity');
    end
end

% [handles] = setParams(handles,'IntensityVisible',enIntensity);
% [handles] = setParams(handles,'ContrastVisible',enContrast);
% [handles] = setParams(handles,'ProcessVisible',enProcess);