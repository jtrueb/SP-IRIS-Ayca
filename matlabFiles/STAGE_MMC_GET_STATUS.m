function [status] = STAGE_MMC_GET_STATUS(stages, axis,port)

if nargin<3
    port=stages.mmc_portnumber;
end

status = struct();
send_command = [axis ' ' stages.commands.mmc_status ';'];
[data] = STAGE_MMC_RESPONSE(stages, send_command,port);
status.axis = axis;
status.axis_enabled = 1;

% default values
status.error = 0;
status.acceleration = 0;
status.constant_velocity = 0;
status.deceleration = 0;
status.axis_moving = 1;
status.program_running = 0;
status.upper_limit_switch = 0;
status.lower_limit_switch = 0;


if (length(data) > 1) 
    val = str2num(data(2:end));
    if (val >= 128) % 1>= errors have occurred. Use ERR? Or CER to clear
        val = val - 128;
        status.error = 1;
    end
    if (val >= 64) % Currently in Acceleration phase of motion
        val = val - 64;
        status.acceleration = 1;
    end
    if (val >= 32) % Currently in Constant Velocity phase of motion
        val = val - 32;
        status.constant_velocity = 1;
    end
    if (val >= 16) % Currently in Deceleration phase of motion
        val = val - 16;
        status.deceleration = 1;
    end
    if (val >= 8) %Stage has stopped. (In Closed Loop Stage, is in the deadband)
        val = val - 8;
        status.axis_moving = 0;
    end
    if (val >= 4) %A Program is currently running
        val = val - 4;
        status.program_running = 1;
    end        
    if (val >= 2) %Positive Switch is Activated
        val = val - 2;
        status.upper_limit_switch = 1;
    end
    if (val >= 1) %Negative Switch is Activated
        val = val - 1;
        status.lower_limit_switch = 1;
    end
end

        