function GUI_Callback_popupSelectCamera(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = get(handles.popupSelectCamera,'Value');
str = handles.const.Camera.Names(val);

[handles] = CAMERA_loadDefaults(handles,str);

guidata(hObject, handles);