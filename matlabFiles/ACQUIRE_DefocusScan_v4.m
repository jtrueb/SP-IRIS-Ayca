function [handles,output] = ACQUIRE_DefocusScan_v4(handles,enableFocus,numLoop,z_init)
%After high-pass focusing, this funciton tracks a set number of particles
% to maximize their contrast. the maximize group contrast image is the in-
% focus image. Only the in-focus image is analyzed and saved.
%
%Version 4 - THIS IS NOT FASTER OR MORE ROBUST THAN V3

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?       
        total = tic;
        sweepStep = 0.1;
        num_track_particles = 100;
        
        [pos] = getParams(handles,'Stage_XYPos'); %[X Y]
        [smart_flag] = getParams(handles,'SmartMove');
        [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
        [zAxes] = {handles.Stage.axis.z};
        stages = getParams(handles,'StagePointers');
        init_offset = getParams(handles,'ParticleOffset');
        
        %% Move stage
        if smart_flag
            output.Z_plane = getParams(handles,'ZPos');
        end
        
        %% Focus
        if enableFocus 
%             tic
            [handles val] = FOCUS_Image(handles,0,1,1,0); %Update Z
%             focus = toc
            z_init = getParams(handles,'ZPos');
            [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},z_init+init_offset);
        end
        
        z_temp = getParams(handles,'ZPos');
        z_pos = z_temp;
        
        %% Acquire an initial image
        %Define desired particles
        p_type = getParams(handles,'ParticleType');
        p_min = getParams(handles,'MinHist');
        p_max = getParams(handles,'MaxHist');
        
        curROI = getParams(handles,'ROI');
        
        %%%%%%%%%%%%%%%%%Crop image for focusing%%%%%%%%%%%%%%%%%%%
        %%%%%How large a slice?        
        %1/16 the FOV
%         newSize = [curROI(3) curROI(4)]./4;%Height/Width        
        %1/4 the FOV
%         newSize = [curROI(3) curROI(4)]./2;%Height/Width    
            
        %%%%%Center on what area?
        %The center 
%         newOffset = [curROI(1) curROI(2)] + 1.5.*newSize;
                
        %The UR
%         newOffset = [0 curROI(4)-newSize(2)];

        %The BL
%         newOffset = [curROI(3)-newSize(1) 0];

        %%%%%Store new ROI
%         newROI = [newOffset newSize];
%         [handles] = setParams(handles,'ROI',newROI);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%Detect Particles in image%%%%%%%%%%%%%%%%
        if FLAG_StopBtn('check')
            output = [];
            %Revert ROI
            [handles] = setParams(handles,'ROI',curROI);
            return;
        end
        focus = tic;
        [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
        [particle_count,ParticleData] = spd_automated(handles,data,p_type,...
            p_min,p_max); %Detect particles
        disp(['Particles found: ' num2str(particle_count)]);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%Determine Particles to track%%%%%%%%%%%%%%%%
        %%%%Grabs the middle X particles to track
%         if size(KPData.VKPs,2) > num_track_particles+2 
%             first_tracked_particle = floor(size(KPData.VKPs,2)/2 - num_track_particles/2);
%             last_tracked_particle = ceil(size(KPData.VKPs,2)/2 + num_track_particles/2);
%         else
%             first_tracked_particle = 1;
%             last_tracked_particle = size(KPData.VKPs,2);
%         end
%         tracked_centers(:,:) = [round(KPData.VKPs(1,first_tracked_particle:last_tracked_particle));...
%             round(KPData.VKPs(2,first_tracked_particle:last_tracked_particle))];

        %%%%Tracks the x maximize contrast particles
        if size(KPData.VKPs,2) > num_track_particles
            [a,ix] = sort(KPData.Peaks(:),'descend');
            ix = ix(1:num_track_particles);
            [real_loc] = ind2sub(KPData.Peaks,ix);
        else
            [real_loc] = 1:length(KPData.Peaks);
        end
            
        tracked_centers(:,:) = [round(KPData.VKPs(1,real_loc(:)));...
            round(KPData.VKPs(2,real_loc(:)))];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%Step in Z by sweepStep until contrast peaks%%%%%%%%
        flag = 0;
        indPeaks = sub2ind(size(data),tracked_centers(2,:),tracked_centers(1,:));
        curPeakVals = data(indPeaks);
        loops = 0;
        flipped = 0;
        while(flag == 0)
            loops = loops+1;
            z_pos = z_pos + sweepStep;
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            newPeakVals = data(indPeaks);
            dif = newPeakVals - curPeakVals;
            mean(dif)
            if mean(dif) <= 0
                if loops == 1
                    flipped = 1;
                    %Move back & reverse direction
                    z_pos = z_pos - sweepStep;
                    [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
                    
                    sweepStep = -sweepStep;
                else
                    flag = 1;
                    
                    %Move back to optimum Z-plane
                    z_pos = z_pos - sweepStep;
                    [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
                end
            else
                curPeakVals = newPeakVals;
            end
        end
        loops
        flipped
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        foc = toc(focus)
        %%%%%%%Step in Z by sweepStep until contrast peaks%%%%%%%%
        offset = z_pos - z_init;
        disp(['Focus offset: ' num2str(offset)]);
            
        %Set to original ROI
        [handles] = setParams(handles,'ROI',curROI);
            
        %Acquire image
        [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            
        %Define particles to detect
        particle_type = getParams(handles,'ParticleType');
        [minSize] = getParams(handles,'MinHist');
        [maxSize] = getParams(handles,'MaxHist');
            
        [particle_count,ParticleData] = spd_automated(handles,data,particle_type,...
            minSize,maxSize); %Detect particles
        disp(['Particles found: ' num2str(particle_count)]);
            
        output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
        toc(total)
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