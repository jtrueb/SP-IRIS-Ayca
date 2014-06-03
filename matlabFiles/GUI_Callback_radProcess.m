function GUI_Callback_radProcess(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = setParams(handles,'MainPlotType','Process');

guidata(hObject,handles);