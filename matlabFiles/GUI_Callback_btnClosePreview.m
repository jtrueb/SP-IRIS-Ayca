function GUI_Callback_btnClosePreview(hObject,eventdata)
%Closes preview if it is open
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[handles] = CAMERA_checkPreview(handles);

guidata(hObject,handles);