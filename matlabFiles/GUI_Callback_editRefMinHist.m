function GUI_Callback_editRefMinHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editRefMinHist,'String'));
[handles] = setParams(handles,'RefMinHist',val);

guidata(hObject,handles);