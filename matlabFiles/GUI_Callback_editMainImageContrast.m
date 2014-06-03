function GUI_Callback_editMainImageContrast(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editMainImageContrast,'String'));
[handles] = setParams(handles,'MainImageContrast',val);
[handles] = IMAGE_MainImage_loadData(handles);

guidata(hObject,handles);