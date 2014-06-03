function GUI_Callback_btnWelcome_LoadChip(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

%[handles] = STAGE_checkStatus(handles); % commented out,unnecessary check, dsf 03/11/2014
[handles] = STAGE_load(handles);

[handles] = GUI_makePopup_LoadChip(handles);

guidata(hObject, handles); %save handles data