function GUI_Callback_chkUseMirror(hObject, eventdata)
%GUI_Callback_chkUseMirror(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[handles] = IMAGE_MainImage_loadData(handles);

guidata(hObject, handles); %save handles data
