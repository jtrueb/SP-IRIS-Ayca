function GUI_Callback_btnDefocusScan(hObject,eventdata)
%Focusing using the high-pass filter and particle detection feedback. Only
%the in-focus image and data is saved.
a1 = tic();
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


curState  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

msg = 'Acquiring data'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);

if getParams(handles,'RefParticleStatus')
%     [handles,output] = ACQUIRE_DefocusScan_v3_RP(handles,0,1,0);
a2 = tic();
%     [handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,1,0,'save',25);
% [handles,output] = ACQUIRE_DefocusScan_binarysearch_diffG(handles,0,1,0,'focus',41);
[handles,output] = ACQUIRE_autofocus_dynamic(handles,0,1,0,'save',25,1);
    b2 = toc(a2);
else
    [handles,output] = ACQUIRE_DefocusScan_v3(handles,1,1,0);
%     [handles,output] = ACQUIRE_DefocusScan_v4(handles,1,1,0);
end

handles = CONTROL_WelcomeBtns(handles, curState);

if FLAG_StopBtn('check')     
    FLAG_StopBtn('clear');
    msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else

    if getParams(handles,'RefParticleStatus')
        msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    else
        [handles] = OUTPUT_matFile(handles,output.matName,output);
        [handles] = OUTPUT_excelFile(handles,[output.xlsName output.dateString],output);
        msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    end
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end
b1 = toc(a1);
% fprintf('T1=%.02f, T2=%.02f\n',b1,b2);
guidata(hObject,handles);