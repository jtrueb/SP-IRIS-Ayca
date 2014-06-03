function [ output ] = filescan_SPIRIS2_v4( handles,chip_path,chip_name,spot_indices,options)
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

mirror_flag=0;

if ~isempty(handles.mirname) && ~isempty(handles.mirdir)
    clear data;
    clear frame;
    clear data_mir;
    
    try
        
    load([handles.mirdir,handles.mirname]);
    
    if exist('data_mir')
        mirror_flag=1;
        mir_raw=data_mir;
        clear data_mir;
    elseif exist('data')
        mirror_flag=1;
        mir_raw=data;
        clear data;
    elseif exist('frame')
        mirror_flag=1;
        mir_raw=frame;
        clear frame;
    end
    
    end
end




 file_path= [chip_path chip_name];     


FileList = dir([file_path '*' '.mat']);

FileIndex = size(FileList,1);

disp(['Datasets found: ' num2str(FileIndex)]);

for m = 1:length(spot_indices)
    file_input_name = FileList(spot_indices(m)).name;
   
    disp(['Processing Image: ' num2str(spot_indices(m)) ' / ' num2str(FileIndex) ': ' file_input_name]);
        
    clear data;
    clear frame;
    clear data_mir;
    
    
   tic;
    load([chip_path file_input_name]);
    
 if exist('frame')
   data_temp=frame;
%    data_temp=data_temp./16;
   clear frame;
 elseif exist('data')
     data_temp=data;
     clear data;
 end
 
 if strcmpi(options,'reference')
     
     crop_rect_image=handles.crop_rect_image_reference;
 else
    crop_rect_image=handles.crop_rect_image_signal; 
 end
 
 mir_temp=mir_raw;
 
  if ~isempty(crop_rect_image)     
 
     data_temp=data_temp(crop_rect_image(2):crop_rect_image(2)+crop_rect_image(4),...
        crop_rect_image(1):crop_rect_image(1)+crop_rect_image(3));
    
    if mirror_flag
       mir_temp=mir_temp(crop_rect_image(2):crop_rect_image(2)+crop_rect_image(4),...
        crop_rect_image(1):crop_rect_image(1)+crop_rect_image(3));
    end
    
  end
  
  if mirror_flag
      mir_filter=mir_temp./4095;
      mir_filter=mir_filter-median(mir_filter(:))+1;
      data_temp=data_temp./mir_filter;
  end
      
     

     

       output.pdata{m}.particledata=ZSTACK_generate_particles_PSF(data_temp,handles);
       output.pdata{m}.spot_index=spot_indices(m);

    

   
 end
output.crop_rect_image=crop_rect_image;
output.spot_ind=spot_indices;
output.total_spots=FileIndex;
output.chipname=chip_name;
output.IntTh=handles.IntTh;
output.namelist=FileList;








end

