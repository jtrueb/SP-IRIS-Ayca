function GUI_Callback_btnAutofocus(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

msg = 'Focusing'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

% Autofocus
% [handles, val] = FOCUS_Image(handles,2,1,1,0);
% [handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,1,0,'focus',25);
% [handles,output] = ACQUIRE_DefocusScan_binarysearch_diffG(handles,0,1,0,'focus',33);
a=tic;
% [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,1,0,'focus',25,1);
[handles,output] = ACQUIRE_autofocus_dynamic_v2(handles,1,0,'max',0,'focus',25,0);

toc(a);

handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    msg = 'Focus Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end

guidata(hObject,handles);