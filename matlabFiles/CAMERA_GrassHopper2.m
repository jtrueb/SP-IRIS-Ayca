function [handles,out] = CAMERA_GrassHopper2(handles,options)
% [out] = CAMERA_GrassHopper(options) has one input argument and one output
% argument. If 'init' is the input arguments, then out will be a struct()
% contaning the default options. After modifying those options, resuppling
% the options as the input allows one to control the camera and collect
% data

%% FUNCTION VARS
quickexit = 0;
numberofbytespersample = 8; % size of double
mem_engineering_margin = 1.5; % use a number greater than one
max_frames_per_iteration = 10; %timeout if more than twenty

%% SETUP OUTPUTS
out = struct();
out.data = [];

%% SETUP CAMERA OPTIONS from INPUT
capture_mode = 0; % 0 is preview , 1 is frame capture
save_raw_integer_data = 1; %since the output is saved as a double otherwise
ROI = [0 0 2048 2448];
capture_number_of_frames = 1;
exposure = 0.02;
daq_enabled = 0;
daq_handle = 0;
camera_pause = 0.5;
binning = [2 2];
fps = 15;

%%%%%%%%%%%%ADD FRAMERATE%%%%%%%%%%%%
if nargin > 0
    if (ischar(options) && strcmp(options,'init'))
        options = struct();
        options.capture_mode = capture_mode;
        options.number_of_frames = capture_number_of_frames;
        options.exposure = exposure;
        options.save_raw_integer_data = save_raw_integer_data;
        options.daq_handle = 0;
        options.camera_pause = camera_pause;
        options.ROI = ROI;
        options.binning = binning;
        options.fps = fps;
        
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
        if (isfield(options,'save_raw_integer_data'))
            if (options.save_raw_integer_data >= 0)
                save_raw_integer_data = options.save_raw_integer_data;
            end
        end
        if (isfield(options,'camera_pause'))
            if (options.camera_pause >= 0)
                camera_pause = options.camera_pause;
            end
        end
        if (isfield(options,'daq_handle'))
            if (isa(options.daq_handle,'analoginput'))
                daq_enabled = 1;
                daq_handle = options.daq_handle;
            end
        end
        if (isfield(options,'ROI'))
            if (options.ROI >= 0)
                ROI = options.ROI;
            end
        end
        if (isfield(options,'binning'))
            if(options.binning >=0)
                if(size(options.binning,2)==2)
                    binning = options.binning;
                else
                    binning = [options.binning options.binning];
                end
            end
        end
        if (isfield(options,'fps'))
            if(options.fps >=0)
                fps = options.fps;
            end
        end
    end
end
if (quickexit == 0) %continue    
    %% CAPTURE OR PREVIEW
    [handles] = CAMERA_checkPreview(handles);
    [handles] = LEDS_setState(handles,'on');
    
    %% SETUP CAMERA FOR IRIS MEASURMENTS or set when the user changes them
    %Set Shutter speed, ROI, Frame Count    
    CAMERA = getParams(handles,'CameraPointers');
    CAMERA_setParams(CAMERA, exposure, ROI, capture_number_of_frames,binning,fps);
    
    if (capture_mode > 0) %capture mode    
        %% Get data
        [out.data] = CAMERA_getImage(CAMERA);
        [handles] = LEDS_setState(handles,'off');
    else %preview mode
        [out.data] = CAMERA_openPreview(CAMERA);
        [handles] = setParams(handles,'CameraPreviewStatus',1);
    end    
end %quick exit end