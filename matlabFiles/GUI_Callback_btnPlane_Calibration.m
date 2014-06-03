function GUI_Callback_btnPlane_Calibration(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[curState] = getParams(handles,'BtnState');
[handles] = CONTROL_WelcomeBtns(handles, 10);



numcorners=getParams(handles,'numCorners');

if numcorners==3
    msg = 'Full Plane Calibration'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);
    
    [handles] = FOCUS_planecal_full(handles);
elseif numcorners==4
    
    msg = 'Z-Only Plane Calibration'; feedbackLvl = 1; errorFlag = 0;
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
    handles.txtLog,feedbackLvl,errorFlag);
    [handles]=FOCUS_planecal_zonly(handles);
end

% [handles] = ACQUIRE_array(handles, 'minimap');
% [handles] = FOCUS_ThreeCorners_morph(handles);

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

guidata(hObject,handles);