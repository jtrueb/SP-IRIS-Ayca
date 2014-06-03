function [handles,output] = ACQUIRE_DefocusScan_v6(handles,enableFocus,numLoop,z_init)
%This function saves out the images of an entire Z stack for downstream reanalysis with different intensity and gaussian threshholds.
%outputs IMAGES ONLY, does not run spd_automated
%needs a custom flag in ACQUIRE_scan to avoid running SPD_automated?  or
%could just ignore the outputs

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?       
        sweepMin = -1;
        sweepMax = 1;
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
         data_temp = datestr(now);
         dateString = [data_temp(13:14) data_temp(16:17) data_temp(19:20)];
        
%         matName=[root_name handles.const.DataSetString handles.const.MatFileExtension];
        matName=[getParams(handles,'Directory') 'zscan_' getParams(handles,'ChipID') '_' dateString handles.const.MatFileExtension];
        output.matname=matName;
        
       % data_stack=struct([]); %master data struct array for output
       
        
        %% Move stage
        if smart_flag
            output.Z_plane = getParams(handles,'ZPos');
        end
        
        %% Focus
%         enableFocus=0;
%         if enableFocus 
% %             tic
%             [handles val] = FOCUS_Image(handles,0,1,1,0); %Update Z
% %             focus = toc
%             z_init = getParams(handles,'ZPos');
%             [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},z_init+init_offset);
%         end
        
        z_temp = getParams(handles,'ZPos');
        z_pos = z_temp + sweepMin - sweepStep;
        
        data_stack.z_center=z_temp;
        data_stack.z_start=z_pos+sweepStep;
        data_stack.z_end=z_pos+sweepSize+sweepStep;
        data_stack.sweepStep=sweepStep;
        [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
        data_stack.x_pos=x_cur;
        data_stack.y_pos=y_cur;
        
        %save default spd_automated input values for reference
        data_stack.defaultDetectionParams.color=getParams(handles,'LED');
        data_stack.defaultDetectionParams.IntensityTh = getParams(handles,'IntensityTh');
        data_stack.defaultDetectionParams.EdgeTh = getParams(handles,'EdgeTh');
        data_stack.defaultDetectionParams.TemplateSize= getParams(handles,'TemplateSize');
        data_stack.defaultDetectionParams.SD = getParams(handles,'SD');
        data_stack.defaultDetectionParams.GaussianTh= getParams(handles,'GaussianTh');
        data_stack.defaultDetectionParams.InnerRadius = getParams(handles,'InnerRadius');
        data_stack.defaultDetectionParams.OuterRadius = getParams(handles,'OuterRadius');
        data_stack.defaultDetectionParams.particle_type = getParams(handles,'ParticleType');
        
        [CurveData Diameters]= getCurveData(data_stack.defaultDetectionParams.color,data_stack.defaultDetectionParams.particle_type);
        data_stack.defaultDetectionParams.CurveData=CurveData;
        data_stack.defaultDetectionParams.Diameters=Diameters;
        clear CurveData Diameters;


        
        
        
        %% Acquire defocus stack of data
        %Define desired particles
        p_type = getParams(handles,'ParticleType');
        p_min = getParams(handles,'MinHist');
        p_max = getParams(handles,'MaxHist');
        
        curROI = getParams(handles,'ROI');
        
        %%%%%%%%%%%%%%%%%Crop image for focusing%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Sweep the Z focus -/+300nm and determine optimum focus
        
        
        
        
%         curDir=userpath;
%         mirPath=strcat(curDir(1:size(curDir,2)-1),'\',getParams(handles,'CurrentMirrorFile'));
%         load(mirPath{1});
%         data_mirror_full=data_mir;
%         data_mirror_cropped=data_mir(curROI(1)+1:(curROI(1)+curROI(3)),curROI(2)+1:(curROI(2)+curROI(4)));
        
        for m = 1:sweepSize
            tic;
            if FLAG_StopBtn('check')
                output = [];
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
                return;
            end
            z_pos = z_pos+sweepStep;
            [handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
            %pause for equilibration
%             pause(.1);
            [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
            [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            
            disp(['Z_actual: ' num2str(Z_actual)]);

%           [particle_count(m),ParticleData] = spd_automated(handles,data,p_type,...
%                 p_min,p_max); %Detect particles
%           [handles] = IMAGE_Plot_display(handles,ParticleData.Size,'hist');
            data_stack.slice(m).image=data;
%           data_stack.slice(m).ParticleData=ParticleData;
            data_stack.slice(m).z_pos=z_pos;
            data_stack.slice(m).Z_actual=Z_actual;
%           data_stack.slice(m).IntensityTh=getParams(handles,'IntensityTh');
%           data_stack.slice(m).GaussianTh=getParams(handles,'GaussianTh');
            
            
            data_date = datestr(now);
            dateString = [data_date(13:14) data_date(16:17) data_date(19:20)];
            
            data_stack.slice(m).dateString=dateString;
            %[handles] = OUTPUT_excelFile_zStack(handles,xlsName,zStack_data(m));
           % [handles] = IMAGE_MainImage_display(handles,data,'image');
            
            data_stack.slice(m).timeElapsed=toc;
            
            
%           [handles] = IMAGE_Plot_display(handles,ParticleData.Contrasts,'hist');
%           disp(['Particles found: ' num2str(particle_count(m))]);
            
            
%           disp(['Particles found: ' num2str(particle_count(m))]);
           
        end
        
%        [value ind] = max(particle_count);
%        data_stack.maxCount=value;
%        data_stack.maxIndex=ind;
%        data_stack.particle_stack=particle_count;
        
        output.zstack = data_stack;
        [handles] = OUTPUT_matFile_zStack(handles,matName,data_stack);
        [handles] = STAGE_MoveAbsolute(handles,zAxes,z_temp);
        
        
        
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
%             
%             
% %             %Move to optimum Z-plane
%              [handles] = STAGE_MoveAbsolute(handles,zAxes,z_temp);
% %              %Pause for stage equilibration
% %             pause(1);
% %             %move again
% %             %[handles] = STAGE_MoveAbsolute(handles,zAxes,z_pos);
% %             
%              offset = z_pos - z_init;
% %             disp(['Focus offset: ' num2str(offset)]);
% %             
% %             %Set to original ROI
% %             [handles] = setParams(handles,'ROI',curROI);
% %             
% %            
% %             
% %             %Acquire image
% %             [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
% %             [x_cur y_cur Z_actual] = STAGE_getPositions(handles.Stage);
% %             disp(['Z_actual_data: ' num2str(Z_actual)]);
% % 
% %             
% %             %Define particles to detect
% %             particle_type = getParams(handles,'ParticleType');
% %             [minSize] = getParams(handles,'MinHist');
% %             [maxSize] = getParams(handles,'MaxHist');
% %             
% %             [particle_count,ParticleData] = spd_automated(handles,data,particle_type,...
% %                 minSize,maxSize); %Detect particles
% %             disp(['Particles found: ' num2str(particle_count)]);
% 
% 
%             [handles] = IMAGE_Plot_display(handles,data_stack(ind).ParticleData.Size,'hist');
%             [handles] = IMAGE_MainImage_display(handles,data_stack(ind).image,'image');
%             
%             %save out the
%             output = OUTPUT_getVariables(handles,root_name,data_stack(ind).image,particle_count(ind),offset);
%        
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
%             [handles,output] = ACQUIRE_DefocusScan_v3(handles,0,numLoop,z_init);
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