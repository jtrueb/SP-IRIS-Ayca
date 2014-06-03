function GUI_Callback_radContrast(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = setParams(handles,'MainPlotType','Contrast');
guidata(hObject,handles);