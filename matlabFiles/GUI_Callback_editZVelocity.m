function GUI_Callback_editZVelocity(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editZVelocity,'String'));
[handles] = setParams(handles,'ZVelocity',val);

guidata(hObject,handles)