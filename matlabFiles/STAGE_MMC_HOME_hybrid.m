function STAGE_MMC_HOME_hybrid(stages)

%disabled, home command for 3 axis pps 20
% send_command = [stages.axis.x ' ' stages.commands.mmc_home ';' ...
%             stages.axis.y ' ' stages.commands.mmc_home ';' ...
%             stages.axis.z ' ' stages.commands.mmc_home ';'];

%home command for pps-20 z
%         send_command = [stages.axis.z ' ' stages.commands.mmc_home ';'];
         send_command = ['1' ' ' stages.commands.mmc_home ';'];
        
        
        
[data] = STAGE_MMC(stages, send_command);
pause(3);
STAGE_MMC_LOOP_UNTIL_DONE_MOVING_hybrid(stages);

STAGE_MMC_ZERO_hybrid(stages);

