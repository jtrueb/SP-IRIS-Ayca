function GUI_Callback_editMinHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editMinHist,'String'));
[handles] = setParams(handles,'MinHist',val);

guidata(hObject,handles);