function GUI_Callback_editMaxHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editMaxHist,'String'));
[handles] = setParams(handles,'MaxHist',val);

guidata(hObject,handles);