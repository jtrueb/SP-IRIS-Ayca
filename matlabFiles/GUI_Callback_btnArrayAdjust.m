function GUI_Callback_btnArrayAdjust(hObject,event)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

msg = 'Manual Array Adjustment Executing'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

[handles] = ACQUIRE_array(handles,'adjust');

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handlestxtLog,feedbackLvl,errorFlag);
else
    msg = 'Adjustment Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);