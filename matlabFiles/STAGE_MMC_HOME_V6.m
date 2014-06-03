function STAGE_MMC_HOME_V6(stages)

%disabled, home command for 3 axis pps 20
% send_command = [stages.axis.x ' ' stages.commands.mmc_home ';' ...
%             stages.axis.y ' ' stages.commands.mmc_home ';' ...
%             stages.axis.z ' ' stages.commands.mmc_home ';'];

%home command for pps-20 z
%         send_command = [stages.axis.z ' ' stages.commands.mmc_home ';'];
send_command_z=[stages.axis.z ' ' stages.commands.mmc_home];
send_command_xy =[stages.axis.x ' ' stages.commands.mmc_home ';' ...
                    stages.axis.y ' ' stages.commands.mmc_home ';'];
    

    
        
        
[~] = STAGE_MMC(stages, send_command_xy,stages.mmc_portnumber);
[~] = STAGE_MMC(stages, send_command_z,stages.mmc_portnumber_z);
pause(.5);
STAGE_MMC_LOOP_UNTIL_DONE_MOVING_V6(stages);
pause(1);
STAGE_MMC_ZERO_V6(stages);

