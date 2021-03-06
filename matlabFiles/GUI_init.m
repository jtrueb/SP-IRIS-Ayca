function [handles] = GUI_init(handles,inputs)
%init takes a GUI handles struct and populates all the import variables
%need to run
%
%V14:
%   Position variables are now loaded from a text file

if size(inputs,2) == 2
    Instrument = inputs{1};
    ChipType = inputs{2};
elseif size(inputs,2) == 1
    Instrument = inputs{1};
    ChipType = 'V1';
end

%% GUI HANDLE PARAMETERS
handles.GUI.plotmain = ''; % for determining the main axes

%% GUI CONSTANTS
handles.const = struct();
handles.const.version = '2014.05.07 (V15)';
% handles.const.logo = 'other/theGrid11.png'; %% This is currently unused

handles.const.matlabversion = version('-release');
handles.const.max_diskspace = 1000; %1000 MB;
handles.const.max_diskspace_percentage = 0.8; % 20% free

handles.const.transpose_enabled = 1; %transpose the image.

% handles.const.GUI_state = struct();
% handles.const.GUI_state.init = 0;
% handles.const.GUI_state.Acquiring = 1;
% handles.const.GUI_state.DrawImage = 2;
% handles.const.GUI_state.Complete = 3;
% handles.const.GUI_state.StageMoving = 4;
% handles.const.GUI_state.LoadFile = 5;

handles.const.log = struct();
handles.const.log.instrument = 0;
handles.const.log.dataset = 1;
handles.const.log.particlefinder = 2;
handles.const.log.moviemaker = 3;
handles.const.log.stage = 4;
handles.const.log.parameter = 5;
handles.const.log.save = 6;
handles.const.log.camera = 7;
handles.const.log.led = 8;

handles.const.DataSetString = 'DataSet';
handles.const.ProcessString = 'Process';
handles.const.MirrorString = 'Mirror';
handles.const.InfoString = 'Info';
handles.const.FittedString = 'Fitted';
handles.const.SpotString = 'Spots';
handles.const.MinimapString = 'Minimap';

handles.const.DataFile_Info_Instrument = 'instr';
handles.const.DefaultFile = 'default.txt';
handles.const.available_instr = {'Prototype','SP-IRIS1','SP-IRIS2','SP-IRIS3','SP-A1000','Hybr�d','Ayca'};
handles.const.LEDs = [455 518 598 635];

handles.const.MatFileExtension = '.mat';
handles.const.txtFileExtension = '.txt';
handles.const.GifFileExtension = '.gif';
handles.const.ProcessingMethods = {'Dry','Wet'};
handles.const.ParticleType = {'Virus','AgNP','AuNP'};
handles.const.ChipType = {'V1','V2'};
handles.const.Camera.Names = {'Grasshopper2','Grasshopper','Retiga2000R','Retiga4000R','Grasshopper3-2_3MP'};

% Directories to look for and store data, config, text, etc
handles.const.directories = struct();
prefix = '../';
handles.const.directories.data = 'C:\User_Scratch'; %[prefix 'data_files'];
if (~exist(handles.const.directories.data,'file'))
    handles.const.directories.data = [prefix 'dataFiles'];
end
handles.const.directories.doc = [prefix 'documentation'];
handles.const.directories.logs = [prefix 'logFiles'];
handles.const.directories.matlab = [prefix 'matlabFiles'];
handles.const.directories.library = [prefix 'libraries'];
handles.const.directories.spd_automation = [prefix 'spd_automation'];
handles.const.directories.GUI_Analysis = [prefix 'GUI_Analysis'];
addpath(genpath(handles.const.directories.spd_automation));
addpath(genpath(handles.const.directories.GUI_Analysis));
handles.const.directories.detection = [prefix 'matlabFiles/SIFTDetection'];
handles.const.directories.CameraTemp = pwd;

%%%%%%%%%%%%%Start Diary%%%%%%%%%%%%%%
diary([handles.const.directories.logs '/log-' date '.log']);
diary on;

%% Hardware
set(handles.popupSelectCamera,'String',handles.const.Camera.Names);
set(handles.popupFittingInstrument,'String',handles.const.available_instr);
[handles] = setParams(handles,'Instrument',Instrument);%Initializes the hardware based on which instrument is being invoked
[handles] = CONTROL_WelcomeBtns(handles, 100); %Disable all acquisition buttons
[handles] = CONTROL_Tabs(handles,100); %Disable all tabs
[handles,msg2] = HARDWARE_init(handles);

%% Technical Constants
MainImageContrast = 5;
MinimapContrast = 1.5;

