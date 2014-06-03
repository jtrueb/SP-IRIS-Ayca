function GUI_Callback_popupChipType(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupChipType,'Value');
[handles] = setParams(handles,'ChipType',currentIndex);

guidata(hObject,handles);