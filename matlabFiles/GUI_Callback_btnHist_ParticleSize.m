function GUI_Callback_btnHist_ParticleSize(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

% msg = 'Not implemented: GUI_Callback_btnHist_ParticleSize'; feedbackLvl = 1; errorFlag = 1;

msg = 'Acquiring Histogram'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

[handles,data] = ACQUIRE_scan(handles,'Size');

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handlestxtLog,feedbackLvl,errorFlag);
else
    msg = 'Histogram Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);