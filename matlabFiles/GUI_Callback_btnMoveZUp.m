function GUI_Callback_btnMoveZUp(hObject, eventdata)
%Shifts the stage up by ZStep
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


pos = getParams(handles,'ZPos') + getParams(handles,'ZStep');
axes = {handles.Stage.axis.z};

[handles] = STAGE_MoveAbsolute(handles,axes,pos);

guidata(hObject,handles);