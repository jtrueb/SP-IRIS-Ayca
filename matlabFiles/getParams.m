function [val] = getParams(handles,parameter)

if strcmpi(parameter,'Directory');
    val = get(handles.txtValueSaveFolder,'String');
    
    if ~strcmpi(val(end), '\')
        val = [val '\'];
    end

elseif strcmpi(parameter,'MirrorDirectory')
    if (isfield(handles.data, 'mirrorFolder'))
        val = handles.data.mirrorFolder;
    else
        val=getParams(handles,'Directory');
    end
    
    if ~strcmpi(val(end),'\')
        val = [val '\'];
    end
        
elseif strcmpi(parameter,'Mode')
    if ~isfield(handles,'mode')
        handles.mode = 1;
    end
    val = handles.mode;
    
elseif strcmpi(parameter,'ChipID')
    val = get(handles.editChipID,'String');

elseif strcmpi(parameter,'ChipType')
    temp = get(handles.popupChipID,'Value');
    val = handles.const.ChipID{temp};
    
elseif strcmpi(parameter,'ArrayX')
    val = str2double(get(handles.editArrayX,'String'));
    
elseif strcmpi(parameter,'ArrayY')
    val = str2double(get(handles.editArrayY,'String'));
    
elseif strcmpi(parameter,'ArraySize')
    val(1) = getParams(handles,'ArrayX');
    val(2) = getParams(handles,'ArrayY');

elseif strcmpi(parameter,'ArrayTotal')
    val = handles.const.arrayTotal;

elseif strcmpi(parameter,'ArrayOffset')
    val = handles.const.arrayOffset;

elseif strcmpi(parameter,'RowOffset')
    arraySize = getParams(handles,'ArraySize');
    
    if isfield(handles.const,'rowOffset')
        val = handles.const.rowOffset;
        
        if size(val,1) ~= arraySize(2)
            val = zeros(arraySize(2),2);
        end
    else
        val = zeros(arraySize(2),2);
        [handles] = setParams(handles,'RowOffset',val);
    end
    
elseif strcmpi(parameter,'PitchX')
    val = str2double(get(handles.editArrayPitchX,'String'));
    
elseif strcmpi(parameter,'PitchY')
    val = str2double(get(handles.editArrayPitchY,'String'));
    
elseif strcmpi(parameter,'Stage_XYIndex')
    val = [getParams(handles,'PitchX') getParams(handles,'PitchY')];
    
elseif strcmpi(parameter,'Stage_XYPos')
    val = [getParams(handles,'XPos') getParams(handles,'YPos')];

elseif strcmpi(parameter,'Stage_Pos')
    val = [getParams(handles,'XPos') getParams(handles,'YPos') getParams(handles,'ZPos')];
    
elseif strcmpi(parameter,'ParticleType')
    temp = get(handles.popupSelectParticle,'Value');
    val = handles.const.ParticleType{temp};

elseif strcmpi(parameter,'RefParticleType')
    temp = get(handles.popupSelectRefParticle,'Value');
    val = handles.const.ParticleType{temp};
    
elseif strcmpi(parameter,'ScanType')
    if get(handles.radPrescan,'Value')
        val = 'Prescan';
    elseif get(handles.radPostscan,'Value')
        val = 'Postscan';
    end

elseif strcmpi(parameter,'MoveType')
    if get(handles.radUser,'Value')
        val = 'User';
    elseif get(handles.radFOV,'Value')
        val = 'FOV';
    elseif get(handles.radPitch,'Value')
        val = 'Pitch';
    end
    
elseif strcmpi(parameter,'Comment')
    val = get(handles.editComment,'String');
    
elseif strcmpi(parameter,'Camera')
    temp = get(handles.popupSelectCamera,'Value');
    val = handles.const.Camera.Names{temp};
    
elseif strcmpi(parameter,'Exposure')
    val = str2double(get(handles.editScanExposure,'String'));

elseif strcmpi(parameter,'PreviewExposure')
    val = handles.const.Camera.PreviewExposure;
    
elseif strcmpi(parameter,'MinExposure')
    val = handles.const.Camera.MinExp;
    
elseif strcmpi(parameter,'MaxExposure')
    val = handles.const.Camera.MaxExp;

elseif strcmpi(parameter,'FPS_base')
    val = handles.const.Camera.FPS_base;
    
elseif strcmpi(parameter,'FPS')
    val = handles.const.Camera.FPS;
    
elseif strcmpi(parameter,'Bitdepth')
    val = handles.const.Camera.BitDepth;
    
elseif strcmpi(parameter,'ROIstep')
    val = handles.const.Camera.ROIstep;
    
elseif strcmpi(parameter,'ScanAvg')
    val = str2double(get(handles.editScanAvg,'String'));
    
elseif strcmpi(parameter,'Width')
    val = handles.const.Camera.ROI(4);
    
elseif strcmpi(parameter,'Height')
    val = handles.const.Camera.ROI(3);
    
elseif strcmpi(parameter,'xOffset')
    val = handles.const.Camera.ROI(2);
    
elseif strcmpi(parameter,'yOffset')
    val = handles.const.Camera.ROI(1);
    
elseif strcmpi(parameter,'ROI')
    val = handles.const.Camera.ROI;
    
elseif strcmpi(parameter,'LED')
    if get(handles.radioLED1,'Value')
        val = handles.LEDs.commands.led1;
    elseif get(handles.radioLED2,'Value')
        val = handles.LEDs.commands.led2;
    elseif get(handles.radioLED3,'Value')
        val = handles.LEDs.commands.led3;
    elseif get(handles.radioLED4,'Value')
        val = handles.LEDs.commands.led4;
    end
    
elseif strcmpi(parameter,'LEDColor')
    temp = getParams(handles,'LED');
    if strcmpi(temp,handles.LEDs.commands.led1)
        temp = 1;
    elseif strcmpi(temp,handles.LEDs.commands.led2)
        temp = 2;
    elseif strcmpi(temp,handles.LEDs.commands.led3)
        temp = 3;
    elseif strcmpi(temp,handles.LEDs.commands.led4);
        temp = 4;
    end
    
    val = handles.const.LEDs(temp);

elseif strcmpi(parameter,'numCorners')
    if get(handles.rad3Corner,'Value')
        val = 3;
    elseif get(handles.rad4Corner,'Value')
        val = 4;
    end

elseif strcmpi(parameter,'ZMax')
%     val = handles.const.Stage.ZMax;
    val = str2double(get(handles.editZMax,'String'));

elseif strcmpi(parameter,'ZMin')
    val = handles.const.Stage.ZMin;
    
elseif strcmpi(parameter,'ZPos')
    val = str2double(get(handles.editZPos,'String'));
    
elseif strcmpi(parameter,'ZStep')
    val = handles.Stage.ZStep;
    
elseif strcmpi(parameter,'Encoder')
    val = get(handles.txtEncoderReadout,'String');
    
elseif strcmpi(parameter,'XMax')
%     val = handles.const.Stage.XMax;
    val = str2double(get(handles.editXMax,'String'));
    
elseif strcmpi(parameter,'XMin')
    val = handles.const.Stage.XMin;
    
elseif strcmpi(parameter,'XPos')
    val = str2double(get(handles.editXPos,'String'));
    
elseif strcmpi(parameter,'XStep')
    val = handles.Stage.XStep;
    
elseif strcmpi(parameter,'YMax')
%     val = handles.const.Stage.YMax;
    val = str2double(get(handles.editYMax,'String'));
    
elseif strcmpi(parameter,'YMin')
    val = handles.const.Stage.YMin;
    
elseif strcmpi(parameter,'YPos')
    val = str2double(get(handles.editYPos,'String'));
    
elseif strcmpi(parameter,'YStep')
    val = handles.Stage.YStep;
    
elseif strcmpi(parameter,'MirrorEnable')
    val = handles.chkEnabledMirror;
    %     val = get(handles.chkEnabledMirror,'Value');
    
elseif strcmpi(parameter,'MirrorFile')
    %temp = get(handles.popupValueMirror,'Value');
    %str = get(handles.popupValueMirror,'String');
    %val = str{1};
    temp = get(handles.popupValueMirror,'Value');
    % there's two popups with the same tag, use the first, 
    val = temp{1};
    
elseif strcmpi(parameter,'DwellTime')
    val = handles.dwellTime;
    %     val = str2double(get(handles.editDwell,'String'));
    
elseif strcmpi(parameter,'Instrument_fit')
    temp = get(handles.popupFittingInstrument,'Value');
    val = handles.const.available_instr{temp};
    
elseif strcmpi(parameter,'FitMethod')
    temp = get(handles.popupFittingMethod,'Value');
    str = get(handles.popupFittingMethod,'String');
    val = str(temp);
    
elseif strcmpi(parameter,'Magnification')
    val = handles.const.Magnification;
    
elseif strcmpi(parameter,'PixelSize')
    val = handles.const.Camera.PixelSize;
    
elseif strcmpi(parameter,'DiffResolution')
    val = handles.const.DiffResolution;
    
elseif strcmpi(parameter,'MinimapSize')
    val = handles.const.minimapSize;
    
elseif strcmpi(parameter,'NA')
    val = handles.const.NA;
    
elseif strcmpi(parameter,'ZOffset')
    val = handles.const.Stage.ZOffset;
    
elseif strcmpi(parameter,'EffPixel')
    val = handles.const.Camera.EffPixel;
    
elseif strcmpi(parameter,'FOV') %[Y X]
    val = handles.const.Camera.FOV;
    
elseif strcmpi(parameter,'loadGIF')
    val = handles.const.loadgif;
    
elseif strcmpi(parameter,'adjustGIF')
    val = handles.const.adjustgif;

elseif strcmpi(parameter,'focusImage')
    val = handles.const.focusImage;
    
elseif strcmpi(parameter,'MainImageContrast')
    val = str2double(get(handles.editMainImageContrast,'String'));

elseif strcmpi(parameter,'MinimapContrast')
    val = str2double(get(handles.editMinimapContrast,'String'));

elseif strcmpi(parameter,'ZOffset')
    val = str2double(get(handles.editZOffset,'String'));
    
elseif strcmpi(parameter,'Minimap')
    val = handles.Minimap.data;
    
elseif strcmpi(parameter,'MinimapPlaceholder')
    val = handles.Minimap.placeholder;
    
elseif strcmpi(parameter,'MinimapImageNumber')
    val = handles.Minimap.numImages;
        
elseif strcmpi(parameter,'MinimapSamplingSize')
    val = handles.Minimap.samplingSize;
    
elseif strcmpi(parameter,'StageToMinimapConversion')
    val = handles.Minimap.conversion;
    
elseif strcmpi(parameter,'MaxPixels')
    val = handles.const.Camera.MaxPixels;
    
elseif strcmpi(parameter,'Comment')
    val = get(handles.editComment,'String');
    
elseif strcmpi(parameter,'CurrentFileGroup')
    currentList = getParams(handles,'FileGroups');
    currentIndex = get(handles.popupFiles,'Value');
        
    if currentIndex == 0
        currentIndex = 'None';
        [handles] = setParams(handles,'FileGroups',currentIndex);
    end
    val = [handles.const.DataSetString currentList{currentIndex}];
    
elseif strcmpi(parameter,'CurrentFile')
    val = get(handles.sldSelectedFile,'Value');
    
elseif strcmpi(parameter,'PrescanFile')
 val = handles.PrescanFile;

elseif strcmpi(parameter,'PostscanFile')
 val = handles.PostscanFile;

elseif strcmpi(parameter,'CurrentFilePath')
    fileNameList = getParams(handles,'fileNameList');
    currentLocation = getParams(handles,'CurrentFileGroup');
    temp = getParams(handles,'CurrentFile');
    if isfield(fileNameList,currentLocation)
        val = fileNameList.(currentLocation).full_path_data{temp};
    else
        val = 'None';
    end
    
elseif strcmpi(parameter,'CurrentFileGroupTotal')
    val = get(handles.sldSelectedFile,'Max');

elseif strcmpi(parameter,'MinimapPath')
    fileNameList = getParams(handles,'fileNameList');
    currentLocation = getParams(handles,'CurrentFileGroup');
    temp = getParams(handles,'CurrentFile');
    if isfield(fileNameList,currentLocation)
        val = fileNameList.(currentLocation).full_path_minimap{temp};
    else
        val = 'None';
    end
    
elseif strcmpi(parameter,'FileGroups')
    val = get(handles.popupFiles,'String');
    
elseif strcmpi(parameter,'FileNameList')
    if ~isfield(handles.data,'fileNameList')
        handles.data.fileNameList = struct();
    end
    val = handles.data.fileNameList;
    
elseif strcmpi(parameter,'MirrorList')
    if ~isfield(handles.data,'mirrorlist')
        handles.data.mirrorlist = struct();
    end
    val = handles.data.mirrorlist;
    
elseif strcmpi(parameter,'CurrentMirrorFile')
    str = get(handles.popupValueMirror,'String');
    %temp = get(handles.popupValueMirror,'Value');
    val = str{1};
    
elseif strcmpi(parameter,'MirrorVar')
    if ~isfield(handles.data,'mirrorVar')
        handles.data.mirrorVar = struct();
    end
    val = handles.data.mirrorVar;
    
elseif strcmpi(parameter,'DataVar')
    if ~isfield(handles.data,'dataVar')
        handles.data.dataVar = struct();
    end
    val = handles.data.dataVar;
    
elseif strcmpi(parameter,'IntensityValue')
    val = get(handles.radIntensity,'Value');
    
elseif strcmpi(parameter,'ConstrastValue')
    val = get(handles.radContrast,'Value');
    
elseif strcmpi(parameter,'ProcessValue')
    val = get(handles.radProcess,'Value');
    
elseif strcmpi(parameter,'IntensityVisible')
    val = get(handles.radIntensity,'Visble');
    
elseif strcmpi(parameter,'ConstrastVisible')
    val = get(handles.radContrast,'Visble');
    
elseif strcmpi(parameter,'ProcessVisible')
    val = get(handles.radProcess,'Visble');
    
elseif strcmpi(parameter,'MainPlotType')
    val = handles.GUI.plotmain;

elseif strcmpi(parameter,'CameraStatus')
%     val = CAMERA_CONTROL_RESPONSE(handles.camera,);

elseif strcmpi(parameter,'CameraPreviewStatus')
    val = handles.Status.Camera.Preview;

elseif strcmpi(parameter,'RefParticleStatus')
    val = handles.Status.RefParticle;
    
elseif strcmpi(parameter,'SystemStatus')
    val = handles.Status.System;
    
elseif strcmpi(parameter,'ChipLoadStatus')
    val = handles.Status.Chip.Load;

elseif strcmpi(parameter,'StageInitStatus')
    val = handles.Status.Stage.Init;

elseif strcmpi(parameter,'StageHomeStatus')
    val = handles.Status.Stage.Home;
    
elseif strcmpi(parameter,'StageLoadPos')
    val = handles.const.Stage.Load; % [X Y Z]
        
elseif strcmpi(parameter,'StageHomePos')
    val = handles.const.Stage.Home + [getParams(handles,'ChipOffset') 0]; % [X Y Z]
        
elseif strcmpi(parameter,'MinimapStartPos')
    val = handles.const.Stage.Minimap + getParams(handles,'ChipOffset'); % [X Y]
    
elseif strcmpi(parameter,'FocusPos')
    val = handles.Stage.FC.Pos; %[X Y Z]

elseif strcmpi(parameter,'LogoPos')
    val = handles.Stage.Logo.Pos; %[X Y Z]
    
elseif strcmpi(parameter,'AllLogoPos')
    val = handles.Stage.Logo.AllPos; %[X Y Z]
    
elseif strcmpi(parameter,'ChipOffset')
    val = handles.const.chipOffset; %[X Y]

elseif strcmpi(parameter,'ParticleOffset')
    val = handles.const.particleOffset; %[Z]
    
elseif strcmpi(parameter,'PlaneCoeff')
    val = handles.Stage.PlaneCoefficients;
    
elseif strcmpi(parameter,'AlignmentDate')
    val = handles.Stage.AlignmentDate;
    
elseif strcmpi(parameter,'AlignmentType')
    val = handles.Stage.AlignmentType;
    
elseif strcmpi(parameter,'Alignment')
    val= getParams(handles,'PlaneCoeff');
    disp(['Alignment - ' getParams(handles,'AlignmentType')...
        ' - ' getParams(handles,'AlignmentDate')]);
    
    plane_string= ['dz/dx: ' num2str(val(1)) ' - dz/dy: ' num2str(val(2)) ' - C: ' num2str(val(3))]; 
    disp(['Current Plane - ' plane_string]);
    
    FC_pos = getParams(handles,'FocusPos');
%     FC_origin_string = ['[' num2str(FC_pos{1}(1)) ',' num2str(FC_pos{1}(2)) ',' num2str(FC_pos{1}(3)) ']'];
%     
%     disp(['Saved Array Origin - ' num2str(FC_origin_string)]);
        
    
    
elseif strcmpi(parameter,'Backlash')
    val = handles.Stage.Backlash;

elseif strcmpi(parameter,'SmartMove')
    val = get(handles.chkSmartMove,'Value');

elseif strcmpi(parameter,'IntensityTh')
    val = str2double(get(handles.editIntensityTh,'String'));
    
elseif strcmpi(parameter,'EdgeTh')
    val = str2double(get(handles.editEdgeTh,'String'));

elseif strcmpi(parameter,'TemplateSize')
    val = str2double(get(handles.editTemplateSize,'String'));

elseif strcmpi(parameter,'SD')
    val = str2double(get(handles.editSD,'String'));

elseif strcmpi(parameter,'GaussianTh')
    val = str2double(get(handles.editGaussianTh,'String'));
    
elseif strcmpi(parameter,'InnerRadius')
    val = str2double(get(handles.editInnerRadius,'String'));

elseif strcmpi(parameter,'OuterRadius')
    val = str2double(get(handles.editOuterRadius,'String'));
    
elseif strcmpi(parameter,'SoftwareVersion')
    val = handles.const.version;
    
elseif strcmpi(parameter,'CameraPointers')
    val = handles.Camera;
    
elseif strcmpi(parameter,'StagePointers')
    val = handles.Stage;

elseif strcmpi(parameter,'Binning')
    val = handles.Camera.Binning;
    
elseif strcmpi(parameter,'MaxHist')
    val = str2double(get(handles.editMaxHist,'String'));

elseif strcmpi(parameter,'RefMaxHist')
    val = str2double(get(handles.editRefMaxHist,'String'));
    
elseif strcmpi(parameter,'MinHist')
    val = str2double(get(handles.editMinHist,'String'));

elseif strcmpi(parameter,'RefMinHist')
    val = str2double(get(handles.editRefMinHist,'String'));
    
elseif strcmpi(parameter,'HistBin')
    val = str2double(get(handles.editHistBins,'String'));
    
elseif strcmpi(parameter,'BtnState')
    val = handles.Status.btns;

elseif strcmpi(parameter,'Instrument')
    val = handles.const.instrument;
    
elseif strcmpi(parameter,'EnableStages')
    val = handles.const.EnableStages;

elseif strcmpi(parameter,'LEDControl')
    val = handles.const.LEDControl;
    
elseif strcmpi(parameter,'StageType')
    val = handles.const.StageType;
    
elseif strcmpi(parameter,'ZVelocity')
    if(isfield(handles.const.Stage,'ZVelocity'))
        val = handles.const.Stage.ZVelocity;
    else
        val= STAGE_getVelocityAxis(handles.Stage,handles.Stage.axis.z);
    end
    
elseif strcmpi(parameter,'XYVelocity')
    
  
    if(isfield(handles.const.Stage,'XYVelocity'))
        val = handles.const.Stage.XYVelocity;
    else
        val= STAGE_getVelocityAxis(handles.Stage,handles.Stage.axis.x);
    end
    
else
    msg = ['Incorrect parameter give to getParams: ' parameter];
    [handles] = GUI_logMsg(handles,msg,handles.const.log.parameter,handles.txtLog,2);
end
 