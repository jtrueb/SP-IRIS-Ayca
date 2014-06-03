function [handles] = ACQUIRE_array(handles,options)
%[handles] = ACQUIRE_array(handles,options)
%
%options
%   0 - Minimap acquisition: Down samples the scan then updates the minimap
%   1 - Preview array scan: Turns on preview and moves stages
%   2 - Scan array: Acquires and save images and moves stages
% fprintf('Need to implement ACQUIRE_array\n');

%% Error checking...
if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?
        %% Load Parameters
        [arrayTotal] = getParams(handles,'ArrayTotal'); %
        [arraySize] = getParams(handles,'ArraySize'); %[X Y]
        [pos] = getParams(handles,'Stage_XYPos'); %[X Y]
        [array_pitch] = getParams(handles,'Stage_XYIndex'); %[X Y]
        [axes] = {handles.Stage.axis.x handles.Stage.axis.y};
        [smart_flag] = getParams(handles,'SmartMove');
        [rowOffset] = getParams(handles,'RowOffset');
        
        if ischar(options)
            %Set flags
            scanOption = 'take';
            mini_flag = 0;
            scan_flag = 0;
            prev_flag = 0;
            
            if strcmpi(options,'save')
                scan_flag = 1;                                

            elseif strcmpi(options,'preview')
                prev_flag = 1;
                scanOption = 'preview';
                dwell = getParams(handles,'DwellTime');
                
            elseif strcmpi(options,'adjust')
                prev_flag = 1;
                scanOption = 'adjust';
                offsets = zeros(arraySize(2),2); %Preallocate offsets to 0
                arraySize(1) = 1; %Only scan the first spot in each row
                
            elseif strcmpi(options,'minimap')
                %Toggle Flag
                mini_flag = 1;
                scanOption = options;
                scan_flag = 1;
                
                %Load variables
                [offset] = getParams(handles,'ChipOffset');
                [numImages] = getParams(handles,'MinimapImageNumber'); %[Y X]
                [pos] = getParams(handles,'MinimapStartPos'); %Starting Position
                FOV = fix(getParams(handles,'FOV')); % [Y X]
                
                %Variables are [Y X]. Need to rearrange.
                arraySize(1) = numImages(2);
                arraySize(2) = numImages(1);
                array_pitch(1) = FOV(2);
                array_pitch(2) = FOV(1);
                
                %Move stage to starting position
                if smart_flag
                    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
                    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
                else
                    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
                end
            end
        end
        
        %% Acquire data for all images
        initial_pos = pos + rowOffset(1,:);
        temp_pos=pos;
        time_total=tic;
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
                    
                    save_dir=getParams(handles,'Directory');
                    chip_name=getParams(handles,'ChipID');
                    xlsname=[save_dir,chip_name];
                    
                    %% Move stage to next spot
                % pos = pos + [cos(angle)*array_pitch(1) sin(angle)];
                pos = temp_pos + [array_pitch(1) array_pitch(2)].*[j-1,i-1]; %Column movement
                    
                    if getParams(handles,'RefParticleStatus')
%                         [handles,output] = ACQUIRE_DefocusScan_v3_RP(handles,0,1,0);
                        %[handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,1,0,'save',25);
%                         [handles,output] = ACQUIRE_DefocusScan_binarysearch_diffG(handles,0,1,0,'save',33,0);
                        [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,1,0,'save',21,1);
                    else
                        [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,1,0,'save',21,1);
%                         [handles,output] = ACQUIRE_DefocusScan_v3(handles,0,1,0);
%                         [handles,output] = ACQUIRE_DefocusScan_v4(handles,1,1,0);
                    end                    
                    
                    if FLAG_StopBtn('check')
                        if smart_flag
                            [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
                        else
                            [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
                        end
                        
                        return;
                    end
disp(['Total array scan time: ' num2str(toc(time_total))]);
                    
                    output.elapsedTime = toc(istart);
                    output.xspot = arraySize(1)+1-j;
                    output.yspot = i;
%                    [handles] = OUTPUT_matFile(handles,output.matName,output);
%                    [handles] = OUTPUT_excelFile(handles,xlsname,output);
                   %[handles] = OUTPUT_excelFile(handles,'HACK.xls',output);
                    
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
                    
                    if strcmpi(scanOption,'preview')
                        [handles,data] = ACQUIRE_scan(handles,scanOption); %Turn on Preview
                        pause(dwell);
                    elseif strcmpi(scanOption,'adjust')
                        [pos] = getParams(handles,'Stage_XYPos'); %Store current position
                        [handles,data] = ACQUIRE_scan(handles,'preview'); %Turn on Preview
                        [handles,popupFigure] = GUI_makePopup_ArrayAdjust(handles);
                        waitfor(popupFigure);
                        
                        [post_pos] = getParams(handles,'Stage_XYPos'); %Grab new position
                        offsets(i,:) = post_pos - pos; %Calculate offset

                        %Move back to the default position before continuing
                        [handles] = setParams(handles,'Stage_XYPos',pos); 
                    end
                end
          
                
                
            end
            % pos = initial_pos + [cos(angle) i*sin(angle)*array_pitch(2)];
%             if ~strcmpi(scanOption,'adjust')
%                 pos = initial_pos - [0 i*array_pitch(2)] + rowOffset(i,:); %Row movement
%             else
%                 pos = initial_pos - [0 i*array_pitch(2)]; %Row movement
%             end 
        end
        
        %email file to user
        
                
                myaddress = 'bsailsignup@gmail.com';
                mypassword = 'BUPHO716';
                
                setpref('Internet','E_mail',myaddress);
                setpref('Internet','SMTP_Server','smtp.gmail.com');
                setpref('Internet','SMTP_Username',myaddress);
                setpref('Internet','SMTP_Password',mypassword);
                
                props = java.lang.System.getProperties;
                props.setProperty('mail.smtp.auth','true');
                props.setProperty('mail.smtp.socketFactory.class', ...
                    'javax.net.ssl.SSLSocketFactory');
                props.setProperty('mail.smtp.socketFactory.port','465');
                
             %   sendmail('jacob.trueb@gmail.com', 'SP-IRIS Dataset Attached', ['Chip' output.xlsName ' has finished scanning, file attached.'],[output.xlsName '.xls']);
        
        if smart_flag
            [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
        else
            [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
        end
        
        if scan_flag
            [handles] = DATA_CheckFileGroup(handles,getParams(handles,'ChipID'));
        elseif mini_flag
            [handles] = IMAGE_Minimap_save(handles);
        elseif strcmpi(scanOption,'adjust')
            [handles] = setParams(handles,'RowOffset',offsets);
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