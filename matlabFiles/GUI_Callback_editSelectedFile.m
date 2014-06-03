function GUI_Callback_editSelectedFile(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editSelectedFile,'String'));
[handles] = setParams(handles,'CurrentFile',val);

guidata(hObject,handles);