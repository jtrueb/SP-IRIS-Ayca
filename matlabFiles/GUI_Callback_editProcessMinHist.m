function GUI_Callback_editProcessMinHist(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editProcessMinHist,'String'));
[handles] = setParams(handles,'MinHist',val);

guidata(hObject,handles);