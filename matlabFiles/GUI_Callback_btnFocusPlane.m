function GUI_Callback_btnFocusPlane(hObject, eventdata)
%callback function - Calculates a focus plane by focusing on 3 or 5 points around the chip
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curState]  = getParams(handles,'BtnState');
handles = CONTROL_WelcomeBtns(handles, 10);

% msg = 'Focusing'; feedbackLvl = 1; errorFlag = 0;
% [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
%     handles.txtLog,feedbackLvl,errorFlag);

numcorners=getParams(handles,'numCorners');

if numcorners==3
    msg = 'Full Calibration and Array Acquire'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
    
    [handles] = FOCUS_planecal_full(handles);
elseif numcorners==4
    msg = 'Z-Only Calibration and Array Acquire'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
    [handles]=FOCUS_planecal_zonly(handles);
end

% [handles,data] = ACQUIRE_DefocusScan_v6(handles,0,1,0);
[handles] = ACQUIRE_array(handles,'save');

    
%% super-old function call, never implemented
% [handles] = FOCUS_CalcOffset(handles);


%%Current full plane determination and array acquire
% [handles] = FOCUS_ThreeCorners_morph(handles);
% [handles] = ACQUIRE_array(handles,'save');




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

guidata(hObject, handles); %save handles data