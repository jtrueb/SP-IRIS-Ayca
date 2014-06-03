function GUI_Callback_editZPos(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

pos = str2double(get(handles.editZPos,'String'));
axes = {handles.Stage.axis.z};

[handles] = STAGE_MoveAbsolute(handles,axes,pos);

guidata(hObject,handles);