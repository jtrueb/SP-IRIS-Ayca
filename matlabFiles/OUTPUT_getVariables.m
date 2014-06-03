function output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset)

%Craft Timestamp
data_date = datestr(now);
dateString = [data_date(13:14) data_date(16:17) data_date(19:20)];
output.data_date = data_date;

%Array info
if exist('data','var')
    output.data = data;
    
else
    output.data = [];
    output.data_raw = [];
end
if exist('offset','var')
    output.offset = offset;
else
    output.offset = [];
end

output.data_wav = getParams(handles,'LEDColor');
output.scan_position = getParams(handles,'Stage_XYPos'); %[X Y];
output.instrument = getParams(handles,'Instrument');
output.software_version = getParams(handles,'SoftwareVersion');
output.scan_type = getParams(handles,'ScanType');
output.particle_type = getParams(handles,'ParticleType');
output.comment = getParams(handles,'Comment');
output.array_pitch = getParams(handles,'Stage_XYIndex'); %[X Y]
output.array_size = getParams(handles,'ArraySize'); %[X Y]
output.Z_desired = getParams(handles,'ZPos');


%% DSF 2014-03-26, WTF? Really? Need to use global stage function here
%% Will be slightly slower but will work with all stages
[x y z] = STAGE_getPositions(handles.Stage);
output.Z_actual = z;

%Performs redundant conversion to eliminate trailing spaces
%z_string=STAGE_CONTROL_RESPONSE(handles.Stage,[handles.Stage.axis.z ' ' handles.Stage.commands.current_position]);
% output.Z_actual = num2str(str2num(z));


output.particle_size = [num2str(getParams(handles,'MinHist')) ' - '...
    num2str(getParams(handles,'MaxHist'))];
output.RP_size = [num2str(getParams(handles,'RefMinHist')) ' - '...
    num2str(getParams(handles,'RefMaxHist'))];

output.pixel_size = getParams(handles,'PixelSize');
output.magnification = getParams(handles,'Magnification');
image_area = size(data).*(output.pixel_size.*10^-3./output.magnification); %[mm x mm]
output.image_area = image_area(1).*image_area(2); %[mm^2]
output.matName=[root_name handles.const.DataSetString dateString handles.const.MatFileExtension];


if exist('particle_count','var')
    output.particle_count = particle_count;
    output.density = output.particle_count/output.image_area; %[particle/mm^2]
else
    output.particle_count = [];
    output.density = []; %[particle/mm^2]
end


%% Specific to excelFile
output.dateString = dateString;
output.xlsName=[root_name handles.const.DataSetString];

end
