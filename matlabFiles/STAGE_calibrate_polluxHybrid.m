function STAGE_calibrate_polluxHybrid(stages)
if nargin < 1
    stages = STAGE_INIT();
end



%% Z STAGE
% [data] = 1;
% [Notzeroedout] = 1;
% loopenable = 1;

%commented out, no z axis
% [data] = STAGE_CONTROL(stages,['0.0001 ' stages.axis.z ' ' stages.commands.setClWindow]); %Close Loop window error set to 50nm
% [data] = STAGE_CONTROL(stages,[stages.commands.disable_char ' ' stages.axis.z ' ' stages.commands.setSelPos]); %stages will return encoder location (1)

%while (Notzeroedout)
    %% NEED TO ENABLE CLOSED LOOP TO GET THE CORRECT ANSWER HERE
%     [data] = STAGE_CONTROL(stages,[stages.commands.enable_char ' ' stages.axis.z ' ' stages.commands.closed_loop]); %sets axis z for closed loop control
%     pause(0.5);
%     [data] = STAGE_CONTROL(stages,[stages.commands.enable_char ' ' stages.axis.z ' ' stages.commands.set_axis_enabled]); %activates z axis for use
%     pause(0.5);
%     [data] = STAGE_CONTROL(stages,[stages.axis.z ' ' stages.commands.calibrate_limit]); %moves the stage all the way bckwards
%     loopenable = 1;
%     while (loopenable) 
%         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.status]));
%         if (data == stages.status(str2num(stages.axis.z)) & ~isempty(data))
%             loopenable = 0;
%         end
%     end
 
%% X & Y STAGE
[data] = 1;
[Notzeroedout] = 1;
loopenable = 1;
while (Notzeroedout)
    [data] = STAGE_CONTROL(stages,[stages.axis.x ' ' stages.commands.calibrate_limit]); %moves the stage all the way bckwards
    [data] = STAGE_CONTROL(stages,[stages.axis.y ' ' stages.commands.calibrate_limit]); %moves the stage all the way bckwards
    loopenable = 1;
    while (loopenable)
        [xdata] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.x ' ' stages.commands.status]));
        [ydata] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.y ' ' stages.commands.status]));
        if (xdata == stages.status(str2num(stages.axis.x)) && ~isempty(xdata)...
                && ydata == stages.status(str2num(stages.axis.y)) && ~isempty(ydata))
            loopenable = 0;
        end
    end
    [x y z] = STAGE_getPositions(stages);
    if (x == 0) && (y == 0)
        Notzeroedout = 0;
    end
end

% %% X STAGE
% [data] = 1;
% [Notzeroedout] = 1;
% loopenable = 1;
% while (Notzeroedout)
%     while (loopenable) 
%         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.x ' ' stages.commands.status]));
%         if (data == stages.status(str2num(stages.axis.x)) & ~isempty(data))
%             loopenable = 0;
%         end
%     end
%     [data] = STAGE_CONTROL(stages,[stages.axis.x ' ' stages.commands.calibrate_limit]); %moves the stage all the way bckwards
%     loopenable = 1;
%     while (loopenable) 
%         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.x ' ' stages.commands.status]));
%         if (data == stages.status(str2num(stages.axis.x)) & ~isempty(data))
%             loopenable = 0;
%         end
%     end
%     [x y z] = STAGE_getPositions(stages);
%     if (x == 0)
%         Notzeroedout = 0;
%     end
% end
% 
% %% Y STAGE
% [data] = 1;
% [Notzeroedout] = 1;
% loopenable = 1;
% while (Notzeroedout)
%     while (loopenable) 
%         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.y ' ' stages.commands.status]));
%         if (data == stages.status(str2num(stages.axis.y)) & ~isempty(data))
%             loopenable = 0;
%         end
%     end
%     [data] = STAGE_CONTROL(stages,[stages.axis.y ' ' stages.commands.calibrate_limit]); %moves the stage all the way bckwards
%     loopenable = 1;
%     while (loopenable) 
%         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.y ' ' stages.commands.status]));
%         if (data == stages.status(str2num(stages.axis.y)) & ~isempty(data))
%             loopenable = 0;
%         end
%     end
%     [x y z] = STAGE_getPositions(stages);
%     if (y == 0)
%         Notzeroedout = 0;
%     end
% end

% [data] = STAGE_CONTROL(stages,[stages.commands.enable_char ' ' stages.axis.z ' ' stages.commands.setSelPos]); %Set encoder as method of position finding
% [data] = STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.getSelPos]); %stages will return encoder location (1)