function [handles,out] = CAMERA_Retiga4000R(handles,options)
% [handles,out] = CAMERA_Retiga_4000R(handles,options) has two inputs and
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
exposure = 0.04;
timeout = 1000;
ROI = [0 0 2048 2048];
gain = 1;
capture_number_of_frames = 10;
daq_enabled = 0;
daq_handle = 0;
bitdepth = 12;

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
            if (options.gain >= 0)
                gain = options.gain;
            end
        end
        if (isfield(options,'daq_handle'))
            if (isa(options.daq_handle,'analoginput'))
                daq_enabled = 1;
                daq_handle = options.daq_handle;
            end
        end
    end
end
if (quickexit == 0) %continue
    %% GET RETIGA CAMERA
    % This is the list of the known camera formats
    retiga_formats = {'MONO16_1024x1024','MONO16_2048x2048',...
        'MONO16_256x256','MONO16_512x512','MONO8_1024x1024',...
        'MONO8_2048x2048','MONO8_256x256','MONO8_512x512',...
        'RGB16_1024x1024','RGB16_2048x2048','RGB16_256x256',...
        'RGB16_512x512','RGB8_1024x1024','RGB8_2048x2048',...
        'RGB8_256x256','RGB8_512x512'};
    
    [handles] = CAMERA_checkPreview(handles); %Check if preview is on
    if(capture_mode==0)
        %Preview does not work in 16bit mode
        vid_obj=videoinput('qimaging',1,retiga_formats{6});
    else
        vid_obj=videoinput('qimaging',1,retiga_formats{2});
    end
    src_obj = getselectedsource(vid_obj);
    flushdata(vid_obj,'all');
    
    src_obj.BayerPostProcessGainBlue=100;
    src_obj.BayerPostProcessGainRed=100;
    src_obj.ExposureBlue=exposure;
    src_obj.ExposureRed=exposure;
    
    %% SETUP CAMERA FOR IRIS MEASURMENTS
    %Turn on cooling
    try
        if(~strcmp(get(getselectedsource(vid_obj),'Cooling'),'on'))
            set(getselectedsource(vid_obj),'Cooling','on');
        end
    catch
    end
    
    %Set exposure
    set(src_obj,'Exposure',exposure);
    
    %Set Gain
    set(src_obj,'NormalizedGain',gain);
    
    %Set number of frames per triggering of camera
    set(vid_obj,'FramesPerTrigger',capture_number_of_frames);
    
    %Set ROI
    set(vid_obj,'ROIPosition',ROI);
    
    %Set dataset time out variable
    set(vid_obj,'Timeout',timeout);
    
    %% CAPTURE OR PREVIEW
    [handles] = LEDS_setState(handles,'on'); %Turn LEDs on
    
    data = zeros(ROI(4),ROI(3)); %clear data vars
    data_temp = [];
    data_pd = [];
    
    if (capture_mode > 0) %capture mode
        triggerconfig(vid_obj, 'Manual')
        iterations = ceil(capture_number_of_frames/max_frames_per_iteration);
        
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
        end
                
        out.data = data;
        out.data_pd = mean(data_pd);        
        
        delete(vid_obj); % Remove video input object from memory.
        [handles] = LEDS_setState(handles,'off'); %Turn LEDs off
    else %preview mode
%         closepreview;
        f = figure;
        set(f,'Name','Retiga-4000R Preview');
        set(vid_obj,'FramesPerTrigger',1);%Set number of frames to 1
        himage = imagesc(getsnapshot(vid_obj)); %Grab an image for figure sizing
        preview(vid_obj,himage);
        [handles] = setParams(handles,'CameraPreviewStatus',1); %Throw preview flag
    end
    
end %quick exit end


