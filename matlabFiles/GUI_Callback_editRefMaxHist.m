function GUI_Callback_editRefMaxHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editRefMaxHist,'String'));
[handles] = setParams(handles,'RefMaxHist',val);

guidata(hObject,handles);