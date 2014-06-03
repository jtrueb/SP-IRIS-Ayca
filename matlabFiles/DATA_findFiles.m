function [fileNameList] = DATA_findFiles(handles,fileNameList,fileList)
% [fileNameList] = DATA_findFiles(handles,fileNameList,fileList,previouspath)
% Extracts relative the rootnames from the current directory to populate fileNameList

fileList = dir ([getParams(handles,'Directory') '/'  '*' handles.const.DataSetString '*' ...
    handles.const.MatFileExtension]);

for i = 1:length(fileList)
    [fileNameList] = DATA_scanFilenameAndProcess(handles,fileNameList,fileList(i).name);
end
end