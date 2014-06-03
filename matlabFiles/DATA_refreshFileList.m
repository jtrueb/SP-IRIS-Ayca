function [handles] = DATA_refreshFileList(handles)
% DATA_refreshFileList(handles) uses the GUI's handles struct to locate and then populate the handles struct with IRIS files
%Data is returned to the handles.fileNameList struct, which now contains
%addtional structs with similiar but varying information about the
%filename, plus a list of the time data
totalFileCount = 0;
totalDataSets = 0;

%Get all .mat files in the directory
fileNameList = struct();
fileList = dir([getParams(handles,'Directory') '/' '*.mat']); %dummy string

% Extracts the rootnames from the current directory to populate fileNameList
[fileNameList] = DATA_findFiles(handles,fileNameList,fileList);

%% PROCESS AND SORT FILES
listOfNames = fieldnames(fileNameList);
totalDataSets = length(listOfNames);
stringNames = cell(1,totalDataSets+1);
stringNames{1} = 'None';

for i = 1:length(listOfNames)
    [sortlist,sortlist_ind] = sort(fileNameList.(listOfNames{i}).index);
    
    fileNameList.(listOfNames{i}).index = fileNameList.(listOfNames{i}).index(sortlist_ind);
    fileNameList.(listOfNames{i}).directory = fileNameList.(listOfNames{i}).directory(sortlist_ind);
    
    fileNameList.(listOfNames{i}).identifier = fileNameList.(listOfNames{i}).identifier(sortlist_ind);
    fileNameList.(listOfNames{i}).filetime = fileNameList.(listOfNames{i}).filetime(sortlist_ind);

    fileNameList.(listOfNames{i}).full_path_data = fileNameList.(listOfNames{i}).full_path_data(sortlist_ind);
    fileNameList.(listOfNames{i}).filename = fileNameList.(listOfNames{i}).filename(sortlist_ind);
    fileNameList.(listOfNames{i}).minimap = fileNameList.(listOfNames{i}).minimap(sortlist_ind);
    fileNameList.(listOfNames{i}).full_path_minimap = fileNameList.(listOfNames{i}).full_path_minimap(sortlist_ind);
    
    stringNames{i+1} = fileNameList.(listOfNames{i}).identifier{1};
    totalFileCount = totalFileCount + length(sortlist);
end

[handles] = setParams(handles,'FileNameList',fileNameList);

if (size(listOfNames,1) > 0)
    [handles] = setParams(handles,'FileGroups',stringNames);
else
    [handles] = setParams(handles,'FileGroups',{'None'});
end

[handles] = GUI_logMsg(handles,sprintf('Datasets: %d, Total Files: %d, Dir.: %s', ...
    totalDataSets,totalFileCount, handles.const.directories.data)...
    ,handles.const.log.dataset, handles.txtLog,1);   

end