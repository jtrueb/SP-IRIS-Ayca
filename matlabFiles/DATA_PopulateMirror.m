function [handles] = DATA_PopulateMirror(handles)
% Finds and loads mirrors only if mirrors are enabled

if getParams(handles,'MirrorEnable')
    [handles] = DATA_findMirrors(handles);
    [mirrorlist] = getParams(handles,'MirrorList');
    
    if size(mirrorlist.name,1) > 0
        [currentLocation] = getParams(handles,'CurrentFileGroup');
        
        mirrornumber = getParams(handles,'MirrorFile');
        if ~strcmpi(currentLocation,'DataSetNone')
            [fileNameList] = getParams(handles,'FileNameList');
            datatimes = fileNameList.(currentLocation).index;
            %mirrornumber = max(find(mirrorlist.times<datatimes(1),1,'first')); %assume mirror file was taken before data file
        else
            %mirrornumber = 1;
        end
        
        if (isempty(mirrornumber))
            mirrornumber = 1;
        elseif mirrornumber < 1
            mirrornumber = 1;
        end
        [handles] = setParams(handles,'CurrentMirrorFile', mirrornumber);
        
        fndir = getParams(handles,'MirrorDirectory');
        load([fndir mirrorlist.name{mirrornumber}]);
        clear currentLocation fileNameList mirrorList datalist mirrornumber;
        varsinfile = whos;
        mirrorVars = {};
        
        ignorelist = {'fndir','getoptions','handles'};
        for i = 1:size(varsinfile,1)
            okfile = 1;
            for j = 1:size(ignorelist,2)
                if (strcmp(ignorelist{j},varsinfile(i).name))
                    okfile = 0;
                end
            end
            if (okfile == 1)
                mirrorVars{end+1} = varsinfile(i).name;
            end
        end
        
        for i = 1:size(mirrorVars,2)
            mirrorscan.(mirrorVars{i}) = eval(mirrorVars{i});
        end
        
        setParams(handles,'MirrorVar',mirrorscan);
    else
        setParams(handles,'MirrorEnable',0);
        msg = 'No valid mirror files found';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.parameter,handles.txtLog,1);
    end
end