function GUI_Callback_btnWelcome_Acquire(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
%
%Need to implement an automated way of locating the first spot or
%incorporate preview location here
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curState] = getParams(handles,'BtnState');
[handles] = CONTROL_WelcomeBtns(handles, 10);

msg = 'Acquiring data'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

%Assumes user is currently at UR spot of array
[handles] = ACQUIRE_array(handles,'save');

%Brings up preview for user to locate UR spot of array
% [handles,data] = ACQUIRE_scan(handles,'preview');
% [handles] = GUI_makePopup_WelcomeAcquire(handles);

if FLAG_StopBtn('check')
    FLAG_StopBtn('clear');
    [handles] = CONTROL_WelcomeBtns(handles, curState);
    
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    [handles] = CONTROL_WelcomeBtns(handles, 5);
    msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject, handles); %save handles data