function [handles] = DATA_findMirrors(handles)

[fndir] = getParams(handles,'MirrorDirectory');

listofmirrors = dir([fndir '/*' handles.const.MirrorString '*' handles.const.MatFileExtension]);

if isempty(listofmirrors)
    [handles] = setParams(handles,'MirrorDirectory',handles.const.directories.matlab);
    return;
end

mirrorlist.name = {};
mirrorlist.times = [];

for i = 1:size(listofmirrors,1)    
    expr = ['(?<scanname>\w*)' handles.const.MirrorString ...
        '(?<scantime>\d*)\' handles.const.MatFileExtension];
    [names] = regexpi(listofmirrors(i).name, expr, 'names');
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
        mirrorlist.name{end+1} = listofmirrors(i).name;
        mirrorlist.times(end+1) = str2num(names.scantime);
    else
        mirrorlist.name{end+1} = listofmirrors(i).name;
        mirrorlist.times(end+1) = str2num(names.scantime);
    end
end

[handles] = setParams(handles,'MirrorList',mirrorlist);