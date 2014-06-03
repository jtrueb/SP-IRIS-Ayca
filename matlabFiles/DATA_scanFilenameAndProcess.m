function [fileNameList] = DATA_scanFilenameAndProcess(handles,fileNameList,fileName)
% [fileNameList] = scanFilenameAndProcess(handles,fileNameList,fileName,previouspath)
% will use the handles struct for options. Then by scanning the file's name
% (fileName), it will either ignore if there's no match or add to
% fileNameList. Ignores hidden files ('.'

if (fileName(1) ~= '.')  %ignore hidden files
    directory = getParams(handles,'Directory');
    
    expr = ['(?<scanname>\w*)' handles.const.DataSetString ...
        '(?<scantime>\d*)\' handles.const.MatFileExtension];
    [names] = regexpi(fileName, expr, 'names');
    cont = 1;
    if (isempty(names))
        % wrong filename
        cont = 0;
    else
        if (isempty(names.scanname) || isempty(names.scantime))
            cont = 0;
        end
    end
    if (cont > 0)
        tmp_fieldname = [handles.const.DataSetString names.scanname];
        if ~isfield(fileNameList,tmp_fieldname)
            fileNameList.(tmp_fieldname) = struct();
            fileNameList.(tmp_fieldname).index = [];
            fileNameList.(tmp_fieldname).directory = {};
            
            fileNameList.(tmp_fieldname).identifier = {};
            fileNameList.(tmp_fieldname).filetime = {};

            fileNameList.(tmp_fieldname).full_path_data = {};
            fileNameList.(tmp_fieldname).full_path_minimap = {};
            fileNameList.(tmp_fieldname).filename = {};
            fileNameList.(tmp_fieldname).minimap = {};
        end
        ind_x = size(fileNameList.(tmp_fieldname).index,2) + 1;
        
        %% POPULATE INFORMATION ABOUT ALL EACH FILE, PATH, FIELD, FITTED
        fileNameList.(tmp_fieldname).index(ind_x) = ...
            [str2double(names.scantime)];
        fileNameList.(tmp_fieldname).directory{ind_x} = ...
            [directory];
        
        fileNameList.(tmp_fieldname).identifier{ind_x} = [names.scanname];
        fileNameList.(tmp_fieldname).filetime{ind_x} = str2double(names.scantime);
        
        fileNameList.(tmp_fieldname).full_path_data{ind_x} = [directory fileName];
        fileNameList.(tmp_fieldname).filename{ind_x} = [fileName];
        fileNameList.(tmp_fieldname).minimap{ind_x} = ...
            [names.scanname handles.const.MinimapString handles.const.MatFileExtension];
        fileNameList.(tmp_fieldname).full_path_minimap{ind_x} = ...
            [directory names.scanname handles.const.MinimapString handles.const.MatFileExtension];
    end
end