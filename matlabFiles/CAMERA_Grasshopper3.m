function [handles,out] = CAMERA_Grasshopper3(handles,options)
% [handles,out] = CAMERA_Grasshopper3(handles,options) has two inputs and
% two outputs. If 'init' is the 2nd input argument, then out will be a 
% struct() containing the default options.

%% FUNCTION VARS
quickexit = 0;

%% SETUP CAMERA OPTIONS from INPUT
capture_mode = 0; % 0 is preview , 1 is frame capture

% GET camera config struct if one isn't provided
if nargin < 1
    out = getDefaultConfig();
else
    out = options;
end

if nargin > 0 
    if (ischar(options) && strcmp(options,'init'))
        out = getDefaultConfig();
        quickexit = 1; %just return this
    else %
        if (isfield(options,'capture_mode'))
            if (options.capture_mode >= 0)
                capture_mode = options.capture_mode;
            end
        end
        if (isfield(options,'number_of_frames'))
            if (options.number_of_frames > 0)
                out.frames = options.number_of_frames;
            end
        end
        if (isfield(options,'exposure'))
            if (options.exposure > 0)
                out.shutter = options.exposure*1000; % in seconds, need to convert to ms
            end
        end
        if (isfield(options,'ROI'))
            if (options.ROI >= 0)
                ROI = options.ROI;
                out.left = ROI(1); %
                out.width = ROI(3); % 0 = full
                out.top = ROI(2); %
                out.height = ROI(4); % 0 = full
            end
        end
        if (isfield(options,'gain'))
            if (options.gain >= 0)
                out.gain = options.gain;
            end
        end
    end
end
if (quickexit == 0) %continue
    
    if (capture_mode > 0) %capture mode
        write_config(out);        
        out.data = capture_frame();

    else %preview mode
        launch_preview();
        [handles] = setParams(handles,'CameraPreviewStatus',1); %Throw preview flag
    end
    
end %quick exit end

function [data] = capture_frame()
fn = '..\libraries\FlyCap2Interface\FlyCap2Interface.exe';
img_fn = '..\data\capture.png';
[status,cmdout] =  system(fn);
img = imread([img_fn]); %RGB 48-bit PNG image
data(:,:) = img(:,:,1);
%imshow(data);

function launch_preview()
fn = '..\libraries\FlyCap2Interface\FlyCap2RealTime.exe';
system([fn '&']);

function write_config(in)
fn = '..\config\config.cam.txt';
if (isstruct(in))
    flds = fields(in);
    fid = fopen(fn,'w');

    for i = 1:size(flds,1)
        if (strcmp(flds{i},'filename'))
            fprintf(fid,'%s:%s\r\n',flds{i},in.(flds{i}));
        elseif (strcmp(flds{i},'extra_info'))
            fprintf(fid,'%s:%s\r\n',flds{i},in.(flds{i}));
        elseif (strcmp(flds{i},'ROI') || strcmp(flds{i},'exposure') ...
                || strcmp(flds{i},'number_of_frames') || strcmp(flds{i},'timeout') ...
                || strcmp(flds{i},'capture_mode') )
            % do nothing, but this isn't a standard val so it crashes
            % interface
        else
            fprintf(fid,'%s:%d\r\n',flds{i},in.(flds{i}));
        end
    end  
    fclose(fid);
else
    fprintf('Incorrect function input, not a struct!\n');
end

function [out] = getDefaultConfig()

out = struct();
out.shutter = 1.0; %ms
out.frames = 10; %# of frames to averages
out.filename = 'capture'; %.png
out.fps = 80; % // frames per second 
out.wordsize = 16; % // 16-bits
out.left = 0; %
out.width = 0; % 0 = full
out.top = 0; %
out.height = 0; % 0 = full
out.sharpness = 50.0; %
out.brightness = 50.0; %
out.exposure = 50.0; %
out.gain = 0; % // dB
out.bin = 1; % // 1x1 binning
out.extra_info = 'false';

