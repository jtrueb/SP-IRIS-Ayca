function GUI_Callback_btnWelcome_Stop(hObject, eventdata)
% GUI_Callback_btnWelcome_Stop
%Creates a file 'temp.lck' in the current directory. Other functions will
%check for this file's existence to determine if the interrupt flag has
%been thrown
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[status] = FLAG_StopBtn('throw');
[handles] = CONTROL_WelcomeBtns(handles, 5);

msg = 'Stopping. Please wait...'; feedbackLvl = 1; errorFlag = 1;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

guidata(hObject, handles); %save handles data