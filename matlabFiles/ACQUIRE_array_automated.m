function [handles] = ACQUIRE_array_automated(handles,options)
%[handles] = ACQUIRE_array_automated(handles,options)
%
%The first spot of the array is assumed to be ArrayOffset from the upper
%right corner of the SiO2 square. Spot pitch is defined by ArrayPitch
%
%options
%   0 - Minimap acquisition: Down samples the scan then updates the minimap
%   1 - Preview array scan: Turns on preview and moves stages.
%   2 - Scan array: Acquires and save images and moves stages.

%% Error checking...
if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?
        %% Load Parameters
        [arrayTotal] = getParams(handles,'ArrayTotal'); %
        [arraySize] = getParams(handles,'ArraySize'); %[X Y]
        [homePos] = getParams(handles,'StageHomePos'); %[X Y]
        [array_pitch] = getParams(handles,'Stage_XYIndex'); %[X Y]
        [axes] = {handles.Stage.axis.x handles.Stage.axis.y};
        [smart_flag] = getParams(handles,'SmartMove');
        [arrayOffset] = getParams(handles,'ArrayOffset');
        [curOffset] = getParams(handles,'ChipOffset');
        
        pos = [homePos(1) homePos(2)];
        
        if ischar(options)
            %Set flags
            scanOption = 'take';
            mini_flag = 0;
            scan_flag = 0;
            prev_flag = 0;
            pos = pos + arrayOffset;
            
            if strcmpi(options,'save')
                scan_flag = 1;                                

            elseif strcmpi(options,'preview')
                prev_flag = 1;
                scanOption = 'preview';
                dwell = getParams(handles,'DwellTime');
                
            elseif strcmpi(options,'minimap')
                %Toggle Flag
                mini_flag = 1;
                scanOption = options;
                
                %Load variables
                [numImages] = getParams(handles,'MinimapImageNumber'); %[Y X]
                [pos] = getParams(handles,'MinimapStartPos'); %Starting Position
                FOV = fix(getParams(handles,'FOV')); % [Y X]
                
                %Variables are [Y X]. Need to rearrange.
                arraySize(1) = numImages(2);
                arraySize(2) = numImages(1);
                array_pitch(1) = FOV(2);
                array_pitch(2) = FOV(1);
            end
        end        
        
        %Determine ChipOffset
%         tic
        [handles, offset] = DETECT_Corner(handles);
%         corner = toc
        
        if FLAG_StopBtn('check')
            return;
        end
        
        pos = pos + (offset-curOffset);
        
        %% Acquire data for all images
        initial_pos = pos;
        for i = 1:arraySize(2) %Repeat for every row
            for j = 1:arraySize(1) %Repeat for every column
                istart  = tic;
                %Display Acquiring Msg
                numSpot = (i-1).*arraySize(1)+j;
                [handles] = GUI_logSpotNum(handles,numSpot,arrayTotal);
                
                %Move stage
                if smart_flag
                    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
                    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
                else
                    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
                end

                %% Acquire data
                if scan_flag              
                    if getParams(handles,'RefParticleStatus')
                        [handles,output] = ACQUIRE_DefocusScan_v3_RP(handles,1,1,0);
                    else
                        [handles,output] = ACQUIRE_DefocusScan_v3(handles,1,1,0);
                    end
                    
                    if FLAG_StopBtn('check')
                        if smart_flag
                            [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
                        else
                            [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
                        end
                        
                        return;
                    end

                    output.elapsedTime = toc(istart);
                    output.xspot = arraySize(1)+1-j;
                    output.yspot = i;
                    [handles] = OUTPUT_matFile(handles,output.matName,output);
                    [handles] = OUTPUT_excelFile(handles,output.xlsName,output);
                    
                elseif mini_flag
                    if FLAG_StopBtn('check')
                        return;
                    end
                    [handles,data] = ACQUIRE_scan(handles,scanOption); %Acquire a scan
                    [handles] = IMAGE_Minimap_populate(handles,data,pos);
                    toc(istart);
                    
                elseif prev_flag
                    if FLAG_StopBtn('check')
                        if smart_flag
                            [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
                        else
                            [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
                        end
                        
                        return;
                    end
                    [handles,data] = ACQUIRE_scan(handles,scanOption); %Acquire a scan
                    pause(dwell);
                end
                
                %% Move stage to next spot
                % pos = pos + [cos(angle)*array_pitch(1) sin(angle)];
                pos = pos + [array_pitch(1) 0]; %Column movement
            end
            % pos = initial_pos - [cos(angle) i*sin(angle)*array_pitch(2)];
            pos = initial_pos - [0 i*array_pitch(2)]; %Row movement
        end
        
        if smart_flag
            [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
        else
            [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
        end
        
        if scan_flag
            [handles] = DATA_CheckFileGroup(handles,getParams(handles,'ChipID'));
        elseif mini_flag
            [handles] = IMAGE_Minimap_save(handles);
        end
        
    else
        msg = 'Stages are not initialized'; feedbackLvl = 1; errorFlag = 1;
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
            handles.txtLog,feedbackLvl,errorFlag);
    end
else
    msg = 'No sample loaded'; feedbackLvl = 1; errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
end