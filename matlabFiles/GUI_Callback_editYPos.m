function GUI_Callback_editYPos(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editYPos,'String'));

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = [getParams(handles,'XPos') val];
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.y};
    pos = val;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

guidata(hObject,handles);