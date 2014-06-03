function [handles,output] = ACQUIRE_autofocus_dynamic(handles,enableFocus,numLoop,z_init,options,scan_width,ROI_flag,tree_counter,direction)
%enableFocus = 1 % turns on high pass filter fous
%numloop=double   % tracks recursive iteration
%z_init = starting position
%options = 'save' or 'focus,' 'save' takes a full ROI image upon completion
%scan_width = number of steps in scan. must be a factor of 4n+1, where n is
        %good defaults are 17,25,33
%ROI_flag = 1 reduces focus FOV to 1/4 of full for increased speed

peak_gap_floor=3;
peak_gap_ceil=1;
 maxLoop = 6;
secondary_flag=0;

if nargin<9
    direction=1;
end
if nargin <8
    tree_counter=[];
    tree_counter_flag=0;
else
    tree_counter_flag=1;
end

if nargin<7
    ROI_flag=0;
end

if nargin<6
    scan_width=45; %must be a factor of 4n+1, where n is even
end



%reset scan_wýdth to insure integer indices
half_scan=fix(scan_width/2);
scan_width=2*half_scan+1;
step_size=.1;


if nargin<5;
    options = 'save';
end

if getParams(handles,'ChipLoadStatus') %Is a sample loaded?
    if getParams(handles,'StageInitStatus') %Are the stages initialized?

% [handles] = LEDS_setState(handles,'vacuumon');
tt1 = tic();
       

        [smart_flag] = getParams(handles,'SmartMove');
        [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
        [zAxes] = {handles.Stage.axis.z};

        stages = getParams(handles,'StagePointers');
        init_offset = getParams(handles,'ParticleOffset'); %should be 0 for virus
        
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
        
        if ROI_flag
            [handles] = setParams(handles,'ROI',newROI);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %new code starts
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        if tree_counter_flag %if recursively called, append old tree_counter to new one,
            tree_counter_prev=tree_counter;
            tree_counter=[];
            if direction==1
%                 tree_lowbound=tree_counter_prev(end,2)+step_size;
                start_ind=tree_counter_prev(end,1)+4;
                
                
                tree_counter(1:scan_width-1,1:3)=-1;                                          %Initialize all columns to -1 (column 3 for image power)
                tree_counter(1:scan_width-1,1)=(1:(scan_width-1))+tree_counter_prev(end,1);                                          %Column 1 set to z index
                tree_counter(1:scan_width-1,2)=tree_counter_prev(end,2)+(1:scan_width-1)*step_size;     %Column 2 set to z position (nominal)
                tree_counter=[tree_counter_prev;tree_counter];
%                 scan_width=size(tree_counter,1);
                
                end_ind=tree_counter(end,1);
            elseif direction==-1;
                start_ind=1;
                
                tree_counter(1:scan_width-1,1:3)=-1;                                          %Initialize all columns to -1 (column 3 for image power)
                
                tree_counter(1:scan_width-1,2)=((1:scan_width-1)*step_size)+tree_counter_prev(1,2)-scan_width*step_size;     %Column 2 set to z position (nominal)
                end_ind=scan_width-4;
            
                tree_counter=[tree_counter;tree_counter_prev];
                 tree_counter(1:end,1)=1:size(tree_counter,1);
%                 scan_width=size(tree_counter,1);
                
            end
            
        else
            start_ind=1;
            end_ind=scan_width;
            tree_lowbound = z_temp-(half_scan*step_size);
            
            
            tree_counter(1:scan_width,1:3)=-1;                                          %Initialize all columns to -1 (column 3 for image power)
            tree_counter(1:scan_width,1)=1:scan_width;                                          %Column 1 set to z index
            tree_counter(1:scan_width,2)=tree_lowbound+(tree_counter(1:scan_width,1)-1)*.1;     %Column 2 set to z position (nominal)
        end
        
        tt2 = toc(tt1);
        tt3 = tic();
        istart=tic;
        for m=start_ind:4:end_ind
            if FLAG_StopBtn('check')
%                 FLAG_StopBtn('clear');
                [handles] = CONTROL_WelcomeBtns(handles, 5);
                
                msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
                    handles.txtLog,feedbackLvl,errorFlag);
                
                
                output = [];
                
                %Revert ROI
                [handles] = STAGE_MoveAbsolute(handles,zAxes,z_temp);
                if ROI_flag
                    [handles] = setParams(handles,'ROI',curROI);
                end
                return;
            end
            
            [handles, tree_counter(m,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(m,2));
            
             set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
             cla(handles.axesPlot);
             plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        end
        
        [max_coarse,ind_coarse] = max(tree_counter(:,3));
        
        
        
        
        
        
        
tt4 = toc(tt3);
        tt5 = tic();
        if (ind_coarse==tree_counter(1,1))  || ((tree_counter(ind_coarse,2)-tree_counter(1,2))<peak_gap_floor)
            
            %extend tree counter by scan_length for lower z-positions
            
            
            
           %r-center scan range on max wing and scan again   
%            [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(5,2)-half_scan*step_size);
           [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_coarse,2));
           if numLoop < maxLoop
               if ROI_flag
                   [handles] = setParams(handles,'ROI',curROI);
               end
               [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,numLoop+1,z_init,options,scan_width,ROI_flag,tree_counter,-1);
               return;
           else
               data=[];
               particle_count=-1;
               offset=tree_counter(ind_coarse,2)-z_init;
            output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
            return;
           end
        elseif (ind_coarse==tree_counter(end,1)) || (abs(tree_counter(end,2)-tree_counter(ind_coarse,2))<peak_gap_ceil)
            %             [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_coarse,2));
