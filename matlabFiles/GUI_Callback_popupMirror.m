function GUI_Callback_popupMirror(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = IMAGE_MainImage_loadData(handles);

guidata(hObject,handles);