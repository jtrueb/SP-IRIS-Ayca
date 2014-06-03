function [handles] = DATA_loadData(handles)
% DATA_loadData, find data for this file and loads it
%
% check whether to load fitted data or not...
% [getoptions] = GUI_getOptions(handles);
fileName = getParams(handles,'CurrentFilePath');

if ~strcmpi(fileName,'None')
    %% LOAD FILE AND PROCESS
    load(fileName);
    varsinfile = whos;
    dataVarName = {};
    ignorelist = {'fileName','getoptions','handles'};
    for i = 1:size(varsinfile,1)
        okfile = 1;
        for j = 1:size(ignorelist,2)
            if (strcmp(ignorelist{j},varsinfile(i).name))
                okfile = 0;
            end
        end
        if (okfile == 1)
            dataVarName{end+1} = varsinfile(i).name;
        end
    end
    
    for i = 1:size(dataVarName,2)
        dataVar.(dataVarName{i}) = eval(dataVarName{i});
    end
    
    %Store data
    [handles] = setParams(handles,'DataVar',dataVar);
    
    %Update ChipInfo Tab
    [handles] = DATA_loadParams(handles);
    
    %% MIRROR SCAN
    mirrorVar = getParams(handles,'MirrorVar');
    if (isfield(mirrorVar,'data_mir') && getParams(handles,'MirrorEnable')...
            && ~strcmpi(getParams(handles,'CurrentMirrorFile'),'None'))
        try
            dataVar.contrast = data./mirrorVar.data_mir;
        catch
            mirror_enabled = 0;
            msg = 'Data and Mirror file are different sizes';
            [handles] = GUI_logMsg(handles,msg,handles.const.log.parameter,handles.txtLog,1);
            [handles] = setParams(handles,'MirrorEnable',mirror_enabled);
        end
    end
    
    if (isfield(handles,'image'))
        fieldlist = fieldnames(handles.image);
        for i = 1:size(fieldlist,2)
            clear(['handles.image.' fieldlist{i}]);
        end
        clear('handles.image');
    end
    
    %%%%%%   USED???? %%%%
%     dataVar.minmax.intensity = [0 1];
%     dataVar.minmax.contrast = [0 1];
%     dataVar.minmax.process = [0 1];
%     
%     varstoclear = {'data','data_pd','data_date','data_wav'};
%     for i = 1:size(varstoclear,2)
%         if (exist(varstoclear{i},'var'))
%             clear(varstoclear{i});
%         end
%     end
%     
%     [a,b] = getMinMax(dataVar.data);
%     dataVar.minmax.intensity = [a b];
%     
%     if isfield(dataVar,'contrast')
%         [a,b] = getMinMax(dataVar.contrast);
%         dataVar.minmax.contrast = [a b];
%     end
    
    %% Load Minimap if its there
    fnmini = getParams(handles,'MinimapPath');
    
    if (exist(fnmini,'file') == 2) %2 = file, not variable or directory
        [handles] = IMAGE_Minimap_load(handles,fnmini);
    end
end


function [minVal maxVal] = getMinMax(dataIn)
minVal = min(min(dataIn));
maxVal = max(max(dataIn));
