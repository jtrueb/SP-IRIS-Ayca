function GUI_Callback_btnPan(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[handles] = CONTROL_zoomMode(handles,'Pan');

guidata(hObject,handles);