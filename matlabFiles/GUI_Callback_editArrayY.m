function GUI_Callback_editArrayY(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editArrayY,'String'));
[handles] = setParams(handles,'ArrayY',val);

guidata(hObject,handles);