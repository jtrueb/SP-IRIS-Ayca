function [handles] = OUTPUT_excelFile(handles,xlsName,variables)

if exist([xlsName '.xls'],'file') == 2
    [num,txt,raw] = xlsread(xlsName,'Sheet1');
    row_offset = size(txt,1)+1; % header + data + empty row
else
    header = {'TimeStamp','Spot (X/Y)','Pre/Post Scan','XY Location','Particle Type','Image area (mm^2)','Particle Count','Density (particle/mm^2)','Elapsed Time','Main Size Window','RP Size Window','Z_actual','Z_desired','Comment'};
    range = 'A1:N1';
    xlswrite(xlsName, header, range);
    row_offset = 2; % header + data + empty row
end


%Store struct fields into seperate variables or create empty variables if
%the field doesn't exist
if isfield(variables,'dateString')
    dateString = num2str(variables.dateString);
else
    data_date = datestr(now);
    dateString = num2str([data_date(13:14) data_date(16:17) data_date(19:20)]);
end
if isfield(variables,'xspot')
    xspot = variables.xspot;
else
    xspot = 1;
end
if isfield(variables,'yspot')
    yspot = variables.yspot;
else
    yspot = 1;
end
if isfield(variables,'scan_position')
    scan_position = variables.scan_position;
else
    scan_position = [];
end
if isfield(variables,'scan_type')
    scan_type = variables.scan_type;
else
    scan_type = [];
end
if isfield(variables,'particle_type')
    particle_type = variables.particle_type;
else
    particle_type = [];
end
if isfield(variables,'particle_count')
    particle_count = variables.particle_count;
else
    particle_count = [];
end
if isfield(variables,'comment')
    temp = variables.comment;
    if size(temp,1) > 1
        comment = '';
        for i = 1:size(temp,1)
            comment = horzcat(comment,temp(i,:),' ');
        end
    else
        comment = temp;
    end
else
    comment = [];
end
if isfield(variables,'elapsedTime')
    elapsedTime = variables.elapsedTime;
else
    elapsedTime = -1;
end
if isfield(variables,'image_area')
    image_area = variables.image_area;
else
    image_area = -1;
end
if isfield(variables,'density')
    density = variables.density;
else
    density = -1;
end
if isfield(variables,'particle_size')
    Particle_sizeWindow = variables.particle_size;
else
    Particle_sizeWindow = -1;
end
if isfield(variables,'RP_size')
    RP_sizeWindow = variables.RP_size;
else
    RP_sizeWindow = -1;
end
if isfield(variables,'Z_actual')
    Z_actual=variables.Z_actual;
else
    Z_actual=-1
end
if isfield(variables,'Z_desired')
    Z_desired=variables.Z_desired;
else
    Z_desired=-1
end


%Write header if this is the first/only spot
%array_size = getParams(handles,'ArraySize'); %[X Y]

% row = xspot + array_size(1)*(yspot-1)+1;
row = row_offset;
spot = [int2str(xspot) ',' int2str(yspot)];
range = ['A' int2str(row) ':L' int2str(row)];
xlsData = {dateString,spot,scan_type,num2str(scan_position),particle_type,...
    int2str(image_area),int2str(particle_count),int2str(density),...
    elapsedTime,Particle_sizeWindow,RP_sizeWindow,Z_actual,Z_desired,comment};
            
xlswrite(xlsName, xlsData, range);
msg = [xlsName '.xls'];
[handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog,1);