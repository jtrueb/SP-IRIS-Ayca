function GUI_Callback_btnWelcome_Focus(hObject, eventdata)
%callback function - Initializes stages and focuses sample
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curExp] = getParams(handles,'Exposure');
[prevExp] = getParams(handles,'PreviewExposure');
[curState]  = getParams(handles,'BtnState');
[handles] = CONTROL_WelcomeBtns(handles, 10);

msg = 'Focusing'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

%%%%%%%%%%%%%%%%%%%% Automatic Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic
[handles] = setParams(handles,'Exposure',prevExp);
%[handles] = FOCUS_Coarse_Automatic(handles);
[handles,output] = ACQUIRE_DefocusScan_binarysearch_diffG(handles,0,1,0,'focus',81); %25);
%[handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,1,0,'focus',41); %25);
[handles] = setParams(handles,'Exposure',curExp);
% focus = toc
%%%%%%%%%%%%%%%%%%%% Manual Method %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [handles] = FOCUS_CalcOffset(handles);

if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    [handles] = CONTROL_WelcomeBtns(handles, curState);
    
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    [handles] = CONTROL_WelcomeBtns(handles, 4);
    msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject, handles); %save handles data