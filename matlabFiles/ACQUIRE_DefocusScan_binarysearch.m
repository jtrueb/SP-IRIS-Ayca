function [handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,enableFocus,numLoop,z_init,options,scan_width)
%Options can = 'save' or 'focus'

img_time = [];
if nargin<6
    scan_width=17; %must be a factor of 4n+1, where n is even
end

if nargin<5;
    options = 'save';
end

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?
%         sweepMin = -.4;
%         sweepMax = .4;
%         sweepStep = 0.1;
%         sweep = sweepMin:sweepStep:sweepMax;
%         sweepSize = size(sweep,2);
[handles] = LEDS_setState(handles,'vacuumon');
tt1 = tic();
        maxLoop = 4;
        minimum_particles = 10;
        
        [pos] = getParams(handles,'Stage_XYPos'); %[X Y]
        [smart_flag] = getParams(handles,'SmartMove');
        [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
        [zAxes] = {handles.Stage.axis.z};
        [particle_count] = -1;
        stages = getParams(handles,'StagePointers');
        init_offset = getParams(handles,'ParticleOffset');
        
        z_temp = getParams(handles,'ZPos');
        
        if z_init <=0
            z_init = z_temp;
        end
        
        %% Move stage
        if smart_flag
            output.Z_plane = getParams(handles,'ZPos');
        end
        
        %% Focus
        if enableFocus
            [handles val] = FOCUS_Image(handles,0,1,1,0); %Update Z
            z_init = getParams(handles,'ZPos');
            [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},z_init+init_offset);
        end
        
        
%         z_pos = z_temp + sweepMin - sweepStep;
        
        %% Acquire defocus stack of data
        %Define desired particles
%         p_type = 'AuNP';
%         p_min = 60;
%         p_max = 80;
        [p_type] = getParams(handles,'RefParticleType');
        [p_min] = getParams(handles,'RefMinHist');
        [p_max] = getParams(handles,'RefMaxHist');
        
        % struct of RefParticleInfo
        pInfo = struct();
        pInfo.p_type = p_type;
        pInfo.p_min = p_min;
        pInfo.p_max = p_max;
        
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
        %new code starts
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        
        tree_lowbound = z_temp-(scan_width-1)*.1/2;
        
        
        tree_counter(1:scan_width,1:3)=-1;                                          %Initialize all columns to -1 (column 3 for counts)
        tree_counter(1:scan_width,1)=1:scan_width;                                          %Column 1 set to z index
        tree_counter(1:scan_width,2)=tree_lowbound+(tree_counter(1:scan_width,1)-1)*.1;     %Column 2 set to z position (nominal)
   tt2 = toc(tt1);
   tt3 = tic();
        istart=tic;
        for m=1:4:scan_width
            if FLAG_StopBtn('check')
%                 FLAG_StopBtn('clear');
                [handles] = CONTROL_WelcomeBtns(handles, 5);
                
                msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
                    handles.txtLog,feedbackLvl,errorFlag);
                
                
                output = [];
                
                %Revert ROI
                [handles] = STAGE_MoveAbsolute(handles,zAxes,z_temp);
                [handles] = setParams(handles,'ROI',curROI);
                
                return;
            end
            
            [handles, tree_counter(m,3)] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,...
                tree_counter(m,2),pInfo);
            
             set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
             cla(handles.axesPlot);
             plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        end
        
        [max_coarse,ind_coarse] = max(tree_counter(:,3));
        
tt4 = toc(tt3);
        tt5 = tic();
        if (ind_coarse==1) || (ind_coarse==scan_width)
             [handles] = setParams(handles,'ROI',curROI);
           %r-center scan range on max wing and scan again   
           [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_coarse,2));
           if numLoop < maxLoop
               [handles,output] = ACQUIRE_DefocusScan_binarysearch(handles,0,numLoop+1,z_init,options,scan_width);
               return;
           else
               data=[];
               particle_count=-1;
               offset=tree_counter(ind_coarse,2)-z_init;
            output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
            return;
           end
        end
        
       
        

         
        
        % acquire 200nm resolution data point
        [handles, tree_counter(ind_coarse-2,3)] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,...
                tree_counter(ind_coarse-2,2),pInfo);
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        
        %both directions for med
        [handles, tree_counter(ind_coarse+2,3)] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,...
                tree_counter(ind_coarse+2,2),pInfo);
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
            
         tt6 = toc(tt5);
         tt7 = tic();
        %% FIND PEAK
        [max_med,ind_med] = max(tree_counter(:,3));
        
        
        % acquire 100nm resolution data points
        [handles, tree_counter(ind_med-1,3)] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,...
                tree_counter(ind_med-1,2),pInfo);
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
             
        %do both direction for fine
        [handles, tree_counter(ind_med+1,3)] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,...
                tree_counter(ind_med+1,2),pInfo);
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
                 
        %%identify focal plane
        count_condensed=tree_counter(tree_counter(:,3)>0,:);
        count_smooth=count_condensed;
        for i=1:size(count_condensed,1)
            if i==1
                count_smooth(i,3)=mean(count_condensed(i:i+1,3));
            elseif i==size(count_condensed,1)
                count_smooth(i,3)=mean(count_condensed(i-1:i,3));
            else
                count_smooth(i,3)=mean(count_condensed(i-1:i+1,3));
            end
        end
        
        
        tt8 = toc(tt7);
        tt9 = tic();
        
        [max_focus,smooth_focus]=max(count_smooth(:,3));
        ind_focus=count_smooth(smooth_focus,1);
        
        set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
        cla(handles.axesPlot);
        plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        hold on;
        plot(count_smooth(:,2),count_smooth(:,3),'-r');
        plot(count_condensed(smooth_focus,2),count_condensed(smooth_focus,3),'dg');
        hold off;
        
        
        [offset] = tree_counter(ind_focus,2) - z_init;
        disp(['Focus offset: ' num2str(offset)]);
        [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_focus,2));
        [handles] = setParams(handles,'ROI',curROI);
        tt10 = toc(tt9);
        tt11 = tic();
        if strcmpi(options,'save')
            [handles,data] = ACQUIRE_scan(handles,'save'); %Acquire a scan
            [particle_type] = getParams(handles,'ParticleType');
            [minSize] = getParams(handles,'MinHist');
            [maxSize] = getParams(handles,'MaxHist');
            
            particle_count = max_focus;
            
%             [particle_count,ParticleData] = spd_automated(handles,data,particle_type,minSize,maxSize); %Detect particles
%             disp(['Full FOV - ' particle_type ' Particles found: ' num2str(particle_count)]);
            
            output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
        elseif strcmpi(options,'focus')
            output.ROI_count = tree_counter(ind_focus,3);
            output.focus_plane = tree_counter(ind_focus,2);
            output.numLoop = numLoop;
        end
        tt12 = toc(tt11);
        [handles] = LEDS_setState(handles,'vacuumoff');
        %[tt2 tt4 tt6 tt8 tt10 tt12]
        
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