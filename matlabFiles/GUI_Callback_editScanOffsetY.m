function GUI_Callback_editScanOffsetY(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = floor(str2double(get(handles.editScanOffsetY,'string')));
roi = getParams(handles,'ROI');
roi(1) = val;
[handles] = setParams(handles,'ROI',roi);
% [handles] = setParams(handles,'yOffset',val);

guidata(hObject,handles);