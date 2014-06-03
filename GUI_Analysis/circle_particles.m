function [ output ] = circle_particles( handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Part 1: System Variables
% addpath(genpath([pwd '\SIFT files']));
% spd_ver = mfilename; %Software version

%___________________________   Identifiers   _____________________________%
%Files are in the structure: [rootname][identifier][timestamp]
% data_identifier = 'Frame'; %For ZoirayAcquire data
% data_identifier = 'DataSet'; %For SPIRIS Acquire data
% mirror_identifier = 'Mirror';
% crop_identifier = 'Cropped';
% detect_identifier = 'Detected';

%_________________________________________________________________________%
 



output=[];
mir_filter=[];
mirror_flag=0;

savepath_analysis=[handles.signaldir handles.chipname_signal '_ANALYSIS_' handles.signal_namelist{handles.signal_indices(handles.current_index)}(end-9:end-4) '.mat'];

%load analysis file as analysis_data
try
    load(savepath_analysis);
catch
    disp(['Analysis data path - ' savepath_analysis ' - is invalid']);
    return;
    
end

%import crop rect from analysis_data
crop_rect_image=analysis_data.crop_rect_signal;

   

%load mirror file, if present
if ~isempty(handles.mirname) && ~isempty(handles.mirdir)
    clear data;
    clear frame;
    clear data_mir;
    

        
    load([handles.mirdir,handles.mirname]);
    
    if exist('data_mir')==1
        mirror_flag=1;
        mir_temp=data_mir;
        clear data_mir;
    elseif exist('data')==1
        mirror_flag=1;
        mir_temp=data;
        clear data;
    elseif exist('frame')==1
        mirror_flag=1;
        mir_temp=frame;
        clear frame;
    else
        disp('Error: not a mirror file');
    end
    
     
     
    if mirror_flag
        if ~isempty(crop_rect_image)
            mir_temp=mir_temp(crop_rect_image(2):crop_rect_image(2)+crop_rect_image(4),...
                crop_rect_image(1):crop_rect_image(1)+crop_rect_image(3));
        end
        
        mir_filter=mir_temp./median(mir_temp(:));
        
%         mir_filter=mir_temp./4095;
%         mir_filter=mir_filter-median(mir_filter(:))+1;
    end
   
end

%load image file
try
    temp_file=load(handles.display_image_path);
catch
     disp(['Image path - ' handles.display_image_path ' - is invalid']);
    return;
    
end
    
 if isfield(temp_file,'frame')
   data_temp=temp_file.frame;
%    data_temp=data_temp./16;
%    clear frame;
 elseif isfield(temp_file,'data')
     data_temp=temp_file.data;
%      clear data;
 end
 

 

 
  if ~isempty(crop_rect_image)     
 
     data_temp=data_temp(crop_rect_image(2):crop_rect_image(2)+crop_rect_image(4),...
        crop_rect_image(1):crop_rect_image(1)+crop_rect_image(3));
    
   
    
  end
  
  if mirror_flag
      data_temp=data_temp./mir_filter;
  end
  
  temp_pdata=analysis_data.calc_pdata.particledata;
limits=temp_pdata.limits_signal;

circles_xy=temp_pdata.xylocs;
Contrasts_inrange_mask=(temp_pdata.Contrasts(:)>limits(3)) & (temp_pdata.Contrasts(:)<limits(4));
Corr_inrange_mask=(temp_pdata.correlations(:)>limits(1)) & (temp_pdata.correlations(:)<limits(2));

mask_both=Contrasts_inrange_mask & Corr_inrange_mask;
contrasts=temp_pdata.Contrasts(mask_both(:));
% corrs=temp_pdata.correlations(mask_both(:));
circles_xy=temp_pdata.xylocs(mask_both(:),:);


    figure;
    imshow(data_temp,[mean(data_temp(:))-2*std(data_temp(:)),mean(data_temp(:))+2*std(data_temp(:))]);
    hold on;
    for m=1:length(contrasts)
        plot(circles_xy(m,1),circles_xy(m,2),'or');

    end
    title(['Index: ',num2str(handles.signal_indices(handles.current_index)),', Limits: [' num2str(limits(1)),',',num2str(limits(2)),',',num2str(limits(3)),',',num2str(limits(4)),']'  ]);








end

