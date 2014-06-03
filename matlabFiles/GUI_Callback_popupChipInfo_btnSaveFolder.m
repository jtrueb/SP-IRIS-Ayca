function GUI_Callback_popupChipInfo_btnSaveFolder(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

dir = uigetdir(handles.data.saveFolder,'Select save folder');
[handles] = setParams(handles,'popupChipInfo_Directory',dir);

guidata(hObject, handles);