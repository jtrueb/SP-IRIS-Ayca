function GUI_Callback_editScanExposure(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editScanExposure,'String'));
[handles] = setParams(handles,'Exposure',val);

guidata(hObject,handles);