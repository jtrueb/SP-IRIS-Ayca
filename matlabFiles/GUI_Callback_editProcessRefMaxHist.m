function GUI_Callback_editProcessRefMaxHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editProcessRefMaxHist,'String'));
[handles] = setParams(handles,'RefMaxHist',val);

guidata(hObject,handles);