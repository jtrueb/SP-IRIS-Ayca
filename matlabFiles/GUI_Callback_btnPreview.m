function GUI_Callback_btnPreview(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


%Turn on preview
[handles,data] = ACQUIRE_scan(handles,'preview');

guidata(hObject,handles);