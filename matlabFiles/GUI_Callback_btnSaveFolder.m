function GUI_Callback_btnSaveFolder(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


dir = uigetdir(handles.data.saveFolder,'Select save folder');
[handles] = setParams(handles,'MirrorDirectory',dir);
[handles] = setParams(handles,'Directory',dir);

%Commented out, causes an infinite loop!
% [handles] = setParams(handles,'MirrorDirectory',dir);

guidata(hObject, handles);