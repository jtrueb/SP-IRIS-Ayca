function [handles,msg2] = HARDWARE_init(handles)
msg2 = [];
camera = getParams(handles,'Camera');


useStages = getParams(handles,'EnableStages');
temp_mode=getParams(handles,'mode');

%% Initialize LEDs
if getParams(handles,'Mode')
    try
        [handles] = LEDS_setState(handles,'off');
        [handles] = LEDS_setState(handles,'on'); %dsf, where else is it getting turned on?
                                                 % seems like in preview...
    catch
        [handles] = setParams(handles,'Mode','offline');
        msg2 = 'Error connecting to LEDs.';
    end
end

%% Initialize Camera
if strcmpi(camera,'Grasshopper2')
    try
        [handles isConnected] = CAMERA_INIT(handles,'Connect');
        if strcmpi(isConnected,'done')
            [handles] = setParams(handles,'Mode','online');
        else
            [handles] = setParams(handles,'Mode','offline');
            msg2 = 'Error connecting to Camera.';
        end
    catch
        [handles] = setParams(handles,'Mode','offline');
        msg2 = 'Error connecting to Camera.';
    end
elseif strcmpi(camera,'Retiga2000R')
    %ANYTHING NEEDED?
end

%% Initialize Stages
if useStages
    whatStages = getParams(handles,'StageType'); % <- Moved into useStages check to enable runtime in offline mode, dsf 2014-03-03
    if strcmpi(whatStages,'V1') %Stages in the NSF AIR prototype
        [handles.Stage] = STAGE_INIT();
        
    elseif strcmpi(whatStages,'V2') %Stages on the SP-IRIS2 & SP-IRIS3
        [handles.Stage] = STAGE_INIT_v2(handles.const.instrument_port_cfg.pollux);
        if getParams(handles,'Mode')
            try
    %             [handles] = STAGE_calibrate(handles);
                [handles.Stage] = STAGE_getVoltageForStages(handles.Stage);
            catch
                [handles] = setParams(handles,'Mode','offline');
                msg2 = 'Error connecting to Stages.';
            end
        end
    elseif strcmpi(whatStages,'V3') %Stages on the SP-A1000, dsf 2014-03-11
        [handles.Stage] = STAGE_INIT_v3(handles.const.instrument_port_cfg.mmc100);
        
    elseif strcmpi(whatStages,'V5') %Stages on the hybrid
        [handles.Stage] = STAGE_INIT_v5_hybrid(handles.const.instrument_port_cfg.mmc100,handles.const.instrument_port_cfg.pollux);
        if handles.Stage.enabled==1
            handles=setParams(handles,'EnableStages',1);
        else
            handles=setParams(handles,'EnableStages',0);
        end
        
    elseif strcmpi(whatStages,'V6') %Stages on the ayca highmag
        [handles.Stage] = STAGE_INIT_v6(handles.const.instrument_port_cfg.mmc100,handles.const.instrument_port_cfg.mmc100Z);
        if handles.Stage.enabled==1
            handles=setParams(handles,'EnableStages',1);
        else
            handles=setParams(handles,'EnableStages',0);
        end
    end
    
end