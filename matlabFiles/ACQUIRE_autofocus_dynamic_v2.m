function [handles,output] = ACQUIRE_autofocus_dynamic_v2(handles,numLoop,z_init,focus_type,focus_offset,save_flag,scan_width,ROI_flag,tree_counter,direction)
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

if nargin<10
    direction=1;
end
if nargin <9
    tree_counter=[];
    tree_counter_flag=0;
else
    tree_counter_flag=1;
end

if nargin<8
    ROI_flag=0;
end

if nargin<7
    scan_width=45; %must be a factor of 4n+1, where n is even
end

if nargin < 6
    focus_offset = 0;
end


if nargin<5
    save_flag = 'focus';
    %     save_flag = 'save';
    %     save_flag = 'measure';
end

if nargin <5
    focus_type = 'max';
    %     focus_target = 'first';
    %     focus_target = 'second';
    %     focus_target = 'offset-second';
    %     focus_target = 'offset-max';
    %     focus_target = 'distance';
end



%reset scan_w�dth to insure integer indices
half_scan=fix(scan_width/2);
scan_width=2*half_scan+1;
step_size=.1;






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
        [handles] = setParams(handles,'ROI',curROI);
        [handles,~] = ACQUIRE_scan(handles,'take');
        
        msg = 'Stopped by user'; feedbackLvl = 1; errorFlag = 1;
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
            handles.txtLog,feedbackLvl,errorFlag);
        FLAG_StopBtn('clear')
        
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


% [max_coarse,ind_coarse] = max(tree_counter(:,3));
[xmax,imax,xmin,imin] = extrema(tree_counter(:,3));
secondary_flag=0;

if length(imax)==1;
    ind_coarse = imax(1);
elseif strcmpi(focus_type,'max') || strcmpi(focus_type,'offset_max')
    ind_coarse = imax(1);
elseif strcmpi(focus_type,'distance')
    ind_coarse = imax(1);
    ind_coarse_second=imax(2);
    secondary_flag = 1;
elseif strcmpi(focus_type,'first')
    if ((tree_counter(imax(1),2) - tree_counter(imax(2),2)) <= 0) && (abs(tree_counter(imax(2),2) - tree_counter(imax(1),2)) <= peak_gap_floor)
        %if this condition is met, first peak is largest
        ind_coarse=imax(1);
    elseif  ((tree_counter(imax(1),2) - tree_counter(imax(2),2)) > 0)  && (abs(tree_counter(imax(2),2) - tree_counter(imax(1),2)) <= peak_gap_floor)
        %if met there are two peaks, but second is larger than first
        ind_coarse= imax(2);
        secondary_flag=1;
    else %only 1 peak detected
        ind_coarse=imax(1);
    end
    
    
elseif strcmpi(focus_type,'second') || strcmpi(focus_type,'offset_second')
     if ((tree_counter(imax(1),2) - tree_counter(imax(2),2)) <= 0) && (abs(tree_counter(imax(2),2) - tree_counter(imax(1),2)) <= peak_gap_floor)
        %if this condition is met, two peaks but first peak is largest
        ind_coarse=imax(2);
        secondary_flag=1;
    elseif  ((tree_counter(imax(1),2) - tree_counter(imax(2),2)) > 0)  
        %if met there are two peaks, but second is larger than first
        ind_coarse= imax(1);
    else %only 1 peak detected
        ind_coarse=imax(1);
    end
    
    

else
    ind_coarse = imax(1);
end



tt4 = toc(tt3);
tt5 = tic();
if (ind_coarse==tree_counter(1,1))  || (abs(tree_counter(ind_coarse,2)-tree_counter(1,2))<peak_gap_floor)
    
    %extend tree counter by scan_length for lower z-positions
    
    
    
    %r-center scan range on max wing and scan again
    %            [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(5,2)-half_scan*step_size);
    [handles] = STAGE_MoveAbsolute(handles,zAxes,tree_counter(ind_coarse,2));
    if numLoop <= maxLoop
        if ROI_flag
            [handles] = setParams(handles,'ROI',curROI);
        end
        
        [handles,output] = ACQUIRE_autofocus_dynamic_v2(handles,numLoop+1,z_init,focus_type,focus_offset,save_flag,scan_width,ROI_flag,tree_counter,-1);
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
    if numLoop <= maxLoop
        if ROI_flag
            [handles] = setParams(handles,'ROI',curROI);
        end
        [handles,output] = ACQUIRE_autofocus_dynamic_v2(handles,numLoop+1,z_init,focus_type,focus_offset,save_flag,scan_width,ROI_flag,tree_counter,1);
%        
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








%%fill in the surrounding data points for ind_coarse

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
    
    temp=tree_counter([ind_coarse-4:ind_coarse+4],:);
    [~,temp_ind_med] = max(temp(:,3));
    ind_med=temp(temp_ind_med,1);
    
    
     % acquire 100nm resolution data point
    [handles, tree_counter(ind_med-1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
        tree_counter(ind_mid-1,2));
    
    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
    cla(handles.axesPlot);
    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
    
    %both directions for fine
    [handles, tree_counter(ind_med+1,3)] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
        tree_counter(ind_med_+1,2));
    
    set(gcf,'CurrentAxes',handles.axesPlot); %point to plot axes
    cla(handles.axesPlot);
    plot(tree_counter(tree_counter(:,3)>0,2),tree_counter(tree_counter(:,3)>0,3),'-ob');
    
    temp=tree_counter([ind_coarse-4:ind_coarse+4],:);
    [~,temp_ind_fine] = max(temp(:,3));
    ind_focus=temp(temp_ind_fine,1);

[handles, ~] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,...
        tree_counter(ind_focus,2));


% 
% 
% %%identify focal plane
% count_condensed=tree_counter(tree_counter(:,3)>0,:);
% count_smooth=count_condensed;
% for i=1:size(count_condensed,1)
%     if i==1
%         count_smooth(i,3)=mean(count_condensed(i:i+1,3));
%     elseif i==size(count_condensed,1)
%         count_smooth(i,3)=mean(count_condensed(i-1:i,3));
%     else
%         count_smooth(i,3)=mean(count_condensed(i-1:i+1,3));
%     end
% end


if strcmpi(options,'save')
    [handles,data] = ACQUIRE_scan(handles,'save'); %Acquire a scan
    %             [particle_type] = getParams(handles,'ParticleType');
    %             [minSize] = getParams(handles,'MinHist');
    %             [maxSize] = getParams(handles,'MaxHist');
    
    particle_count = max_focus;
    
    
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



