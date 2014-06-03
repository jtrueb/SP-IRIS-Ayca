function GUI_Callback_axesMain(hObject, eventdata)
% call GUI_axesMainClick Function
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


% [handles] = CONTROL_axesMain_Click(handles);

guidata(hObject, handles);