function [ output ] = filescan_SPIRIS2_v4_singlethread( handles,chip_path,chip_name,spot_indices,options)
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
 
bit_depth=4095;

if nargin < 5
    options = 'signal';
end

mir_filter=[];
mirror_flag=0;

if strcmpi(options,'reference')
     
     crop_rect_image=handles.crop_rect_image_reference;
 else
    crop_rect_image=handles.crop_rect_image_signal; 
 end

if ~isempty(handles.mirname) && ~isempty(handles.mirdir)
    clear data;
    clear frame;
    clear data_mir;
    

        
    load([handles.mirdir,handles.mirname]);
    
    if exist('data_mir')
        mirror_flag=1;
        mir_temp=data_mir;
        clear data_mir;
    elseif exist('data')
        mirror_flag=1;
        mir_temp=data;
        clear data;
    elseif exist('frame')
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
        
        mir_filter=mir_temp./4095;
        mir_filter=mir_filter-median(mir_filter(:))+1;
    end
   
end




 file_path= [chip_path chip_name];     


FileList = dir([file_path '*' '.mat']);

FileIndex = size(FileList,1);

disp(['Datasets found: ' num2str(FileIndex)]);

 tic;

for m = 1:length(spot_indices)
    file_input_name = FileList(spot_indices(m)).name;
   
    disp(['Processing Image: ' num2str(spot_indices(m)) ' / ' num2str(FileIndex) ': ' file_input_name]);
        
%     clear data;
%     clear frame;
%     clear data_mir;
    
    
   
    temp_file=load([chip_path file_input_name]);
    
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
      data_temp(data_temp>4095)=4095;
      data_temp(data_temp<0)=0;
  end
      
     

     

       pdata{m}.particledata=ZSTACK_generate_particles_PSF(data_temp,handles);
       pdata{m}.spot_index=spot_indices(m);

    

   
end

disp(['Filescan time: ' num2str(toc)]);
 output.pdata=pdata;
output.crop_rect_image=crop_rect_image;
output.spot_ind=spot_indices;
output.total_spots=FileIndex;
output.chipname=chip_name;
output.IntTh=handles.IntTh;
output.namelist=FileList;








end

