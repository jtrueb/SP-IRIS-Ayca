function GUI_Callback_editScanROIX(hObject,eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

val = floor(str2double(get(handles.editScanROIX,'string')));
roi = getParams(handles,'ROI');
roi(4) = val;
[handles] = setParams(handles,'ROI',roi);
% [handles] = setParams(handles,'Width',val);

guidata(hObject,handles);