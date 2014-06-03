function GUI_Callback_btnScanMinimap(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curState] = getParams(handles,'BtnState');
[handles] = CONTROL_WelcomeBtns(handles, 10);

msg = 'Acquiring Minimap'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);
    
[handles] = ACQUIRE_array(handles, 'minimap');

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');    
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);