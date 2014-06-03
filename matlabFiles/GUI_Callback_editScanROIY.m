function GUI_Callback_editScanROIY(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = floor(str2double(get(handles.editScanROIY,'string')));
roi = getParams(handles,'ROI');
roi(3) = val;
[handles] = setParams(handles,'ROI',roi);
% [handles] = setParams(handles,'Height',val);

guidata(hObject,handles);