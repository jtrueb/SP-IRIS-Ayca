function [x y z] = STAGE_getPositions(stages)
x=0;
y=0;
z=0;
if isfield(stages,'mmc_host') %PPS-20
    if strcmpi(stages.version,'V5')
        [z] = STAGE_MMC_getPositions_hybrid(stages);
    elseif strcmpi(stages.version,'V6')
        [x,y,z]=STAGE_MMC_getPositions_2port(stages);
    else
    [x y z] = STAGE_MMC_getPositions(stages);
    end
end
if isfield(stages,'host')
    %This function will return the x, y and z position of the stage. [um] 

        
        

        
        [data] = 1;
        while (data ~= stages.status(str2num(stages.axis.x)) | isempty(data))
            [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.x ' ' stages.commands.status]));
        end
        x = STAGE_CONTROL_RESPONSE(stages,[stages.axis.x ' ' stages.commands.current_position]);
        
        [data] = 1;
        while (data ~= stages.status(str2num(stages.axis.y)) | isempty(data))
            [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.y ' ' stages.commands.status]));
        end
        y = STAGE_CONTROL_RESPONSE(stages,[stages.axis.y ' ' stages.commands.current_position]);
        
        [data] = 1;
        %% HACK FOR DISABLING CLOSED LOOP
        if ~strcmpi(stages.version,'V5')
            while ((data ~= stages.status(str2num(stages.axis.z)) & data ~= 0) | isempty(data)) %32 is feedback mode
                [data] = str2num(STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.status]));
            end
               z = STAGE_CONTROL_RESPONSE(stages,[stages.axis.z ' ' stages.commands.current_position]);
            
            z = str2double(z)/stages.convert;
        end

    x = str2double(x)/stages.convert;
    y = str2double(y)/stages.convert;
    
end

