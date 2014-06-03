function GUI_Callback_editArrayX(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editArrayX,'String'));
[handles] = setParams(handles,'ArrayX',val);

guidata(hObject,handles);