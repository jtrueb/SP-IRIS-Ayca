function [handles,output] = ACQUIRE_DefocusScan_v3(handles,enableFocus,numLoop,z_init)
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
        minimum_particles = 10;
        
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
        
        data_stack=struct([]);
%         curDir=userpath;
%         mirPath=strcat(curDir(1:size(curDir,2)-1),'\',getParams(handles,'CurrentMirrorFile'));
%         load(mirPath{1});
%         data_mirror_full=data_mir;
%         data_mirror_cropped=data_mir(curROI(1)+1:(curROI(1)+curROI(3)),curROI(2)+1:(curROI(2)+curROI(4)));
        
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
            [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
            [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            
            disp(['Z_actual: ' num2str(Z_actual)]);

            [particle_count(m),ParticleData] = spd_automated(handles,data,p_type,...
                p_min,p_max); %Detect particles
            [handles] = IMAGE_Plot_display(handles,ParticleData.Size,'hist');
            data_stack(m).image=data;
            data_stack(m).ParticleData=ParticleData;
            
            disp(['Particles found: ' num2str(particle_count(m))]);
            disp(['Average Particle Size: ' num2str(mean(ParticleData.Size))]);
           
        end
        
        [value ind] = max(particle_count);
        
        % Is the max particle Z position inside the window? Were particles
        % detected? If no, repeat with new window. If yes, evaluate with
        % full ROI
        if (numLoop >= maxLoop) || (ind > 1 && ind < sweepSize && value > minimum_particles)
            if numLoop >= maxLoop && (ind == 1 || ind == sweepSize)  && (value < minimum_particles)
                z_pos = z_init + init_offset;
            else
                z_pos = z_temp + sweep(ind);
            end
            
            
            
%             %Move to optimum Z-plane
             [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
%              %Pause for stage equilibration
%             pause(1);
%             %move again
%             %[handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
%             
             offset = z_pos - z_init;
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


            [handles] = IMAGE_Plot_display(handles,data_stack(ind).ParticleData.Size,'hist');
            [handles] = IMAGE_MainImage_display(handles,data_stack(ind).image,'image');
            
            %save out the
            output = OUTPUT_getVariables(handles,root_name,data_stack(ind).image,particle_count(ind),offset);
       
        else
            if value == 0 && (numLoop == 1)
                z_pos = z_init+(sweepSize-1)*sweepStep;
            elseif value == 0 && (numLoop == 2)
                z_pos = z_init-(sweepSize-1)*sweepStep;
                % If value stays 0 after 2 iterations, stop after 3rd
                numLoop = maxLoop-1;
            elseif ind == sweepSize
                z_pos = z_temp+(sweepSize-2)*sweepStep;
            elseif ind == 1
                z_pos = z_temp-(sweepSize-2)*sweepStep;
            end
            
            %Set to original ROI
            [handles] = setParams(handles,'ROI',curROI);
            
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            numLoop = numLoop+1;
            [handles,output] = ACQUIRE_DefocusScan_v3(handles,0,numLoop,z_init);
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
end