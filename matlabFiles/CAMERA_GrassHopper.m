function [handles,out] = CAMERA_GrassHopper(handles,options)
% [handles,out] = CAMERA_GrassHopper(handles,options) has two inputs and
% two outputs. If 'init' is the 2nd input argument, then out will be a 
% struct() containing the default options. After modifying those options,
% resuppling the options as the input allows one to control the camera and
% collect data
% handles is used to toggle the LEDs on/off

%% FUNCTION VARS
quickexit = 0;
max_frames_per_iteration = 10; %timeout if more than twenty

%% SETUP OUTPUTS
out = struct();
out.data = [];

%% SETUP CAMERA OPTIONS from INPUT
capture_mode = 0; % 0 is preview , 1 is frame capture
exposure = 0.02;
timeout = 2e9;
ROI = [0 0 1384 1036];
gain = 1;
capture_number_of_frames = 1;
daq_enabled = 0;
daq_handle = 0;
bitdepth = 16;
save_raw_integer_data = 1; %since the output is saved as a double otherwise

if nargin > 0
    if (ischar(options) && strcmp(options,'init'))
        options = struct();
        options.capture_mode = capture_mode;
        options.number_of_frames = capture_number_of_frames;
        options.exposure = exposure;
        options.timeout = timeout;
        options.ROI = ROI;
        options.gain = gain;
        options.bitdepth = bitdepth;
        options.daq_handle = daq_handle;
        options.save_raw_integer_data = save_raw_integer_data;
        
        out = options;
        quickexit = 1; %just return this
    else %
        if (isfield(options,'capture_mode'))
            if (options.capture_mode >= 0)
                capture_mode = options.capture_mode;
            end
        end
        if (isfield(options,'number_of_frames'))
            if (options.number_of_frames > 0)
                capture_number_of_frames = options.number_of_frames;
            end
        end
        if (isfield(options,'exposure'))
            if (options.exposure > 0)
                exposure = options.exposure;
            end
        end
        if (isfield(options,'timeout'))
            if (options.timeout >= 0)
                timeout = options.timeout;
            end
        end
        if (isfield(options,'ROI'))
            if (options.ROI >= 0)
                ROI = options.ROI;
            end
        end
        if (isfield(options,'gain'))
            if (options.ROI >= 0)
                gain = options.gain;
            end
        end
        if (isfield(options,'daq_handle'))
            if (isa(options.daq_handle,'analoginput'))
                daq_enabled = 1;
                daq_handle = options.daq_handle;
            end
        end
        if (isfield(options,'save_raw_integer_data'))
            if (options.save_raw_integer_data >= 0)
                save_raw_integer_data = options.save_raw_integer_data;
            end
        end
    end
end
if (quickexit == 0) %continue
    %% GET GRASSHOPPER CAMERA
    % this just lists the known formats from camera
    grasshopper_formats = {'F7_Y16_1384x1036','F7_Y16_1384x518',...
        'F7_Y16_692x518','F7_Y8_1384x1036',...
        'F7_Y8_1384x518','F7_Y8_692x518',...
        'Y16_1024x768','Y16_1280x960',...
        'Y16_640x480','Y16_800x600',...
        'Y8_1024x768','Y8_1280x960',...
        'Y8_640x480','Y8_800x600'};

    [handles] = CAMERA_checkPreview(handles); %Check if preview is on    
    vid_obj = videoinput('dcam',1,grasshopper_formats{1});
    src_obj = getselectedsource(vid_obj);
    flushdata(vid_obj,'all');
    
    %% SETUP CAMERA FOR IRIS MEASURMENTS
    
    % Set frame timeout to a high number
    set(src_obj,'FrameTimeout',timeout);
    
    % Control Exposure/Control Time
    set(src_obj,'ShutterMode','manual');
    set(src_obj,'ShutterControl','absolute');
    set(src_obj,'ShutterAbsolute',exposure);
    
    % disable AutoExposure
    set(src_obj,'AutoExposureMode','manual');
    set(src_obj,'AutoExposureControl','absolute');
    set(src_obj,'AutoExposureAbsolute',0);
    
    % disable Brightness Control
    set(src_obj,'BrightnessControl','absolute');
    set(src_obj,'BrightnessAbsolute',0);    
    
    % disable gain
    set(src_obj,'GainMode','manual');
    set(src_obj,'GainControl','absolute');
    set(src_obj,'GainAbsolute',1);    
    
    %disable sharpness adjustment
    set(src_obj,'SharpnessMode','manual');
    set(src_obj,'Sharpness',0);    
   
%     mem_size = (capture_number_of_frames*ROI(3)*ROI(4)) ...
%         *(numberofbytespersample*mem_engineering_margin);
%     imaqmem(mem_size); %resize memory for
    
    %% CAPTURE OR PREVIEW
    [handles] = LEDS_setState(handles,'on'); %Turn LEDs on
    
    data = zeros(ROI(4),ROI(3)); %clear data vars
    data_temp = [];    
    data_pd = [];
    
    if (capture_mode > 0) %capture mode    
        triggerconfig(vid_obj, 'Manual');
        iterations = ceil(capture_number_of_frames/max_frames_per_iteration);
 
        %% Trigger first image. 
        %For some reason the first image is complete trash
        stop(vid_obj);
        set(vid_obj,'ROIPosition',[0 0 8 2]);
        set(vid_obj,'FramesPerTrigger',1);
        set(vid_obj,'TriggerRepeat',1);
        start(vid_obj);
        trigger(vid_obj);
        temp = getdata(vid_obj,1);
        clear temp;

        %%
        stop(vid_obj);
        set(vid_obj,'ROIPosition',ROI);
        
        for i = 1:iterations
            clear data_temp;
            frames_taken = min([(capture_number_of_frames-((i-1)*max_frames_per_iteration)) max_frames_per_iteration]);
            set(vid_obj,'FramesPerTrigger',frames_taken);
            start(vid_obj);
            trigger(vid_obj);
            if (daq_enabled > 0)
                trigger(daq_handle);
                data_pd_temp = getdata(daq_handle);
                data_pd(end + 1) = mean(data_pd_temp);
            else
                data_pd = 1;
            end
            temp = getdata(vid_obj,frames_taken);
            data_temp(:,:,:) = temp(:,:,1,:); %remove extra dimension
            data = data + sum(data_temp,3)/capture_number_of_frames; %average data
            stop(vid_obj);
        end

        if (save_raw_integer_data > 0)
            out.data = data;
            out.data_pd = mean(data_pd);
        else
            out.data = double(data);
            out.data_pd = mean(data_pd);
        end
        delete(vid_obj); % Remove video input object from memory.
    else %preview mode
%         closepreview;
        f = figure;
        set(f,'Name','GrassHopper Preview');
        set(vid_obj,'FramesPerTrigger',1);%Set number of frames to 1
        himage = imagesc(getsnapshot(vid_obj)); %Grab an image for figure sizing
        preview(vid_obj,himage);
        [handles] = setParams(handles,'CameraPreviewStatus',1); %Throw preview flag
    end
    
end %quick exit end