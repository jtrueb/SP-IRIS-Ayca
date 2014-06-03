function GUI_Callback_editXPos(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editXPos,'String'));

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = [val getParams(handles,'YPos')];
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.x};
    pos = val;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

guidata(hObject,handles);