function GUI_Callback_btnZoomOut(hObject, eventdata)
[handles] = guidata(hObject);

[handles] = CONTROL_zoomMode(handles,'Zoom Out');

guidata(hObject, handles); %save handles data