function [handles,output] = ACQUIRE_DefocusScan_RP_planecalc(handles,enableFocus,numLoop,z_init,fine_flag)
%After high-pass focusing, this function steps through multiple z-planes
% to maximize the number of particles found in the user-defined window. 
% The window with the maximum number of particles is in-focus. Only the 
% in-focus image is analyzed and saved.
%
%Acquires all images within a range. Determines offset with maximum number
% of particles. If the maximum is on an extreme, the window shifts and repeats
%
%Version 3_RP - Reference Particle. The user-defined window to
% find the in-focus image is the RP size window. After locating the
% in-focus image, the detected particle size window is determined and
% saved.

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?
        
        if fine_flag
            sweepMin = -1;
            sweepMax = 1;
            sweepStep = 0.1;
            
        else
            sweepMin = -5;
            sweepMax = 5;
            sweepStep = 0.3;
        end
        
        if z_init == 0
            z_init = getParams(handles,'ZPos');
        end
        
        
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
        if enableFocus
            [handles val] = FOCUS_Image(handles,0,1,0,0); %Update Z, 1mm (medium) contrast scan only
            z_init = getParams(handles,'ZPos');
            [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},z_init+init_offset);
        end
        
        z_temp = getParams(handles,'ZPos');
        z_pos = z_temp + sweepMin - sweepStep;
        
        %% Acquire defocus stack of data
        %Define desired particles
%         p_type = 'AuNP';
%         p_min = 60;
%         p_max = 80;
        [p_type] = getParams(handles,'RefParticleType');
        [p_min] = getParams(handles,'RefMinHist');
        [p_max] = getParams(handles,'RefMaxHist');
        
        curROI = getParams(handles,'ROI');
        
        %%%%%%%%%%%%%%%%%Crop image for focusing%%%%%%%%%%%%%%%%%%%
        %%%%%How large a slice?        
        %1/16 the FOV
        newSize = [curROI(3) curROI(4)]./4;%Height/Width        
        %1/4 the FOV
%         newSize = [curROI(3) curROI(4)]./2;%Height/Width    
            
        %%%%%Center on what area?
        %The center 
        newOffset = [curROI(1) curROI(2)] + 1.5.*newSize;
                
        %The UR
%         newOffset = [0 curROI(4)-newSize(2)];

        %The BL
%         newOffset = [curROI(3)-newSize(1) 0];

        %%%%%Store new ROI
        newROI = [newOffset newSize];
        [handles] = setParams(handles,'ROI',newROI);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Sweep the Z focus -/+scan range and determine optimum focus
        for m = 1:sweepSize
            if FLAG_StopBtn('check')
                output = [];
                FLAG_StopBtn('clear');
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
                return;
            end
            %            istart = tic;
            z_pos = z_pos+sweepStep;
            %             tic
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            %             toc
            %             tic
            [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            %             toc
            [particle_count(m),ParticleData] = spd_automated(handles,data,p_type,...
                p_min,p_max); %Detect particles
            disp(['Particles found: ' num2str(particle_count(m))]);
            %            toc(istart);
        end
        
        [value ind] = max(particle_count);
        
        % Is the max particle Z position inside the window? Were particles
        % detected? If no, repeat with new window. If yes, evaluate with
        % full ROI
        if (numLoop >= maxLoop) || ((ind > 1) && (ind < sweepSize) && (value > minimum_particles))
            if numLoop >= maxLoop && (ind == 1 || ind == sweepSize)  && (value < minimum_particles)
                z_pos = z_init + init_offset;
            else
                z_pos = z_temp + sweep(ind);
            end
            
            %Move to optimum Z-plane
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            [offset] = z_pos - z_init;
            disp(['Focus offset: ' num2str(offset)]);
            
            
            
            %Set to original ROI
            [handles] = setParams(handles,'ROI',curROI);
            
            if fine_flag
                
                output=getParams(handles,'ZPos');
                
                
%                 
% 
%                 
%                 %Acquire image
%                 [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
%                 
%                 %Define particles to detect
%                 [particle_type] = getParams(handles,'ParticleType');
%                 [minSize] = getParams(handles,'MinHist');
%                 [maxSize] = getParams(handles,'MaxHist');
%                 
%                 [particle_count,ParticleData] = spd_automated(handles,data,particle_type,minSize,maxSize); %Detect particles
%                 disp(['Particles found: ' num2str(particle_count)]);
%                 
%                 output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
                
                
            
            else
                [handles,output] = ACQUIRE_DefocusScan_RP_planecalc(handles,0,1,z_pos,1);
            end
                
            
            
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
            [handles,output] = ACQUIRE_DefocusScan_RP_planecalc(handles,0,numLoop,z_init,fine_flag);
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