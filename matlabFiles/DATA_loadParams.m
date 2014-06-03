function [handles] = DATA_loadParams(handles)
dataVar = getParams(handles,'dataVar');

if isfield(dataVar,'comment')
    comment = dataVar.comment;
else
    comment = '';
end
if isfield(dataVar,'instrument')
    instrument = dataVar.instrument;
else
    instrument = 1;
end
if isfield(dataVar,'scan_type')
    scan_type = dataVar.scan_type;
else
    scan_type = 1;
end
if isfield(dataVar,'particle_type')
    particle_type = dataVar.particle_type;
else
    particle_type = 1;
end
if isfield(dataVar,'array_pitch')
    array_pitch = dataVar.array_pitch;
else
    array_pitch = getParams(handles,'Stage_XYIndex');
end
if isfield(dataVar,'array_size')
    array = dataVar.array_size;
else
    array = getParams(handles,'ArraySize');
end

[handles] = setParams(handles,'Comment',comment);
[handles] = setParams(handles,'Instrument_fit',instrument);
[handles] = setParams(handles,'ScanType',scan_type);
[handles] = setParams(handles,'ParticleType',particle_type);
[handles] = setParams(handles,'Stage_XYIndex',array_pitch);
[handles] = setParams(handles,'ArraySize',array);