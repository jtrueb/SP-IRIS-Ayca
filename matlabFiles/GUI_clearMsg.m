function [handles] = GUI_clearMsg(handles)
% Clear status bar
errorFlag = 0; feedbackLvl = 3;
msg = ''; logid = '';

[handles] = GUI_logMsg(handles,msg,logid,handles.txtLog,feedbackLvl,errorFlag);