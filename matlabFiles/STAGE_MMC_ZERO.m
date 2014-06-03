function STAGE_MMC_ZERO(stages)
% move MMC100 to home on all 3-axis
% 

send_command = [stages.axis.x ' ' stages.commands.mmc_zero ';' ...
            stages.axis.y ' ' stages.commands.mmc_zero ';' ...
            stages.axis.z ' ' stages.commands.mmc_zero ';'];
[data] = STAGE_MMC(stages, send_command);

STAGE_MMC_LOOP_UNTIL_DONE_MOVING(stages);

send_command = [stages.axis.x ' ' stages.commands.mmc_limit_positive ' 25;' ...
            stages.axis.x ' ' stages.commands.mmc_limit_negative '  -25;'];
[data] = STAGE_MMC(stages, send_command);

send_command = [stages.axis.y ' ' stages.commands.mmc_limit_positive ' 25;' ...
            stages.axis.y ' ' stages.commands.mmc_limit_negative '  -25;'];
[data] = STAGE_MMC(stages, send_command);

send_command = [stages.axis.z ' ' stages.commands.mmc_limit_positive ' 5;' ...
            stages.axis.z ' ' stages.commands.mmc_limit_negative '  -5;'];
[data] = STAGE_MMC(stages, send_command);

