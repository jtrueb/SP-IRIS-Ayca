function STAGE_move(stages,axes,steps,relativeOrAbsolute,EncoderHandle)
%This function will move the stage to an relative posision. 
%It can move one, two, or all three axes. 

% stages is a struct created by STAGES_INIT

%axes a cell array of strings of the axis(es) one desires to move
% i.e. {1} or {stages.axis.x} or 
% {stages.axis.x,stages.axis.y,stages.axis.z}, etc.

%steps must be the same length as axes and corresponds to the distance in
%mm one desires to move each axis. 
% i.e. [0.4] or [1.3 -3.3] or [-2.3 4.5 -5.55]

%Updated 1/7/2014 to remove closed loop settle window logic check.  Now
%loops until z-target < 25nm;

steps = steps.*stages.convert;

if nargin < 4
    relativeOrAbsolute = stages.commands.move_absolute;
end


if strcmpi(stages.version,'V3')
    for i = 1:length(axes)
        string = num2str(steps(i));
        if(isempty(find('.' == string)))
            string = [string '.'];
        end
        [data] = 1;
        loopenable = 1;

        %Move axis
        send_command = [axes{i} ' ' relativeOrAbsolute ...
            ' ' string ';'];
        [data] = STAGE_MMC(stages, send_command);
        STAGE_MMC_LOOP_UNTIL_DONE_MOVING(stages);
    end
elseif strcmpi(stages.version,'V5')
    for i = 1:length(axes)
        string = num2str(steps(i));
        if(isempty(find('.' == string)))
            string = [string '.'];
        end
        

        %Move axis
        
        if strcmpi(axes{i},'9')
            send_command = ['1' ' ' stages.commands.mmc_move_absolute ...
                ' ' string ';'];
            [data] = STAGE_MMC(stages, send_command);
            STAGE_MMC_LOOP_UNTIL_DONE_MOVING_hybrid(stages);
        else
            [data] = 1;
        loopenable = 1;
            [data] = STAGE_CONTROL(stages,[string ' ' axes{i} ' ' relativeOrAbsolute]);
            
            while loopenable
                [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.status]));
                if (data == stages.status(str2num(axes{i})) && ~isempty(data))
                    loopenable = 0;
                end
            end
        end
    end
elseif strcmpi(stages.version,'V6')
    for i = 1:length(axes)
        string = num2str(steps(i));
        if(isempty(find('.' == string)))
            string = [string '.'];
        end
        

        %Move axis
        
        if strcmpi(axes{i},'1')
            send_command = [axes{i} ' ' stages.commands.mmc_move_absolute ...
                ' ' string ';'];
            [data] = STAGE_MMC_port(stages, send_command, stages.mmc_portnumber);
%             port=stages.
            STAGE_MMC_LOOP_UNTIL_DONE_MOVING_V6(stages);
        elseif strcmpi(axes{i},'2')
            send_command = [axes{i} ' ' stages.commands.mmc_move_absolute ...
                ' ' string ';'];
            [data] = STAGE_MMC_port(stages, send_command,stages.mmc_portnumber);
            STAGE_MMC_LOOP_UNTIL_DONE_MOVING_V6(stages);
        elseif strcmpi(axes{i},'3')
            send_command = [axes{i} ' ' stages.commands.mmc_move_absolute ...
                ' ' string ';'];
            [data] = STAGE_MMC_port(stages, send_command,stages.mmc_portnumber_z);
            STAGE_MMC_LOOP_UNTIL_DONE_MOVING_V6(stages);
            
        else
            [data] = 1;
        loopenable = 1;
            [data] = STAGE_CONTROL(stages,[string ' ' axes{i} ' ' relativeOrAbsolute]);
            
            while loopenable
                [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.status]));
                if (data == stages.status(str2num(axes{i})) && ~isempty(data))
                    loopenable = 0;
                end
            end
        end
    end
else

    if stages.powerOff
        STAGE_setVoltage(stages, [stages.axis.Vx stages.axis.Vy stages.axis.Vz]);
    end


    for i = 1:length(axes)
        string = num2str(steps(i));
        if(isempty(find('.' == string)))
            string = [string '.'];
        end
        [data] = 1;
        loopenable = 1;


        %See if the stages are moving. REMOVED 1/7/2014

    %     while (loopenable)
    %         [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.status]));
    %         if (data == stages.status(str2num(axes{i})) & ~isempty(data))
    %             loopenable = 0;
    %         end
    %         
    %         
    %         
    %     end

        %Move axis
        [data] = STAGE_CONTROL(stages,[string ' ' axes{i} ' ' relativeOrAbsolute]);
        loopenable = 1;
        %See if the stages are moving
        while (loopenable)
            %Update Encoder text box
            z = STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.current_position]);
            z_microns=str2num(z)*1000;
            set(EncoderHandle,'String',num2str(z_microns));


            %Check stage status
            if str2num(axes{i})==3
                difference_1=abs(z_microns-steps(i)*1000);
                if (difference_1<=.04)
                    pause(.05);

                    z = STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.current_position]);
                    z_microns=str2num(z)*1000;
                    set(EncoderHandle,'String',num2str(z_microns));
                    difference_2=abs(z_microns-steps(i)*1000);

                    if (difference_2<=.04)
                        loopenable = 0;
                    end 
                end
            else


            [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.status]));
            if (data == stages.status(str2num(axes{i})) & ~isempty(data))
                loopenable = 0;
            end

            end
        end
    end
    % [dataActual] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.current_position]));
    % fprintf('(um) Pos = %.4f, Actual = %.4f, Diff = %.4f\n',str2num(string)*1000,dataActual*1000,(str2num(string)-dataActual)*1000);

    if stages.powerOff
        STAGE_setVoltage(stages,[0 0 0]);
    end
    % [dataActual] = str2num(STAGE_CONTROL_RESPONSE(stages,[axes{i} ' ' stages.commands.current_position]));
    % fprintf('(um) Pos = %.4f, Actual = %.4f, Diff = %.4f\n',str2num(string)*1000,dataActual*1000,(str2num(string)-dataActual)*1000);
end