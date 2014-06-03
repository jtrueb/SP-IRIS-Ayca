function GUI_Callback_btnWelcome_OpenVersionLog(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


GUI_makePopup_Textfile('../documentation/version_log.txt','Version Log'); %,command);