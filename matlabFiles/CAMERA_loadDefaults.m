function handles = CAMERA_loadDefaults(handles,camera)

if strcmpi(camera,'Grasshopper2')
%     [handles] = setParams(handles,'PixelSize',[3.45 3.45]); % [um]
%     [handles] = setParams(handles,'FPS',15);
%     [handles] = setParams(handles,'MaxPixels',[2048 2448]);%[Height Width]

    [handles] = setParams(handles,'MinExposure',0.03); % [ms]
    [handles] = setParams(handles,'MaxExposure',32000); % [ms]
    [handles] = setParams(handles,'PixelSize',[6.9 6.9]); % [um]
    [handles] = setParams(handles,'FPS_base',30); % Set everytime ROI is set
    [handles] = setParams(handles,'BitDepth',16);
    [handles] = setParams(handles,'ROIstep',8);
    [handles] = setParams(handles,'MaxPixels',[1024 1224]);%[Height Width]
    [handles] = setParams(handles,'Binning',[2 2]);%[Height Width]
elseif strcmpi(camera,'Grasshopper3-2_3MP')
    [handles] = setParams(handles,'MinExposure',0.03); % [ms]
    [handles] = setParams(handles,'MaxExposure',3000); % [ms]
    [handles] = setParams(handles,'PixelSize',[5.86 5.86]); % [um]
    [handles] = setParams(handles,'FPS_base',80); % Set everytime ROI is set
    [handles] = setParams(handles,'BitDepth',16);
    [handles] = setParams(handles,'ROIstep',8);
    [handles] = setParams(handles,'MaxPixels',[1200 1920]);%[Height Width]
    [handles] = setParams(handles,'Binning',[1 1]);%[Height Width]

elseif strcmpi(camera,'Grasshopper')
    [handles] = setParams(handles,'MinExposure',0.02); % [ms]
    [handles] = setParams(handles,'MaxExposure',10000); % [ms]
    [handles] = setParams(handles,'PixelSize',[6.45 6.45]); % [um]
    [handles] = setParams(handles,'FPS_base',15);
    [handles] = setParams(handles,'BitDepth',12);
    [handles] = setParams(handles,'ROIstep',8);
    [handles] = setParams(handles,'MaxPixels',[1036 1386]);%[Height Width]
    [handles] = setParams(handles,'Binning',[1 1]);%[Height Width]
    
elseif strcmpi(camera,'Retiga2000R')
    [handles] = setParams(handles,'MinExposure',1e-5); % [ms]
    [handles] = setParams(handles,'MaxExposure',1.0737e3); % [ms]
    [handles] = setParams(handles,'PixelSize',[7.4 7.4]); % [um]
    [handles] = setParams(handles,'FPS_base',10);
    [handles] = setParams(handles,'BitDepth',12);
    [handles] = setParams(handles,'ROIstep',1);
    [handles] = setParams(handles,'MaxPixels',[1200 1600]);%[Height Width]
    [handles] = setParams(handles,'Binning',[1 1]);%[Height Width]
    
elseif strcmpi(camera,'Retiga4000R')
    [handles] = setParams(handles,'MinExposure',0.01); % [ms]
    [handles] = setParams(handles,'MaxExposure',1074000); % [ms]
    [handles] = setParams(handles,'PixelSize',[7.4 7.4]); % [um]
    [handles] = setParams(handles,'FPS_base',5);
    [handles] = setParams(handles,'BitDepth',12);
    [handles] = setParams(handles,'ROIstep',1);
    [handles] = setParams(handles,'MaxPixels',[2048 2048]);%[Height Width]
    [handles] = setParams(handles,'Binning',[1 1]);%[Height Width]
end

[handles] = setParams(handles,'Exposure',getParams(handles,'Exposure'));

% [handles] = IMAGE_Minimap_init(handles);

% [handles] = setParams(handles,'EffPixel');
% [handles] = setParams(handles,'Exposure');
