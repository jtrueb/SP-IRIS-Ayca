function [handles,output] = ACQUIRE_DefocusScan_v5_zStack(handles,enableFocus,numLoop,z_init)
%After high-pass focusing, this function steps through multiple z-planes
% to maximize the number of particles found in the user-defined window. 
% The window with the maximum number of particles is in-focus. Only the 
% in-focus image is analyzed and saved.
%
%Acquires all images within a range. Determines offset with maximum number
% of particles. If the maximum is on an extreme, the window shifts and repeats

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?       
        sweepMin = -0.6;
        sweepMax = 0.6;
        sweepStep = 0.1;
        sweep = sweepMin:sweepStep:sweepMax;
        sweepSize = size(sweep,2);
        maxLoop = 4;
        minimum_particles = 1; %changed from 10
        output = [];
        
        zStack_data=struct([]); %Top level data structure for entire zStack
        
        [pos] = getParams(handles,'Stage_XYPos'); %[X Y]
        [smart_flag] = getParams(handles,'SmartMove');
        [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
        [zAxes] = {handles.Stage.axis.z};
        [particle_count] = -1;
        stages = getParams(handles,'StagePointers');
        init_offset = getParams(handles,'ParticleOffset');
        
        %% Move stage
        if smart_flag
            output.Z_plane = getParams(handles,'ZPos');
        end
        
        %% Focus
        enableFocus=0;
        if enableFocus 
%             tic
            [handles val] = FOCUS_Image(handles,0,1,1,0); %Update Z
%             focus = toc
            z_init = getParams(handles,'ZPos');
            [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},z_init+init_offset);
        end
        
        z_temp = getParams(handles,'ZPos');
        z_pos = z_temp + sweepMin - sweepStep;
        
        %% Acquire defocus stack of data
        %Define desired particles
        p_type = getParams(handles,'ParticleType');
        p_min = getParams(handles,'MinHist');
        p_max = getParams(handles,'MaxHist');
        
        curROI = getParams(handles,'ROI');
        
        %%%%%%%%%%%%%%%%%Crop image for focusing%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Sweep the Z focus -/+300nm and determine optimum focus
        [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
        xlsName=[root_name handles.const.DataSetString];
        matName=[root_name handles.const.DataSetString handles.const.MatFileExtension];
        
        for m = 1:sweepSize
            if FLAG_StopBtn('check')
                output = [];
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
                return;
            end
            z_pos = z_pos+sweepStep;
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            %pause for equilibration
            pause(1);
            [handles,image] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
            disp(['Z_actual: ' num2str(Z_actual)]);

            [particle_count(m),ParticleData] = spd_automated(handles,image,p_type,...
                p_min,p_max); %Detect particles
            
            zStack_data(m).ParticleData=ParticleData;
            zStack_data(m).particle_count=particle_count(m);
            zStack_data(m).Z_actual=Z_actual;
            zStack_data(m).Z_nominal=z_pos;
            zStack_data(m).x_pos=x_cur;
            zStack_data(m).y_pos=y_cur;
            
            
            data_date = datestr(now);
            dateString = [data_date(13:14) data_date(16:17) data_date(19:20)];
            
            zStack_data(m).dateString=dateString;
            [handles] = OUTPUT_excelFile_zStack(handles,xlsName,zStack_data(m));
            [handles] = IMAGE_MainImage_display(handles,image,'image');
            
            
            [handles] = IMAGE_Plot_display(handles,ParticleData.Contrasts,'hist');
            disp(['Particles found: ' num2str(particle_count(m))]);
            
        end
          
             %Save
            [handles] = OUTPUT_matFile_zStack(handles,matName,zStack_data);
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_temp);
            
            
           
      
        
        %[value ind] = max(particle_count);
        
        
      %  Loop scanning disabled for zStack analysis
        
        % Is the max particle Z position inside the window? Were particles
        % detected? If no, repeat with new window. If yes, evaluate with
        % full ROI
%         if (numLoop >= maxLoop) || (ind > 1 && ind < sweepSize && value > minimum_particles)
%             if numLoop >= maxLoop && (ind == 1 || ind == sweepSize)  && (value < minimum_particles)
%                 z_pos = z_init + init_offset;
%             else
%                 z_pos = z_temp + sweep(ind);
%             end
%             
%             %Move to optimum Z-plane
%             [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
%              %Pause for stage equilibration
%             pause(1);
%             %move again
%             %[handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
%             
%             offset = z_pos - z_init;
%             disp(['Focus offset: ' num2str(offset)]);
%             
%             %Set to original ROI
%             [handles] = setParams(handles,'ROI',curROI);
%             
%            
%             
%             %Acquire image
%             [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
%             [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
%             disp(['Z_actual_data: ' num2str(Z_actual)]);
% 
%             
%             %Define particles to detect
%             particle_type = getParams(handles,'ParticleType');
%             [minSize] = getParams(handles,'MinHist');
%             [maxSize] = getParams(handles,'MaxHist');
%             
%             [particle_count,ParticleData] = spd_automated(handles,data,particle_type,...
%                 minSize,maxSize); %Detect particles
%             disp(['Particles found: ' num2str(particle_count)]);
%             [handles] = IMAGE_Plot_display(handles,ParticleData.Size_forGUIhist,'hist');
%             
%             output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
%         else
%             if value == 0 && (numLoop == 1)
%                 z_pos = z_init+(sweepSize-1)*sweepStep;
%             elseif value == 0 && (numLoop == 2)
%                 z_pos = z_init-(sweepSize-1)*sweepStep;
%                 % If value stays 0 after 2 iterations, stop after 3rd
%                 numLoop = maxLoop-1;
%             elseif ind == sweepSize
%                 z_pos = z_temp+(sweepSize-2)*sweepStep;
%             elseif ind == 1
%                 z_pos = z_temp-(sweepSize-2)*sweepStep;
%             end
%             
%             %Set to original ROI
%             [handles] = setParams(handles,'ROI',curROI);
%             
%             [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
%             numLoop = numLoop+1;
%             [handles,output] = ACQUIRE_DefocusScan_v5_zStack(handles,0,numLoop,z_init);
%         end

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
end