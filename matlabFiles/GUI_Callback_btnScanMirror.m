function GUI_Callback_btnScanMirror(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curState] = getParams(handles,'BtnState');
[handles] = CONTROL_WelcomeBtns(handles, 10);

msg = 'Acquiring Mirror'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

[handles,data] = ACQUIRE_scan(handles,'mirror');
dir = get(handles.txtValueSaveFolder,'String');
[handles] = setParams(handles,'MirrorDirectory',dir);

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    msg = 'Mirror Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);