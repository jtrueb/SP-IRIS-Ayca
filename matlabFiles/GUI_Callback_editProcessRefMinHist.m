function GUI_Callback_editProcessRefMinHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editProcessRefMinHist,'String'));
[handles] = setParams(handles,'RefMinHist',val);

guidata(hObject,handles);