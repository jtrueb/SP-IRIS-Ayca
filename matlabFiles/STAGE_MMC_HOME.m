function STAGE_MMC_HOME(stages)

send_command = [stages.axis.x ' ' stages.commands.mmc_home ';' ...
            stages.axis.y ' ' stages.commands.mmc_home ';' ...
            stages.axis.z ' ' stages.commands.mmc_home ';'];
[data] = STAGE_MMC(stages, send_command);
pause(3);
STAGE_MMC_LOOP_UNTIL_DONE_MOVING(stages);

STAGE_MMC_ZERO(stages);

