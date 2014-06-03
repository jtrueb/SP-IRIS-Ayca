function [handles isConnected] = CAMERA_INIT(handles, option)
% MATLAB Client Application using .NET libraries

exename = 'PGServer2';

if strcmpi(option,'Connect')
    %Check if server process is running
    [isRunning] = CAMERA_checkServer(exename);
    
    %KILL IF ALREADY RUNNING, WORKS ON WINDOWS 7
    if (isRunning)
        CAMERA_killServer(exename);
    end
    
    %Connect to the camera
    [temp, isConnected] = CAMERA_connectPGServer(handles,exename);
    handles.Camera.sw = temp.sw;
    handles.Camera.sr = temp.sr;
    handles.Camera.client = temp.client;
    handles.Camera.s = temp.s;
    handles.Camera.dir = temp.dir;
    handles.Camera.file = temp.file;
    
elseif strcmpi(option,'isConnected')
    %Check if server is running
    [isRunning] = CAMERA_checkServer(exename);
    isConnected = 'done';
    %Restart server if it is not running
    if ~isRunning
        [handles isConnected] = CAMERA_INIT(handles,'Connect');
        [handles] = setParams(handles,'Mode','online');
        msg = 'Reconnected to camera.';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,1);
    end
end
