function GUI_Callback_radPrescan(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = setParams(handles,'ScanType','Prescan');

guidata(hObject,handles);