instrument = getParams(handles,'instrument');
if strcmpi(instrument,'Prototype') %Modify for later instruments
    zMin = 0000;
    zMax = 8800;
    yMin = 0000;
    yMax = 6800;
    xMin = 0000;
    xMax = 10400;
    
    exposure = 5;    prevExposure = 3;
    scanAvg = 30; 
    magnification = 55;
    NA = 0.8;
    
    backlash = [0,0]; %[X Y]
    HomePos = [3980 6675 8415]; %[X Y Z] former v2 position [4060 6460 8525]
    LoadPos = [5250 5350 0]; %[X Y Z]
 
    LogoPos_v1 = [4100 3100 8390]; %[X Y Z]
    LogoPos_v2 = [4100 3100 8390]; %[X Y Z] changed from [5080 1750 8490]
    
elseif strcmpi(instrument,'SP-IRIS2')
    zMin = 0000;
    zMax = 6200;
    yMin = 0000;
    yMax = 100000;
    xMin = 0000;
    xMax = 100000;
    
    exposure = 12;
    prevExposure = exposure;
    scanAvg = 20; 
    magnification = 50;
    NA = 0.8;
    
    backlash = [30,30]; %[X Y]
    HomePos = [77342 65000 4919]; %[X Y Z]
    LoadPos = [77000 15000 0]; %[X Y Z]
    LogoPos_v1 = [0 0 0]; %[X Y Z]
    LogoPos_v2 = [0 0 0]; %[X Y Z]
    
 elseif strcmpi(instrument,'SP-IRIS3')
    zMin = 0000;
    zMax = 4770;
    yMin = 0000;
    yMax = 100000;
    xMin = 0000;
    xMax = 100000;
    
    exposure = 7;
    prevExposure = exposure;
    scanAvg = 20;
    magnification = 50;
    NA = 0.8;
    
    backlash = [0,0]; %[X Y]
    HomePos = [73000 85720 4600]; %[X Y Z]
    LoadPos = [73000 20000 0]; %[X Y Z]
    LogoPos_v1 = [0 0 0]; %[X Y Z]
    LogoPos_v2 = [0 0 0]; %[X Y Z]
    
 elseif strcmpi(instrument,'SP-A1000')
    zMin = -5000;
    zMax = 5000;
    yMin = -25000;
    yMax = 25000;
    xMin = -25000;
    xMax = 25000;
    
    exposure = 3;
    prevExposure = exposure;
    scanAvg = 10; 
    magnification = 40;
    NA = 0.75;
    
    backlash = [0,0]; %[X Y]
    HomePos = [-620 -16000 250]; %[X Y Z]
    %LoadPos = [0 25000 5000]; %[X Y Z]
    LoadPos = [0 0 0]; %[X Y Z]
    LogoPos_v1 = [2700 -16000 250]; %[X Y Z]
    LogoPos_v2 = [2700 -16000 250]; %[X Y Z]
elseif strcmpi(instrument,'HYBRID')
    zMin = -5000;
    zMax = 1500;
    yMin = 0;
    yMax = 10000;
    xMin = 0;
    xMax = 10000;
    
    exposure = 3;
    prevExposure = exposure;
    scanAvg = 10;
    magnification = 40;
    NA = 0.8;
    
    backlash = [0,0]; %[X Y]
    HomePos = [3500,2000,1000]; %[X Y Z]
    %LoadPos = [0 25000 5000]; %[X Y Z]
    LoadPos = [10000 10000 -5000]; %[X Y Z]
    LogoPos_v1 = [0,0, 250]; %[X Y Z]
    LogoPos_v2 = [0,0 250]; %[X Y Z]
    
elseif strcmpi(instrument,'Ayca')
    zMin = -5000;
    zMax = 4500;
    yMin = -50000;
    yMax = 50000;
    xMin = -50000;
    xMax = 50000;
    
    exposure = 3;
    prevExposure = exposure;
    scanAvg = 10;
    magnification = 40;
    NA = 0.8;
    
    backlash = [0,0]; %[X Y]
    HomePos = [11912,-18476,4112]; %[X Y Z]
    %prev�ous z home 0 3746.5
    %LoadPos = [0 25000 5000]; %[X Y Z]
    LoadPos = [2000 10000 -4000]; %[X Y Z]
    LogoPos_v1 = [0,0, 250]; %[X Y Z]
    LogoPos_v2 = [0,0 250]; %[X Y Z]
    
end

MinimapPos = HomePos(1:2)-[175 2400]; %[X Y]

