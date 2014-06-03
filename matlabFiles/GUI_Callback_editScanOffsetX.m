function GUI_Callback_editScanOffsetX(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = floor(str2double(get(handles.editScanOffsetX,'String')));
roi = getParams(handles,'ROI');
roi(2) = val;
[handles] = setParams(handles,'ROI',roi);
% [handles] = setParams(handles,'xOffset',val);

guidata(hObject,handles);