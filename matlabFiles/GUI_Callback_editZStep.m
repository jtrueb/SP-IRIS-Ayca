function GUI_Callback_editZStep(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editZStep,'String'));
[handles] = setParams(handles,'ZStep',val);

guidata(hObject,handles);