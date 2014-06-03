function GUI_Callback_btnChipInfo_popupCancel(hObject, eventdata)
handles = guidata(hObject);

handles.keep = 0;
guidata(hObject,handles);
close(handles.popupFigure);