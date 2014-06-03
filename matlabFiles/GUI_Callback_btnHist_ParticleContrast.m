function GUI_Callback_btnHist_ParticleContrast(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

% msg = 'Not implemented: GUI_Callback_btnHist_ParticleInt'; feedbackLvl = 1; errorFlag = 1;

msg = 'Acquiring Contrast Histogram'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

[handles,data] = ACQUIRE_scan(handles,'Contrast');
% [handles,data] = ACQUIRE_DefocusScan_v6(handles,0,1,0);

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handlestxtLog,feedbackLvl,errorFlag);
else
    msg = 'Contrast Histogram Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);