function [data] = STAGE_CONTROL_RESPONSE(stages,command)
%% [data] = STAGE_CONTROL(stages,command)
% stages is a struct created by STAGES_INIT
% command is a string of the action one wants to send.
%
% stages.commands should contain a list of relevant commands
% data will be a string response from the stage controller.

NL = sprintf('\n');
%fprintf('STAGE_CONTROL RESPONSE: %s\n',command);

% data = 0;
% [data] = NET_Sync(stages.host,stages.portnumber,[command NL]);

if (stages.enabled > 0)
    [data] = NET_Sync_v2(stages.host,stages.portnumber,[command NL],stages.communicationType);
else
    data = ' ';
end

pause(0.02);