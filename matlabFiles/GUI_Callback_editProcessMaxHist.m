function GUI_Callback_editProcessMaxHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editProcessMaxHist,'String'));
[handles] = setParams(handles,'MaxHist',val);

guidata(hObject,handles);