function GUI_Callback_editXYStep(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = str2double(get(handles.editXYStep,'String'));
[handles] = setParams(handles,'YStep',val);
[handles] = setParams(handles,'XStep',val);

guidata(hObject,handles);