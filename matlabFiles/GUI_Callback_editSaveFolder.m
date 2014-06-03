function GUI_Callback_editSaveFolder(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

dir = get(handles.txtValueSaveFolder,'String');
[handles] = setParams(handles,'Directory',dir);
[handles] = setParams(handles,'MirrorDirectory',dir);

guidata(hObject, handles);