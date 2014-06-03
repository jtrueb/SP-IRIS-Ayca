function GUI_Callback_btnWelcome_UnloadChip(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[handles] = STAGE_load(handles);
[answer] = questdlg(['Slide open door. Unload chip. Slide close door.'...
    'Do you wish to load another sample?'],'','Yes','No','No');

if strcmp(answer,'Yes')
    [handles] = GUI_makePopup_LoadChip(handles);
else
    [handles] = CONTROL_WelcomeBtns(handles, 1);%Enable only load chip
    [handles] = CONTROL_Tabs(handles,7);%Disable instrument tab
    
    %Move stage to safe rest position
    [handles] = STAGE_home(handles);
    
    %Set status to 0
    [handles ] = setParams(handles,'ChipLoadStatus',0);
end

guidata(hObject, handles); %save handles data