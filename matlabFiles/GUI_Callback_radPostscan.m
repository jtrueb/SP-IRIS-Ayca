function GUI_Callback_radPostscan(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = setParams(handles,'ScanType','Postscan');

guidata(hObject,handles);