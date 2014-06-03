 function GUI_Callback_btnZoomIn(hObject, eventdata)
[handles] = guidata(hObject);

[handles] = CONTROL_zoomMode(handles,'Zoom In');

guidata(hObject,handles);