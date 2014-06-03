function [handles] = OUTPUT_excelFile_zStack(handles,xlsName,variables)

if exist([xlsName '.xls'],'file') == 2
    [num,txt,raw] = xlsread(xlsName,'Sheet1');
    row_offset = size(raw,1)+1; % header + data + empty row
else
    header = {'TimeStamp','X-Location','Y-Location','Z-Nominal','Z-Actual','Particle Count','Comment'};
    range = 'A1:F1';
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
if isfield(variables,'x_pos')
    x_pos = variables.x_pos;
else
    x_pos = 1;
end
if isfield(variables,'y_pos')
    y_pos = variables.y_pos;
else
    y_pos = 1;
end
if isfield(variables,'Z_nominal')
    Z_nominal = variables.Z_nominal;
else
    Z_nominal = [];
end
if isfield(variables,'Z_actual')
    Z_actual = variables.Z_actual;
else
    Z_actual = [];
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



%Write header if this is the first/only spot
%array_size = getParams(handles,'ArraySize'); %[X Y]

% row = xspot + array_size(1)*(yspot-1)+1;
row = row_offset;
spot = [int2str(x_pos) ',' int2str(y_pos)];
range = ['A' int2str(row) ':F' int2str(row)];
xlsData = {dateString,num2str(x_pos),...
    num2str(y_pos),num2str(Z_nominal),num2str(Z_actual),...
    num2str(particle_count),comment};
            
xlswrite(xlsName, xlsData, range);
msg = [xlsName '.xls'];
[handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog,1);