function STAGE_MMC_ZERO_hybrid(stages)
% move MMC100 to home on all 3-axis
% 

% send_command = [stages.axis.x ' ' stages.commands.mmc_zero ';' ...
%             stages.axis.y ' ' stages.commands.mmc_zero ';' ...
%             stages.axis.z ' ' stages.commands.mmc_zero ';'];

temp_axis_z=stages.axis.z;

if strcmpi(temp_axis_z,'9')
    temp_axis_z='1';
end

send_command = [temp_axis_z ' ' stages.commands.mmc_zero ';'];

[data] = STAGE_MMC(stages, send_command);

STAGE_MMC_LOOP_UNTIL_DONE_MOVING_hybrid(stages);

% send_command = [stages.axis.x ' ' stages.commands.mmc_limit_positive ' 25;' ...
%             stages.axis.x ' ' stages.commands.mmc_limit_negative '  -25;'];
% [data] = STAGE_MMC(stages, send_command);
% 
% send_command = [stages.axis.y ' ' stages.commands.mmc_limit_positive ' 25;' ...
%             stages.axis.y ' ' stages.commands.mmc_limit_negative '  -25;'];
% [data] = STAGE_MMC(stages, send_command);

send_command = [temp_axis_z ' ' stages.commands.mmc_limit_positive ' 5;' ...
            temp_axis_z ' ' stages.commands.mmc_limit_negative '  -5;'];
[data] = STAGE_MMC(stages, send_command);