% Options Tab
[handles] = setParams(handles,'ZMax',zMax);
[handles] = setParams(handles,'ZMin',zMin);
[handles] = setParams(handles,'XMax',xMax);
[handles] = setParams(handles,'XMin',xMin);
[handles] = setParams(handles,'YMax',yMax);
[handles] = setParams(handles,'YMin',yMin);
[handles] = setParams(handles,'ZOffset',0);

[handles] = setParams(handles,'NA',NA);


[handles] = setParams(handles,'MainImageContrast',MainImageContrast);
[handles] = setParams(handles,'MinimapContrast',MinimapContrast);
[handles] = setParams(handles,'MirrorEnable','on');

%Status flags
[handles] = setParams(handles,'StageHomeStatus',0);
[handles] = setParams(handles,'StageInitStatus',0);
[handles] = setParams(handles,'ChipLoadStatus',0);
[handles] = setParams(handles,'SystemStatus',0);
[handles] = setParams(handles,'CameraPreviewStatus',0);
[handles] = setParams(handles,'RefParticleStatus',0);

%Corrections
[handles] = setParams(handles, 'Backlash', backlash); % [X Y]
[handles] = setParams(handles,'ChipOffset',[0 0]);
[handles] = setParams(handles,'ParticleOffset',0);
[handles] = setParams(handles,'RowOffset',[0 0]);

%Stage default positions
%Realignment on 1/10/2013. From [3800 6650 8000] to [3880 6336 8490]
[handles] = setParams(handles,'StageHomePos', HomePos); %[um] [X Y Z]

[handles] = setParams(handles,'StageLoadPos', LoadPos); %[um] [X Y Z]

%Realignment on 1/10/2013. From [3620 4240] to [3700 3926]
[handles] = setParams(handles,'MinimapStartPos', MinimapPos); %[um] [X Y]

handles.Stage.alignment_config_filename = '..\libraries\alignment_config.mat';

load(handles.Stage.alignment_config_filename);

handles.Stage.PlaneCoefficients=alignment_config.PlaneCoefficients{end};
handles.Stage.FC.Pos=alignment_config.FCpos{end};  %needs to be saved AS A CELL
handles.Stage.AlignmentDate=alignment_config.AlignmentInfo{1,end};
handles.Stage.AlignmentType=alignment_config.AlignmentInfo{2,end};

clear alignment_config

handles.Stage.FC.Pos={[0.0 0.0 0.0], [0.0 0.0 0.0], [0.0 0.0 0.0]};


% %Focus points %%%%% only first 3 points used
% FC = {[77402,63786,4917], [78842,63786,4920.2],...
%     [77402,63498,4916.9],}; %[um] [X Y Z] 
% 
% Coefficients = [0.00222222222222200;0.000347222222223485;4722.84763888881];
% 
% [handles] = setParams(handles,'PlaneCoeff',Coefficients);




% [handles] = setParams(handles,'FocusPos', FC);

[handles] = setParams(handles,'DwellTime',1);

%Logo location
%LogoPos is no longer assigned here. It is defined when ChipType is set.
% [handles] = setParams(handles,'LogoPos', LogoPos);
[handles] = setParams(handles,'AllLogoPos', [LogoPos_v1 LogoPos_v2]);

%Load camera defaults
camera = getParams(handles,'Camera');
[handles] = setParams(handles,'Magnification',magnification);
[handles] = CAMERA_loadDefaults(handles,camera);
[handles] = setParams(handles,'Exposure',exposure);

%First spot location w.r.t. upper right oxide corner
offset = [288 -288] + [-80 80]; %2x distance between ref square + offset to center
[handles] = setParams(handles,'ArrayOffset', offset); %um [X Y]

%% Initialize Tabs
% ChipInfo Tab

% handles.data.mirrorFolder = handles.const.directories.data;
% handles.data.saveFolder = handles.const.directories.data;

[handles] = setParams(handles,'ChipID','CHIP');
[handles] = setParams(handles,'ArrayX',6);
[handles] = setParams(handles,'ArrayY',4);

[handles] = setParams(handles,'PitchX',288); %[um]
[handles] = setParams(handles,'PitchY',288); %[um]



[handles] = setParams(handles,'ScanType','Prescan');

set(handles.popupChipType,'String',handles.const.ChipType);
set(handles.popupSelectParticle,'String',handles.const.ParticleType);
set(handles.popupSelectRefParticle,'String',handles.const.ParticleType);

[handles] = setParams(handles,'ChipType',ChipType);
[handles] = setParams(handles,'ParticleType','Virus');
[handles] = setParams(handles,'RefParticleType','Virus');