%             [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(end-4,2)+half_scan*step_size);
            if numLoop < maxLoop
                if ROI_flag
                    [handles] = setParams(handles,'ROI',curROI);
                end
                [handles,output] = ACQUIRE_autofocus_dynamic(handles,0,numLoop+1,z_init,options,scan_width,ROI_flag,tree_counter,1);
                return;
            else
                data=[];
                particle_count=-1;
                offset=tree_counter(ind_coarse,2)-z_init;
                output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
                disp(['Maximum Number of loops reached, focus not found.']);
                return;
            end
        end;
        
        %%look for secondary local maxima
        
        %generate mask for filled in points
        
        measured_mask=tree_counter(:,3)>0;
        full_inds=tree_counter(measured_mask,1);
        [xmax,imax,xmin,imin] = extrema(tree_counter(measured_mask,3));
        if length(imax)>=2 %multiple peaks detected
            if imax(1)<imax(2) %particle peak is detected
                
               
                
            else  %secondary peak is overpowering particle peak, fill in gaps on particle peak
                ind_span=full_inds(imax(1))-full_inds(imax(2));
                half_span=ceil(ind_span/2);
                z_span=tree_counter(full_inds(imax(1)),2)-tree_counter(full_inds(imax(2)),2);
                ind_second=full_inds(imax(2));
                if z_span >=peak_gap_floor  %if secondary peak is too far away, ignore it
                    ind_coarse=imax(1);
                else
                    secondary_flag=1;
                    %% acquire 200nm resolution data point
                    [handles, tree_counter(ind_second-2,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                        tree_counter(ind_second-2,2));
                    
                    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
                    cla(handles.axesPlot);
                    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
                    
                    %both directions for med
                    [handles, tree_counter(ind_second+2,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                        tree_counter(ind_second+2,2));
                    
                    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
                    cla(handles.axesPlot);
                    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
                    
                    tt6 = toc(tt5);
                    tt7 = tic();
                    % FIND PEAK
                     measured_mask=tree_counter(:,3)>0;
                    full_inds=tree_counter(measured_mask,1);
                    [xmax,imax,xmin,imin] = extrema(tree_counter(measured_mask,3));
                    if length(imax)>=2 %if half_span is too big, could pick up on beginning of secondary peak.  fill inlater
                    
                    end
                   
                    
                    if full_inds(imax(1))==ind_coarse
                        ind_second_med=full_inds(imax(2));
                    else
                        ind_second_med=full_inds(imax(1));
                    end
                    
                    
                    % acquire 100nm resolution data points
                    [handles, tree_counter(ind_second_med-1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                        tree_counter(ind_second_med-1,2));
                    
                    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
                    cla(handles.axesPlot);
                    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
                    
                    %do both direction for fine
                    [handles, tree_counter(ind_second_med+1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                        tree_counter(ind_second_med+1,2));
                    
                    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
                    cla(handles.axesPlot);
                    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
                    
                    %Check to ensure fine max is bounded by 100nm increment values.
                    %if the either neighboring index to the fine max is unfilled, take
                    %the image before smoothing
                    % FIND PEAK
                    measured_mask=tree_counter(:,3)>0;
                    full_inds=tree_counter(measured_mask,1);
                    
                    [xmax,imax,xmin,imin] = extrema(tree_counter(measured_mask,3));
                    
                     if full_inds(imax(1))==ind_coarse
                        ind_second_fine=full_inds(imax(2));
                    else
                        ind_second_fine=full_inds(imax(1));
                    end
                    
                    if tree_counter(ind_second_fine-1,3)<0
                        [handles, tree_counter(ind_second_fine-1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                            tree_counter(ind_second_fine-1,2));
                    end
                    
                    if tree_counter(ind_second_fine+1,3)<0
                        [handles, tree_counter(ind_second_fine+1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                            tree_counter(ind_second_fine+1,2));
                    end
                    
                    
                    
                    
                end
                
            end
        else %only 1 peak detected
            
        end
        
if ~secondary_flag
         
        
        % acquire 200nm resolution data point
        [handles, tree_counter(ind_coarse-2,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_coarse-2,2));
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        
        %both directions for med
        [handles, tree_counter(ind_coarse+2,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_coarse+2,2));
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
            
         tt6 = toc(tt5);
         tt7 = tic();
        %% FIND PEAK
        [max_med,ind_med] = max(tree_counter(:,3));
        
        
        % acquire 100nm resolution data points
        [handles, tree_counter(ind_med-1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_med-1,2));
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
             
        %do both direction for fine
        [handles, tree_counter(ind_med+1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_med+1,2));
            
         set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
         cla(handles.axesPlot);
         plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
         
         %Check to ensure fine max is bounded by 100nm increment values.
         %if the either neighboring index to the fine max is unfilled, take
         %the image before smoothing
         [max_fine,ind_fine] = max(tree_counter(:,3));
         
         if tree_counter(ind_fine-1,3)<0
             [handles, tree_counter(ind_fine-1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_fine-1,2));
         end
         
         if tree_counter(ind_fine+1,3)<0
             [handles, tree_counter(ind_fine+1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
                tree_counter(ind_fine+1,2));
         end
         
end
        
                
         
                 
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
        
        %%hack for secondary peak
        if secondary_flag
            ind_focus=ind_second_fine;
            disp('Secondary Peak Detected!');
        else
            disp('Primary Peak Detected');
        end
    
        disp(['Max Power: ' num2str(max_focus)]);
        
        set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
        cla(handles.axesPlot);
        plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
        hold on;
        plot(count_smooth(:,2),count_smooth(:,3),'-r');
        
        if secondary_flag
            plot(tree_counter(ind_focus,2),tree_counter(ind_focus,3),'dg');
        else
            plot(count_condensed(smooth_focus,2),count_condensed(smooth_focus,3),'dg');
        end
        
        hold off;
        
        
        [offset] = tree_counter(ind_focus,2) - z_init;
        disp(['Focus offset: ' num2str(offset)]);
        [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_focus,2));
        
        if ROI_flag
            [handles] = setParams(handles,'ROI',curROI);
        end
        
        tt10 = toc(tt9);
        tt11 = tic();
        if strcmpi(options,'save')
            [handles,data] = ACQUIRE_scan(handles,'save'); %Acquire a scan
%             [particle_type] = getParams(handles,'ParticleType');
%             [minSize] = getParams(handles,'MinHist');
%             [maxSize] = getParams(handles,'MaxHist');
            
            particle_count = max_focus;
            
%             [particle_count,ParticleData] = spd_automated(handles,data,particle_type,minSize,maxSize); %Detect particles
%             disp(['Full FOV - ' particle_type ' Particles found: ' num2str(particle_count)]);
            
            output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
        else
            [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
            output=[];
            output.ROI_count = tree_counter(ind_focus,3);
            output.focus_plane = tree_counter(ind_focus,2);
            output.numLoop = numLoop;
        end
        tt12 = toc(tt11);
%         [handles] = LEDS_setState(handles,'vacuumoff');
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