function GUI_Callback_editMinimapContrast(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editMinimapContrast,'String'));
[handles] = setParams(handles,'MinimapContrast',val);
[handles] = IMAGE_Minimap_display(handles);

guidata(hObject,handles);