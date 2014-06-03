function GUI_Callback_editDwell(hObject, eventData)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editDwell,'String'));
[handles] = setParams(handles,'DwellTime',val);

guidata(hObject, handles); %save handles data