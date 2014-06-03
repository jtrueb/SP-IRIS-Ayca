function GUI_Callback_btnZoomFull(hObject, eventdata)
[handles] = guidata(hObject);

[handles] = CONTROL_zoomMode(handles,'Zoom Full');

guidata(hObject,handles);