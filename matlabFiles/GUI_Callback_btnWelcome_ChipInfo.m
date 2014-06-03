function GUI_Callback_btnWelcome_ChipInfo(hObject, eventdata)
%Callback function - Prompts user to enter chip info. Enables SetParams
%button
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[handles] = GUI_makePopup_ChipInfo(handles);

guidata(hObject, handles); %save handles data