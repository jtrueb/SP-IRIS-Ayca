function CLOSE_popupFocusOffset(hObject, eventdata)
handles = guidata(hObject);

Stage_pos = getParams(handles.mainGUI,'Stage_Pos');
FC_pos = getParams(handles.mainGUI,'FocusPos');

offset = [Stage_pos(1) Stage_pos(2)] - [FC_pos{1}(1) FC_pos{1}(2)];
FC_pos{1}(3) = Stage_pos(3);

[handles.mainGUI] = setParams(handles.mainGUI,'FocusPos',FC_pos);
[handles.mainGUI] = setParams(handles.mainGUI,'ChipOffset',offset);

try
    delete(handles.icon);
catch
end

try
    delete(handles.popupFigure);
catch
end

numCorners = getParams(handles.mainGUI,'numCorners');
if numCorners == 3
    [handles.mainGUI] = FOCUS_ThreeCorners(handles.mainGUI);
elseif numCorners == 4
    [handles.mainGUI] = FOCUS_FourCorners(handles.mainGUI);
end

[handles.mainGUI] = STAGE_home(handles.mainGUI);
guidata(handles.mainGUI.panels.figure,handles.mainGUI);