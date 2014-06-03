function GUI_Callback_btnChipInfo_popupOk(hObject, eventdata)
handles = guidata(hObject);

handles.keep = 1;
guidata(hObject,handles);
close(handles.popupFigure);