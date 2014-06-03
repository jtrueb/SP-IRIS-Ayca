function GUI_Callback_popupChipInfo_editSaveFolder(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

dir = get(handles.txtValueSaveFolder,'String');
[handles] = setParams(handles,'popupChipInfo_Directory',dir);

guidata(hObject, handles);