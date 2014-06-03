function GUI_Callback_editXYVelocity(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editXYVelocity,'String'));
[handles] = setParams(handles,'XYVelocity',val);

guidata(hObject,handles);