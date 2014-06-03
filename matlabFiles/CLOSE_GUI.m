function CLOSE_GUI(hObject, eventdata)
% Hint: delete(hObject) closes the figure
handles = guidata(hObject);

isOnline = getParams(handles,'Mode');

if isOnline
    %Turn off LEDs
    try
        [handles] = LEDS_setState(handles,'off');
    catch
    end
    %Disconnect from camera
    try
        [handles] = CAMERA_checkPreview(handles); %Check if preview is on
        [CAMERA] = CAMERA_disconnect(handles);
        msg = 'Camera disconnected';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,1);
    catch
    end
end

%Turn off diary
diary('off');

delete(hObject);