% HardwareCtrl Tab
[handles] = setParams(handles,'Exposure',exposure);
[handles] = setParams(handles,'PreviewExposure',prevExposure);

[handles] = setParams(handles,'ScanAvg',scanAvg);

[handles] = setParams(handles,'numCorners',3);

[handles] = setParams(handles,'YStep',10);%[um]
[handles] = setParams(handles,'XStep',10);%[um]
[handles] = setParams(handles,'ZStep',1);%[um]

[handles] = setParams(handles,'ZVelocity',1000); %in um/sec
[handles] = setParams(handles,'XYVelocity',5000); %in um/sec

[handles] = setParams(handles,'SmartMove',0);

% Process Tab
set(handles.popupFittingMethod,'String',handles.const.ProcessingMethods);
[handles] = setParams(handles,'Instrument_fit',instrument);
[handles] = setParams(handles,'FitMethod','Dry');
[handles] = setParams(handles,'IntensityTh',0.05);
[handles] = setParams(handles,'EdgeTh',2);
[handles] = setParams(handles,'TemplateSize',9);
[handles] = setParams(handles,'SD',1.5);
[handles] = setParams(handles,'GaussianTh',0.3);
[handles] = setParams(handles,'InnerRadius',9);
[handles] = setParams(handles,'OuterRadius',12);
[handles] = setParams(handles,'HistBin',20);
[handles] = setParams(handles,'MinHist',80);
[handles] = setParams(handles,'MaxHist',130);
[handles] = setParams(handles,'RefMinHist',30);
[handles] = setParams(handles,'RefMaxHist',250);
[handles] = setParams(handles,'RefParticleStatus',1);

%% Initialize images & movies

%File names
Vid_LoadChip{1} = 'GUI_LoadChip1.avi'; %Load Chip is 4 videos
Vid_LoadChip{2} = 'GUI_LoadChip2.avi';
Vid_LoadChip{3} = 'GUI_LoadChip3.avi';
Vid_LoadChip{4} = 'GUI_LoadChip4.avi';
Vid_AdjustArray = ' ';

Image_InitizePlot = zeros(260,390);
Image_focusImage = 'focusImage_resize.jpg';

[handles] = setParams(handles,'loadGIF',Vid_LoadChip);
%[handles] = setParams(handles,'loadGIF',Vid_AdjustArray);

[handles] = setParams(handles,'focusImage',Image_focusImage);

%Initialize minimap image
[handles] = setParams(handles,'MinimapPlaceholder','NSFAIRMinimapFile');

%Temp plot image
[handles] = IMAGE_Plot_display(handles,Image_InitizePlot,'image');

%% Set Directory and load data
[handles] = setParams(handles,'Directory',handles.const.directories.data);

%% Delete lock file if exists
FLAG_StopBtn('clear');

%% Display main figure
% set(handles.panels.figure,'Visible','on');
% figure(handles.panels.figure);

%% Enable Online or Offline mode
useStages = getParams(handles,'EnableStages');
if ~useStages
    handles=setParams(handles,'Mode',0);
end

if getParams(handles,'Mode')
    [handles] = STAGE_calibrate(handles);
    msg = 'Ready for loading'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
    % Disables Welcome tab & all stage movement if there is no stage
    [handles] = CONTROL_StageBtns(handles);
    
    getParams(handles,'Alignment');
    
     axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
%     [handles]=STAGE_MoveAbsolute(handles,axes,handles.Stage.FC.Pos{1});
    [handles ] = setParams(handles,'ChipLoadStatus',1);
    temp_z_pos=getParams(handles,'ZPos');
    [handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
    
else
    msg = [msg2 'Running in Offline Mode'];
    errorFlag = 1;
    feedbackLvl = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl,errorFlag);
    [handles] = CONTROL_WelcomeBtns(handles, 100);
    [handles] = CONTROL_Tabs(handles,6);%Enables ChipInfo & Process tab
end


% ERROR IF THIS DOESN't LOAD AUTOMATICALLY (from GUI_Callback_chkUseMirror)
[handles] = IMAGE_MainImage_loadData(handles);


%%% FOR SCREENSHOT
% msg = 'Ready for loading'; feedbackLvl = 1; errorFlag = 0;
%     [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
%         handles.txtLog,feedbackLvl,errorFlag);
%     [handles] = CONTROL_WelcomeBtns(handles, 5);
%     [handles] = CONTROL_Tabs(handles,0);%Enables ChipInfo & Process tab

end