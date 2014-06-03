function GUI_Callback_popupFiles(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

temp = get(handles.popupFiles,'Value');
[handles] = setParams(handles,'CurrentFileGroup',temp);

guidata(hObject,handles);