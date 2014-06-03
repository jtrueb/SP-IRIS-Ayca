function GUI_Callback_btnSaveZstack(hObject, eventdata)
%temporarily rewritten to call zstack acquisition function instead



% [handles] = IMAGE_Minimap_save(handles);
%----------------------
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

% msg = 'Not implemented: GUI_Callback_btnHist_ParticleInt'; feedbackLvl = 1; errorFlag = 1;

msg = 'Acquiring Z-Stack'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

% [handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,1,0,'focus',25);

% [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,1,0,'focus',25,0);
[handles,output] = ACQUIRE_autofocus_dynamic_v2(handles,1,0,'second',0,'focus',25,1);
[handles,temp] = ACQUIRE_DefocusScan_v6(handles,0,1,0);
[ output ] = ALIGN_zstack_calibrate_par_diffG(temp.zstack,temp.matname);


handles = CONTROL_WelcomeBtns(handles, curState);
if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handlestxtLog,feedbackLvl,errorFlag);
else
    msg = 'Z-Stack Acquisition Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end


%----------------



guidata(hObject,handles);