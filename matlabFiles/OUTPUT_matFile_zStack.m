function [handles] = OUTPUT_matFile_zStack(handles,matName,variables)

%Store struct fields into seperate variables or create empty variables if
%the field doesn't exist
%output_full=variables;
zStack=variables;

save(matName,'zStack');
msg = matName;
[handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog,1);



% msg = 'Calibrating Z-Stack...'; feedbackLvl = 1; errorFlag = 0;
% [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
%     handles.txtLog,feedbackLvl,errorFlag);
% 
% analysis_output = ZSTACK_quickfocus_kde(zStack,matName);
% 
% matName_analysis = [matName '_alignment'];
% save(matName_analysis,'analysis_output');


