function [handles] = OUTPUT_matFile(handles,matName,variables)

%Store struct fields into seperate variables or create empty variables if
%the field doesn't exist
if isfield(variables,'data')
    data = variables.data;
else
    data = [];
end
if isfield(variables,'data_wav')
    data_wav = variables.data_wav;
else
    data_wav = [];
end
if isfield(variables,'data_date')
    data_date = variables.data_date;
else
    data_date = [];
end
if isfield(variables,'data_ref')
    data_ref = variables.data_ref;
else
    data_ref = [];
end
if isfield(variables,'data_raw')
    data_raw = variables.data_raw;
else
    data_raw = [];
end
if isfield(variables,'scan_position')
    scan_position = variables.scan_position;
else
    scan_position = [];
end
if isfield(variables,'instrument')
    instrument = variables.instrument;
else
    instrument = [];
end
if isfield(variables,'software_version')
    software_version = variables.software_version;
else
    software_version = [];
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
if isfield(variables,'ref_particle')
    ref_particle = variables.ref_particle;
else
    ref_particle = [];
end
if isfield(variables,'comment')
    comment = variables.comment;
else
    comment = [];
end
if isfield(variables,'array_pitch')
    array_pitch = variables.array_pitch;
else
    array_pitch = [];
end
if isfield(variables,'array_size')
    array_size = variables.array_size;
else
    array_size = [];
end
if isfield(variables,'Z_plane')
    Z_plane = variables.Z_plane;
else
    Z_plane = [];
end
if isfield(variables,'Z_desired')
    Z_desired = variables.Z_desired;
else
    Z_desired = [];
end
if isfield(variables,'Z_actual')
    Z_actual = str2double(variables.Z_actual)*1000;
else
    Z_actual = [];
end
if isfield(variables,'offset')
    offset = variables.offset;
else
    offset = [];
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

save(matName,'data','data_wav','data_date','data_ref',...
    'data_raw','scan_position','instrument','software_version',...
    'scan_type','particle_type','particle_count','comment',...
    'array_pitch','array_size','Z_plane','Z_desired','Z_actual',...
    'offset','elapsedTime','image_area','density','ref_particle',...
    'RP_sizeWindow','Particle_sizeWindow');
msg = matName;
[handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog,1);