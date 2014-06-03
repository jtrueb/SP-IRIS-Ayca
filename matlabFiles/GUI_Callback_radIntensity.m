function GUI_Callback_radIntensity(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

[handles] = setParams(handles,'MainPlotType','Intensity');

guidata(hObject,handles);