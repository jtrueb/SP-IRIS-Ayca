function STAGE_MMC_ZERO_V6(stages)
% move MMC100 to home on all 3-axis
% 

send_command_z=[stages.axis.z ' ' stages.commands.mmc_zero];
send_command_xy =[stages.axis.x ' ' stages.commands.mmc_zero ';' ...
                    stages.axis.y ' ' stages.commands.mmc_zero ';'];



[~] = STAGE_MMC(stages, send_command_xy,stages.mmc_portnumber);
[~] = STAGE_MMC(stages, send_command_z,stages.mmc_portnumber_z);




% STAGE_MMC_LOOP_UNTIL_DONE_MOVING_V6(stages);

% send_command = [stages.axis.x ' ' stages.commands.mmc_limit_positive ' 25;' ...
%             stages.axis.x ' ' stages.commands.mmc_limit_negative '  -25;'];
% [data] = STAGE_MMC(stages, send_command);
% 
% send_command = [stages.axis.y ' ' stages.commands.mmc_limit_positive ' 25;' ...
%             stages.axis.y ' ' stages.commands.mmc_limit_negative '  -25;'];
% [data] = STAGE_MMC(stages, send_command);

send_command = [stages.axis.z ' ' stages.commands.mmc_limit_positive ' 5;' ...
            stages.axis.z ' ' stages.commands.mmc_limit_negative '  -5;'];
[data] = STAGE_MMC(stages, send_command, stages.mmc_portnumber_z);

