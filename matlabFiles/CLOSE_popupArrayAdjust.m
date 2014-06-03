function CLOSE_popupArrayAdjust(hObject, eventdata)
handles = guidata(hObject);

try
    delete(handles.popupFigure);
catch
end

guidata(handles.mainGUI.panels.figure,handles.mainGUI);