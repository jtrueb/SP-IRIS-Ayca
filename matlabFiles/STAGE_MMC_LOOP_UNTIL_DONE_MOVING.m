function STAGE_MMC_LOOP_UNTIL_DONE_MOVING(stages)
%% This function will block until the stages are done moving


x_moving = 1;
y_moving = 1;
z_moving = 1;


while (y_moving == 1)
    [y_moving] = check_moving(stages, stages.axis.y);
end
while (x_moving == 1)
    [x_moving] = check_moving(stages, stages.axis.x);
end
while (z_moving == 1)
    [z_moving] = check_moving(stages, stages.axis.z);
end
  

function [moving] = check_moving(stages, axis_in)

delay_t = 0.02;
moving = 1;

[status] = STAGE_MMC_GET_STATUS(stages, axis_in);
if (status.axis_moving == 0)
    moving = 0;
end
pause(delay_t); %20 ms delay between checks


