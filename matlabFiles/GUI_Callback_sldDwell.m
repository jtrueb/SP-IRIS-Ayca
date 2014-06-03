function GUI_Callback_sldDwell(hObject, eventData)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = get(handles.sldDwell,'Value');
[handles] = setParams(handles,'DwellTime',val);

guidata(hObject, handles); %save handles data