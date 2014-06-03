function CLOSE_popupWelcomeAcquire(hObject, eventdata)
handles = guidata(hObject);

try
    delete(handles.popupFigure);
catch
end
[handles.mainGUI] = ACQUIRE_array(handles.mainGUI,'save');

[handles.mainGUI] = CONTROL_WelcomeBtns(handles.mainGUI, 5);
guidata(handles.mainGUI.panels.figure,handles.mainGUI);