function CLOSE_popupLoadChip(hObject, eventdata)
handles = guidata(hObject);

try
    delete(handles.icon);
catch
end
try
    delete(handles.popupFigure);
catch
end

[handles.mainGUI] = setParams(handles.mainGUI,'ChipLoadStatus',1);
[handles.mainGUI] = STAGE_home(handles.mainGUI);

[handles.mainGUI] = CONTROL_WelcomeBtns(handles.mainGUI, 2);
[handles.mainGUI] = CONTROL_Tabs(handles.mainGUI,0);
guidata(handles.mainGUI.panels.figure,handles.mainGUI);