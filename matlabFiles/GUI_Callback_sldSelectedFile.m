function GUI_Callback_sldSelectedFile(hObject, eventdata)
% GUI_Callback_slideTime(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = get(handles.sldSelectedFile,'Value');
[handles] = setParams(handles,'CurrentFile',val);

guidata(hObject, handles); %save handles data