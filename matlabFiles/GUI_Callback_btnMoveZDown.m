function GUI_Callback_btnMoveZDown(hObject, eventdata)
%Shifts the stage down by ZStep
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


pos = getParams(handles,'ZPos') - getParams(handles,'ZStep');
axes = {handles.Stage.axis.z};

[handles] = STAGE_MoveAbsolute(handles,axes,pos);

guidata(hObject,handles);