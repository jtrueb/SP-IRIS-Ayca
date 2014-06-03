function [handles] = setParams(handles,parameter,val)
feedbackLvl = 2;
errorFlag = 0;

if strcmpi(parameter,'Directory');
    if ~isempty(val)
        if exist(val,'dir')~=7
            ans = questdlg('Folder does not exist. Create folder?','Save Folder','Yes','No','No');
            if strcmpi(ans,'Yes')
                mkdir(val);
                handles.data.saveFolder = val;
                msg = ['Directory set - ' val];
            else
                msg = 'Directory reset';
                errorFlag = 1;
            end
        else
            handles.data.saveFolder = val;
            msg = ['Directory set - ' val];
        end
        set(handles.txtValueSaveFolder,'String',handles.data.saveFolder);
        [handles] = DATA_refreshFileList(handles); %update file list
    else
        msg = 'No directory provided';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MirrorDirectory')
    if ~isfield(handles.data,'mirrorFolder')
        handles.data.mirrorFolder = handles.const.directories.matlab;
    end
    
    if ~isempty(val)
        if exist(val,'dir')~=7
            msg = 'Directory does not exist. MirrorDirectory not changed.';
        else
            handles.data.mirrorFolder = val;
            msg = ['MirrorDirectory set - ' val];
        end
        [handles] = DATA_PopulateMirror(handles);
    else
        msg = 'No directory provided';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'popupChipInfo_Directory');
    feedbackLvl = -1;
    if ~isempty(val)
        if exist(val,'dir')~=7
            ans = questdlg('Folder does not exist. Create folder?','Save Folder','Yes','No','No');
            if strcmpi(ans,'Yes')
                mkdir(val);
                handles.data.saveFolder = val;
                msg = ['Directory set - ' val];
            else
                msg = 'Directory reset';
                errorFlag = 1;
            end
        else
            handles.data.saveFolder = val;
            msg = ['Directory set - ' val];
        end
        set(handles.txtValueSaveFolder,'String',handles.data.saveFolder);
    else
        msg = 'No directory provided';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Mode')
    if ischar(val)
        if strcmpi(val,'offline') || strcmpi(val,'off')
            handles.mode = 0;
            msg = 'Mode set to offline';
            errorFlag = 1;
        elseif strcmpi(val,'online') || strcmpi(val,'on')
            handles.mode = 1;
            msg = 'Mode set to online';
        else
            msg = 'Mode must be on or off';
            errorFlag = 1;
        end
    elseif isfloat(val)
        if val == 0
            handles.mode = val;
            msg = 'Mode set to offline';
            errorFlag = 1;
        elseif val == 1
            handles.mode = val;
            msg = 'Mode set to online';
            errorFlag = 2;
        else
            msg = 'Mode must be a 1 or 0';
            errorFlag = 1;
        end
    else
        msg = 'Mode must be a string or integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ChipID')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editChipID,'String',int2str(val));
        msg = ['ChipID set - ' num2str(val)];
    elseif ischar(val)
        set(handles.editChipID,'String',val);
        msg = ['ChipID set - ' val];
    end
    
elseif strcmpi(parameter,'ChipType')
    if isfloat(val)
        set(handles.popupChipType,'Value',val);
        Pos = getParams(handles,'AllLogoPos');
        str = handles.const.ChipType;
        if strcmpi(str{val},'V1')
            [handles] = setParams(handles,'LogoPos',Pos(1:3));
        elseif strcmpi(str{val},'V2')
            [handles] = setParams(handles,'LogoPos',Pos(4:6));
        end
        msg = ['ChipType set - ' str{val}];
    elseif ischar(val)
        temp = find(ismember(handles.const.ChipType,val)==1);
        Pos = getParams(handles,'AllLogoPos');
        set(handles.popupChipType,'Value',temp);
        
        if strcmpi(val,'V1')
            [handles] = setParams(handles,'LogoPos',Pos(1:3));
        elseif strcmpi(val,'V2')
            [handles] = setParams(handles,'LogoPos',Pos(4:6));
        end
        msg = ['ChipType set - ' val];
    else
        msg = 'ChipType must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ArrayX')
    feedbackLvl = -1;
    if isfloat(val)
        if isnan(val)
            val = get(handles.editArrayX,'String');
        end
        set(handles.editArrayX,'String',int2str(roundn(val,-3)));
        msg = ['ArrayX set - ' num2str(roundn(val,-3))];
        
        ArrayY = getParams(handles,'ArrayY');
        [handles] = setParams(handles,'ArrayTotal',val*ArrayY);
    else
        msg = 'ArrayX must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ArrayY')
    feedbackLvl = -1;
    if isfloat(val)
        if isnan(val)
            val = get(handles.editArrayY,'String');
        end
        set(handles.editArrayY,'String',int2str(roundn(val,-3)));
        msg = ['ArrayY set - ' num2str(roundn(val,-3))];
        
        ArrayX = getParams(handles,'ArrayX');
        [handles] = setParams(handles,'ArrayTotal',val*ArrayX);
    else
        msg = 'ArrayY must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ArraySize')
    if isfloat(val)
        if size(val,2)==2
            [handles] = setParams(handles,'ArrayX',val(1));
            [handles] = setParams(handles,'ArrayY',val(2));
            msg = ['ArraySize set - ' num2str(val)];
        else
            msg = 'ArraySize must be 2 integers [ArrayX ArrayY]';
        end
    else
        msg = 'ArraySize must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ArrayTotal')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.arrayTotal = val;
        msg = ['ArrayTotal set - ' num2str(val)];
        [handles] = GUI_logSpotNum(handles,1,val);
    else
        msg = 'ArrayTotal must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ArrayOffset')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.arrayOffset = val;
        msg = ['ArrayOffset set - ' num2str(val)];
    else
        msg = 'ArrayOffset must be an integer';
    end
    
elseif strcmpi(parameter,'RowOffset')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.rowOffset = val;
        msg = ['RowOffset set'];
    else
        msg = 'RowOffset must be an integer';
    end
    
elseif strcmpi(parameter,'PitchX')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editArrayPitchX,'String',num2str(roundn(val,-3)));
        msg = ['PitchX set - ' num2str(roundn(val,-3))];
    else
        msg = 'PitchX must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'PitchY')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editArrayPitchY,'String',num2str(roundn(val,-3)));
        msg = ['PitchY set - ' num2str(roundn(val,-3))];
    else
        msg = 'PitchY must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'StageHomePos')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 3
            handles.const.Stage.Home = val; %[um] [X Y Z]
            msg = 'StageHomePos set';
        else
            msg = 'StageHomePos must be [X Y Z]';
            errorFlag = 1;
        end
    else
        msg = 'StageHomePos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'StageLoadPos')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 3
            handles.const.Stage.Load = val; %[um] [X Y Z]
            msg = 'StageLoadPos set';
        else
            msg = 'StageLoadPos must be [X Y Z]';
            errorFlag = 1;
        end
    else
        msg = 'StageLoadPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapStartPos')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            handles.const.Stage.Minimap = val; %[um] [X Y]
            msg = 'MinimapStartPos set';
        else
            msg = 'MinimapStartPos must be [X Y]';
            errorFlag = 1;
        end
    else
        msg = 'MinimapStartPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Stage_XYIndex')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            [handles] = setParams(handles,'PitchX',val(1));
            [handles] = setParams(handles,'PitchY',val(2));
            msg = ['Stage_XYIndex set - ' num2str(val)];
        else
            msg = 'Stage_XYIndex must include an array of [X Y]';
            errorFlag = 1;
        end
    else
        msg = 'Stage_XYIndex must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Stage_XYPos')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            [handles] = setParams(handles,'XPos',val(1));
            [handles] = setParams(handles,'YPos',val(2));
            msg = ['Stage_XYPos set - ' num2str(val)];
        else
            msg = 'Stage_XYPos must include an array of [X Y]';
            errorFlag = 1;
        end
    else
        msg = 'Stage_XYPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Stage_Pos')
    if isfloat(val)
        if size(val,2) == 3
            [handles] = setParams(handles,'XPos',val(1));
            [handles] = setParams(handles,'YPos',val(2));
            [handles] = setParams(handles,'ZPos',val(3));
            msg = ['Stage_Pos set - ' num2str(val)];
        else
            msg = 'Stage_Pos must include an array of [X Y Z]';
            errorFlag = 1;
        end
    else
        msg = 'Stage_Pos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ParticleType')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.popupSelectParticle,'Value',val);
        set(handles.popupProcessSelectParticle,'Value',val);
        str = handles.const.ParticleType;
        if strcmpi(str{val},'AgNP')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.2);
            [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(str{val},'AuNP')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.2);
            [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(str{val},'Virus')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.05);
            [handles] = setParams(handles,'ParticleOffset',0);
        end
        msg = ['Particle type set - ' str{val}];
    elseif ischar(val)
        temp = find(ismember(handles.const.ParticleType,val)==1);
        set(handles.popupSelectParticle,'Value',temp);
        set(handles.popupProcessSelectParticle,'Value',temp);
        if strcmpi(val,'AgNP')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.2);
            [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(val,'AuNP')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.2);
            [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(val,'Virus')
            [handles] = setParams(handles,'LED','L2');
            [handles] = setParams(handles,'IntensityTh',0.05);
            [handles] = setParams(handles,'ParticleOffset',0);
        end
        msg = ['Particle type set - ' val];
    else
        msg = 'Particle type must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'RefParticleType')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.popupSelectRefParticle,'Value',val);
        set(handles.popupProcessSelectRefParticle,'Value',val);
        str = handles.const.ParticleType;
        if strcmpi(str{val},'AgNP')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.2);
            %             [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(str{val},'AuNP')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.2);
            %             [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(str{val},'Virus')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.5);
            %             [handles] = setParams(handles,'ParticleOffset',0);
        end
        msg = ['Particle type set - ' str{val}];
    elseif ischar(val)
        temp = find(ismember(handles.const.ParticleType,val)==1);
        set(handles.popupSelectRefParticle,'Value',temp);
        set(handles.popupProcessSelectRefParticle,'Value',temp);
        if strcmpi(val,'AgNP')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.2);
            %             [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(val,'AuNP')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.2);
            %             [handles] = setParams(handles,'ParticleOffset',-0.5);
        elseif strcmpi(val,'Virus')
            %             [handles] = setParams(handles,'LED','L2');
            %             [handles] = setParams(handles,'IntensityTh',0.5);
            %             [handles] = setParams(handles,'ParticleOffset',0);
        end
        msg = ['Ref Particle type set - ' val];
    else
        msg = 'Ref Particle type must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ScanType')
    feedbackLvl = -1;
    if ischar(val)
        if strcmpi(val,'Prescan')
            set(handles.radPrescan,'Value',1);
            set(handles.radPostscan,'Value',0);
        elseif strcmpi(val,'Postscan')
            set(handles.radPrescan,'Value',0);
            set(handles.radPostscan,'Value',1);
        end
        msg = ['ScanType set - ' val];
    else
        msg = 'ScanType must be Prescan or Postscan';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Camera')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.popupSelectCamera,'Value',val);
        str = handles.const.Camera.Names;
        msg = ['Camera set - ' str{val}];
    elseif ischar(val)
        temp = find(ismember(handles.const.Camera.Names,val)==1);
        set(handles.popupSelectCamera,'Value',temp);
        msg = ['Camera set - ' val];
    else
        msg = 'Camera must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Exposure')
    if val > handles.const.Camera.MaxExp
        msg = 'Exposure exceeds maximum exposure time. Value set to maximum.';
        val = handles.const.Camera.MaxExp;
        errorFlag = 1;
    elseif val < handles.const.Camera.MinExp
        msg = 'Exposure exceeds minimum exposure time. Value set to minimum.';
        val = handles.const.Camera.MinExp;
        errorFlag = 1;
    else
        msg = ['Exposure set - ' num2str(val)];
    end
    set(handles.editScanExposure,'String',num2str(val));
    
elseif strcmpi(parameter,'PreviewExposure')
    feedbackLvl = -1;
    if val > handles.const.Camera.MaxExp
        msg = 'PreviewExposure exceeds maximum exposure time. Value set to maximum.';
        val = handles.const.Camera.MaxExp;
        errorFlag = 1;
    elseif val < handles.const.Camera.MinExp
        msg = 'PreviewExposure exceeds minimum exposure time. Value set to minimum.';
        val = handles.const.Camera.MinExp;
        errorFlag = 1;
    else
        msg = ['PreviewExposure set - ' num2str(val)];
    end
    handles.const.Camera.PreviewExposure = val;
    
elseif strcmpi(parameter,'MaxExposure')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.MaxExp = val;
        set(handles.txtMaxExp,'String',['Maximum Exposure [ms] - ' num2str(val)]);
        msg = ['Maximum Exposure set - ' num2str(val)];
    else
        msg = 'Maximum Exposure must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinExposure')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.MinExp = val;
        set(handles.txtMinExp,'String',['Minimum Exposure [ms] - ' num2str(val)]);
        msg = ['Minimum Exposure set - ' num2str(val)];
    else
        msg = 'Minimum Exposure must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FPS_base')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.FPS_base = val;
        [handles] = setParams(handles,'FPS',val);
        set(handles.txtFPS,'String',['Camera FPS_base - ' num2str(val)]);
        msg = ['FPS_base set - ' num2str(val)];
    else
        msg = 'FPS_base must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FPS')
    feedbackLvl = 1;
    if isfloat(val)
        handles.const.Camera.FPS = val;
        set(handles.txtFPS,'String',['Camera FPS - ' num2str(val)]);
        msg = ['FPS set - ' num2str(val)];
    else
        msg = 'FPS must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'BitDepth')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.BitDepth = val;
        set(handles.txtBitDepth,'String',['Camera BitDepth - ' int2str(val)]);
        msg = ['FPS set - ' num2str(val)];
    else
        msg = 'FPS must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ROIstep')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.ROIstep = val;
        set(handles.txtROIstep,'String',['ROI must step by - ' int2str(val)]);
        msg = ['ROIstep set - ' num2str(val)];
    else
        msg = 'ROIstep must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ScanAvg')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editScanAvg,'String',int2str(roundn(val,-3)));
        msg = ['ScanAvg set - ' num2str(roundn(val,-3))];
    else
        msg = 'ScanAvg must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ROI')
    if isfloat(val)
        if size(val,2) == 4
            [handles] = setParams(handles,'Height',val(3));
            [handles] = setParams(handles,'Width',val(4));
            [handles] = setParams(handles,'yOffset',val(1));
            [handles] = setParams(handles,'xOffset',val(2));
            
            %Calculate new FPS
            maxPixels = getParams(handles,'MaxPixels');
            fps_base = getParams(handles,'FPS_base');
            ratio_ROI = prod(maxPixels./[val(3) val(4)],2);
            fps = floor(fps_base.*ratio_ROI);
            %if (fps > 300)
            %    fps = 300;
            %end
            [handles] = setParams(handles,'FPS',fps);
            
            msg = ['ROI set - [' int2str(val(1)) ' ' int2str(val(2)) ' '...
                int2str(val(3)) ' ' int2str(val(4)) ']'];
        else
            msg = 'ROI must specify [yOffset xOffset Height Width]';
        end
    else
        msg = 'ROI must be an integer';
    end
elseif strcmpi(parameter,'Width')
    feedbackLvl = -1;
    if isfloat(val)
        MaxPixels = getParams(handles,'MaxPixels');
        if val > MaxPixels(2)
            val = MaxPixels(2);
            msg = ['Width exceeds camera sensor size. Value set to maximum (' int2str(val) ')'];
            errorFlag = 1;
        elseif val < 0
            val = getParams(handles,'ROIstep');
            msg = ['Width must be a positive integer. Value set to minimum (' int2str(val) ')'];
            errorFlag = 1;
        else
            ROIstep = getParams(handles,'ROIstep');
            val = floor(val/ROIstep)*ROIstep;
            msg = ['Width set - ' num2str(val)];
        end
        set(handles.editScanROIX,'String',int2str(val));
        handles.const.Camera.ROI(4) = val;
    else
        msg = 'Width must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Height')
    feedbackLvl = -1;
    if isfloat(val)
        MaxPixels = getParams(handles,'MaxPixels');
        if val > MaxPixels(1)
            val = MaxPixels(1);
            msg = ['Height exceeds camera sensor size. Value set to maximum (' int2str(val) ')'];
            errorFlag = 1;
        elseif val < 0
            val = getParams(handles,'ROIstep');
            msg = ['Height must be a positive integer. Value set to minimum (' int2str(val) ')'];
            errorFlag = 1;
        else
            ROIstep = getParams(handles,'ROIstep');
            val = floor(val/ROIstep)*ROIstep;
            msg = ['Height set - ' num2str(val)];
        end
        set(handles.editScanROIY,'String',int2str(val));
        handles.const.Camera.ROI(3) = val;
    else
        msg = 'Height must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'xOffset')
    feedbackLvl = -1;
    if isfloat(val)
        MaxPixels = getParams(handles,'MaxPixels');
        if (val+getParams(handles,'Width')) > MaxPixels(2)
            val = getParams(handles,'xOffset');
            msg = 'xOffset exceeds camera sensor size. xOffset not changed';
            errorFlag = 1;
        elseif val < 0
            val = getParams(handles,'xOffset');
            msg = 'xOffset must be a positive integer. xOffset not changed';
            errorFlag = 1;
        else
            ROIstep = getParams(handles,'ROIstep');
            val = floor(val/ROIstep)*ROIstep;
            msg = ['xOffset set - ' num2str(val)];
        end
        set(handles.editScanOffsetX,'String',int2str(val));
        handles.const.Camera.ROI(2) = val;
    else
        msg = 'xOffset must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'yOffset')
    feedbackLvl = -1;
    if isfloat(val)
        MaxPixels = getParams(handles,'MaxPixels');
        if (val+getParams(handles,'Height') > MaxPixels(1))
            val = getParams(handles,'yOffset');
            msg = 'yOffset exceeds camera sensor size. yOffset not changed';
            errorFlag = 1;
        elseif val < 0
            val = getParams(handles,'yOffset');
            msg = 'yOffset must be a positive integer. yOffset not changed';
            errorFlag = 1;
        else
            ROIstep = getParams(handles,'ROIstep');
            val = floor(val/ROIstep)*ROIstep;
            msg = ['yOffset set - ' num2str(val)];
        end
        set(handles.editScanOffsetY,'String',int2str(val));
        handles.const.Camera.ROI(1) = val;
    else
        msg = 'yOffset must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'LED')
    feedbackLvl = -1;
    
    if ischar(val)
        set(handles.radioLED1,'Value',0);
        set(handles.radioLED2,'Value',0);
        set(handles.radioLED3,'Value',0);
        set(handles.radioLED4,'Value',0);
        
        if strcmpi(val,'L1')
            set(handles.radioLED1,'Value',1);
            msg = 'LED1 enabled';
        elseif strcmpi(val,'L2')
            set(handles.radioLED2,'Value',1);
            msg = 'LED2 enabled';
        elseif strcmpi(val,'L3')
            set(handles.radioLED3,'Value',1);
            msg = 'LED3 enabled';
        elseif strcmpi(val,'L4')
            set(handles.radioLED4,'Value',1);
            msg = 'LED4 enabled';
        else
            msg = 'Invalid LED';
            errorFlag = 1;
        end
    else
        msg = 'LED must be a string';
        errorFlag = 1;
    end
    
    [handles] = setParams(handles,'DiffResolution',handles.const.NA);
    
elseif strcmpi(parameter,'numCorners')
    feedbackLvl = -1;
    if isfloat(val)
        if val == 3
            set(handles.rad3Corner,'Value',1);
            set(handles.rad4Corner,'Value',0);
            msg = '3Corner focus enabled';
        elseif val == 4
            set(handles.rad3Corner,'Value',0);
            set(handles.rad4Corner,'Value',1);
            msg = '4Corner focus enabled';
        else
            msg = ['Invalid option to numCorners - ' num2str(val)];
            errorFlag = 1;
        end
    else
        msg = 'numCorners must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ZMax')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editZMax,'String',num2str(val));
        handles.const.Stage.ZMax = val;
        msg = ['ZMax set - ' num2str(val)];
    else
        msg = 'ZMax must be an integer';
        errorFlag = 1;
    end
elseif strcmpi(parameter,'ZMin')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Stage.ZMin = val;
        msg = ['ZMin set - ' num2str(val)];
    else
        msg = 'ZMin must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ZOffset')
    if isfloat(val)
        set(handles.editZOffset,'String',num2str(val));
        handles.const.Stage.ZOffset = val;
        msg = ['ZOffset set - ' num2str(val)];
    else
        msg = 'ZOffset must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ZPos')
    if isfloat(val)
        if ~isfield(handles.Stage,'ZPos')
            handles.Stage.ZPos = roundn(val,-2);
        end
        ZMax = getParams(handles,'ZMax');
        ZMin = getParams(handles,'ZMin');
        
        if val > ZMax
            msg = ['Cannot set ZPos above threshold - '...
                num2str(ZMax) '. ZPos not changed'];
            errorFlag = 1; feedbackLvl = 1;
            
        elseif val < ZMin
            msg = ['Cannot set ZPos below threshold - '...
                num2str(ZMin) '. ZPos not changed'];
            errorFlag = 1; feedbackLvl = 1;
            
        else
            STAGE_move(handles.Stage,{handles.Stage.axis.z},val,...
                handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
            handles.Stage.ZPos = roundn(val,-2);
            msg = ['ZPos set - ' num2str(handles.Stage.ZPos)];
        end
        set(handles.editZPos,'String',num2str(handles.Stage.ZPos));
    else
        msg = 'ZPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ZStep')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Stage.ZStep = roundn(val,-3);
        msg = ['ZStep set - ' num2str(handles.Stage.ZStep)];
        set(handles.editZStep,'String',num2str(handles.Stage.ZStep));
    else
        msg = 'ZStep must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Encoder')
    feedbackLvl = -1;
    set(handles.txtEncoderReadout,'String',num2str(val));
    
elseif strcmpi(parameter,'XMax')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Stage.XMax = val;
        set(handles.editXMax,'String',num2str(val));
        msg = ['XMax set - ' num2str(val)];
    else
        msg = 'XMax must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'XMin')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Stage.XMin = val;
        msg = ['XMin set - ' num2str(val)];
    else
        msg = 'XMin must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'XPos')
    if isfloat(val)
        if ~isfield(handles.Stage,'XPos')
            handles.Stage.XPos = val;
        end
        XMax = getParams(handles,'XMax');
        XMin = getParams(handles,'XMin');
        
        if val > XMax
            msg = ['Cannot set XPos above threshold - '...
                num2str(XMax) '. XPos not changed'];
            errorFlag = 1; feedbackLvl = 1;
            
        elseif val < XMin
            msg = ['Cannot set XPos below threshold - '...
                num2str(XMin) '. XPos not changed'];
            errorFlag = 1; feedbackLvl = 1;
        else
            STAGE_move(handles.Stage,{handles.Stage.axis.x},val,...
                handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
            handles.Stage.XPos = roundn(val,0);
            msg = ['XPos set - ' num2str(handles.Stage.XPos)];
        end
        set(handles.editXPos,'String',num2str(handles.Stage.XPos));
    else
        msg = 'XPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'XStep')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Stage.XStep = roundn(val,-3);
        msg = ['XStep set - ' num2str(handles.Stage.XStep)];
    else
        msg = 'XStep must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'YMax')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Stage.YMax = val;
        set(handles.editYMax,'String',num2str(val));
        msg = ['YMax set - ' num2str(val)];
    else
        msg = 'YMax must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'YMin')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Stage.YMin = val;
        msg = ['YMin set - ' num2str(val)];
    else
        msg = 'YMin must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'YPos')
    if isfloat(val)
        if ~isfield(handles.Stage,'YPos')
            handles.Stage.YPos = val;
        end
        YMax = getParams(handles,'YMax');
        YMin = getParams(handles,'YMin');
        if val > YMax
            msg = ['Cannot set YPos above threshold - '...
                num2str(YMax) '. YPos not changed'];
            handles.Stage.YPos = YMax;
            errorFlag = 1; feedbackLvl = 1;
            
        elseif val < YMin
            msg = ['Cannot set YPos below threshold - '...
                num2str(YMin) '. YPos not changed'];
            errorFlag = 1; feedbackLvl = 1;
        else
            STAGE_move(handles.Stage,{handles.Stage.axis.y},val,...
                handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
            handles.Stage.YPos = roundn(val,0);
            msg = ['YPos set - ' num2str(handles.Stage.YPos)];
        end
        set(handles.editYPos,'String',num2str(handles.Stage.YPos));
    else
        msg = 'YPos must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'YStep')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Stage.YStep = roundn(val,-3);
        msg = ['YStep set - ' num2str(handles.Stage.YStep)];
    else
        msg = 'YStep must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MoveType')
    feedbackLvl = -1;
    if isfloat(val)
        if val == 1
            set(handles.radUser,'Value',1);
            set(handles.radFOV,'Value',0);
            set(handles.radPitch,'Value',0);
            msg = 'MoveType: User';
        elseif val == 2
            set(handles.radUser,'Value',0);
            set(handles.radFOV,'Value',1);
            set(handles.radPitch,'Value',0);
            msg = 'MoveType: FOV';
        elseif val == 3
            set(handles.radUser,'Value',0);
            set(handles.radFOV,'Value',0);
            set(handles.radPitch,'Value',1);
            msg = 'MoveType: Pitch';
        else
            msg = ['Invalid option to MoveType - ' num2str(val)];
            errorFlag = 1;
        end
    elseif ischar(val)
        if strcmpi(val,'User')
            set(handles.radUser,'Value',1);
            set(handles.radFOV,'Value',0);
            set(handles.radPitch,'Value',0);
            msg = 'MoveType: User';
        elseif strcmpi(val,'FOV')
            set(handles.radUser,'Value',0);
            set(handles.radFOV,'Value',1);
            set(handles.radPitch,'Value',0);
            msg = 'MoveType: FOV';
        elseif strcmpi(val,'Pitch')
            set(handles.radUser,'Value',0);
            set(handles.radFOV,'Value',0);
            set(handles.radPitch,'Value',1);
            msg = 'MoveType: Pitch';
        else
            msg = ['Invalid option to MoveType - ' val];
            errorFlag = 1;
        end
    else
        msg = 'MoveType must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MirrorEnable')
    feedbackLvl = -1;
    if isfloat(val)
        if val > 0
            handles.chkEnabledMirror = 1;
            msg = 'Mirror enabled';
        else
            handles.chkEnabledMirror = 0;
            msg = 'Mirror disabled';
        end
    elseif ischar(val)
        if strcmpi(val,'on')
            handles.chkEnabledMirror = 1;
            msg = 'Mirror enabled';
        else strcmpi(val,'off')
            handles.chkEnabledMirror = 0;
            msg = 'Mirror disabled';
        end
    else
        msg = 'MirrorEnable must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'DwellTime')
    feedbackLvl = -1;
    if isfloat(val)
        %         max = get(handles.sldDwell,'Max');
        %         min = get(handles.sldDwell,'Min');
        
        %         if val > max
        %             msg = ['Cannot set dwell time above ' num2str(max) 's. Dwell time set to max.'];
        %             set(handles.editDwell,'String',num2str(max));
        %             set(handles.sldDwell,'value',max);
        %             errorFlag = 1;
        %
        %         elseif val < min
        %             msg = ['Cannot set dwell time above ' num2str(min) 's. Dwell time set to min.'];
        %             set(handles.editDwell,'String',num2str(min));
        %             set(handles.sldDwell,'value',min);
        %             errorFlag = 1;
        %
        %         else
        msg = ['Dwell time set - ' num2str(val)];
        handles.dwellTime = val;
        %             set(handles.editDwell,'String',num2str(val));
        %             set(handles.sldDwell,'value',val);
        %         end
    else
        msg = 'Dwell time must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Instrument_fit')
    feedbackLvl = -1;
    if isfloat(val)
        str = get(handles.popupFittingInstrument,'String');
        handles.Image.instr = str(val);
        set(handles.popupFittingInstrument,'Value',val);
        msg = ['Instrument for processing set - ' str{val}];
    elseif ischar(val)
        str = get(handles.popupFittingInstrument,'String');
        temp = find(ismember(str,val)==1);
        if ~isempty(temp)
            set(handles.popupFittingInstrument,'Value',temp);
            handles.Image.instr = val;
            msg = ['Instrument for processing set - ' val];
        else
            msg = 'Instrument is not listed';
            errorFlag = 1;
        end
    else
        msg = 'Instrument_fit must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FitMethod')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.popupFittingMethod,'Value',val);
        str = get(handles.popupFittingMethod,'String');
        
        msg = ['FitMethod set - ' str(val)];
    elseif ischar(val)
        str = get(handles.popupFittingMethod,'String');
        temp = find(ismember(str,val)==1);
        set(handles.popupFittingMethod,'Value',temp);
        msg = ['FitMethod set - ' val];
    else
        msg = 'FitMethod must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Magnification')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Magnification = val;
        set(handles.txtMag,'String',['Magnification - ' int2str(handles.const.Magnification)]);
        msg = ['Magnification set - ' num2str(val)];
        [handles] = setParams(handles,'EffPixel',val);
    else
        msg = 'Magnification must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'PixelSize')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.Camera.PixelSize = val;
        set(handles.txtPixel,'String',['Pixel size [um] - ' num2str(handles.const.Camera.PixelSize(1)) ' ' num2str(handles.const.Camera.PixelSize(2))]);
        msg = ['PixelSize set - ' num2str(val)];
        [handles] = setParams(handles,'EffPixel',val);
    else
        msg = 'PixelSize must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'NA')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.NA = val;
        
        set(handles.txtNA,'String',['Numerical aperture - ' num2str(val)]);
        msg = ['Numerical Aperture set - ' num2str(val)];
    else
        msg = 'Numerical Aperture must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'DiffResolution')
    feedbackLvl = -1;
    if isfloat(val)
        temp = getParams(handles,'LED');
        if strcmpi(temp,handles.LEDs.commands.led1)
            temp = 1;
        elseif strcmpi(temp,handles.LEDs.commands.led2)
            temp = 2;
        elseif strcmpi(temp,handles.LEDs.commands.led3)
            temp = 3;
        elseif strcmpi(temp,handles.LEDs.commands.led4)
            temp = 4;
        end
        
        lambda = handles.const.LEDs(temp)/1000;
        handles.const.DiffResolution = roundn(lambda/(2*val),-3);
        
        set(handles.txtDiffResolution,'String',['Diffraction resolution [um] - ' num2str(handles.const.DiffResolution)]);
        msg = ['Diffraction Resolution set - ' num2str(handles.const.DiffResolution)];
    else
        msg = 'Diffraction Resolution must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapSize')
    feedbackLvl = -1;
    if isfloat(val)
        handles.const.minimapSize = roundn(val,-3);
        set(handles.txtMS,'String',['Minimap size [um] - ' num2str(handles.const.minimapSize)]);
        msg = ['Minimap size set - ' num2str(handles.const.minimapSize)];
    else
        msg = 'Minimap Area must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'EffPixel')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            if isfield(handles.const,'Magnification')
                handles.const.Camera.EffPixel = roundn(handles.const.Camera.PixelSize./handles.const.Magnification,-3);
                msg = ['EffPixel set - ' num2str(handles.const.Camera.EffPixel)];
            else
                handles.const.Camera.EffPixel = handles.const.Camera.PixelSize;
                msg = 'EffPixel -  Magnification is not defined. Assumed to be 1.';
                errorFlag = 1;
            end
        else
            if isfield(handles.const.Camera,'PixelSize')
                handles.const.Camera.EffPixel = roundn(handles.const.Camera.PixelSize./handles.const.Magnification,-3);
                msg = ['EffPixel set - ' num2str(handles.const.Camera.EffPixel)];
            else
                handles.const.Camera.EffPixel = [-1 -1];
                msg = 'EffPixel -  PixelSize is not defined';
                errorFlag = 1;
            end
        end
        set(handles.txtEffPixel,'String',['Effective pixel [um] - ' num2str(handles.const.Camera.EffPixel(1)) ' ' num2str(handles.const.Camera.EffPixel(2))]);
    else
        msg = 'EffPixel must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FOV') %[Y X]
    feedbackLvl = -1;
    if isfloat(val)
        if isfield(handles.const.Camera,'EffPixel')
            if isfield(handles.const.Camera,'MaxPixels')
                handles.const.Camera.FOV = roundn(getParams(handles,'EffPixel').*getParams(handles,'MaxPixels'),-3);
                msg = ['Field of View set - ' num2str(handles.const.Camera.FOV)];
            else
                handles.const.Camera.FOV = [-1 -1];
                msg = 'MaxPixels is undefined. Field of View is undefined';
                errorFlag = 1;
            end
        else
            handles.const.Camera.FOV = [-1 -1];
            msg = 'EffPixel is undefined. Field of View is undefined';
            errorFlag = 1;
        end
        set(handles.txtFOV,'String',['Field of view (HxW) [um] - ' num2str(handles.const.Camera.FOV(1)) ' ' num2str(handles.const.Camera.FOV(2))]);
    else
        msg = 'FOV must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'loadGIF')
    feedbackLvl = -1;
    handles.const.loadgif = val;
    msg = ['loadGIF set'];
    
elseif strcmpi(parameter,'adjustGIF')
    feedbackLvl = -1;
    handles.const.adjustgif = val;
    msg = ['adjustGIF set'];
    
elseif strcmpi(parameter,'focusImage')
    feedbackLvl = -1;
    if ischar(val)
        handles.const.focusImage = val;
        msg = ['focusImage set - ' val];
    else
        msg = 'focusImage must be a string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MainImageContrast')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editMainImageContrast,'String',num2str(val));
        handles.const.MainImageContrast = val;
        msg = ['MainImageContrast set - ' num2str(val)];
    else
        msg = 'MainImageContrast must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapContrast')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editMinimapContrast,'String',num2str(val));
        handles.const.MinimapContrast = val;
        msg = ['MinimapContrast set - ' num2str(val)];
    else
        msg = 'MinimapContrast must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Minimap')
    feedbackLvl = -1;
    if isfloat(val)
        clear handles.Minimap.data;
        handles.Minimap.data = val;
        [handles] = IMAGE_Minimap_display(handles);
        msg = 'Minimap updated';
    else
        msg = 'Minimap must be an integer matrix';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapPlaceholder')
    feedbackLvl = -1;
    if ischar(val)
        handles.Minimap.placeholder = val;
        msg = 'Minimap Placeholder set';
    else
        msg = 'Minimap Placeholder must be a string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapImageNumber')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Minimap.numImages = val;
        
        set(handles.txtNumImage,'String',['Images to populate minimap - ' num2str(handles.Minimap.numImages)]);
        msg = ['Minimap Image Number set - ' num2str(val)];
    else
        msg = 'Minimap Image Number must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MinimapSamplingSize')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Minimap.samplingSize = val;
        
        set(handles.txtSampleSize,'String',['Minimap sample size - ' num2str(handles.Minimap.samplingSize)]);
        msg = ['Minimap Sampling Size set - ' num2str(val)];
    else
        msg = 'Minimap Sampling Size must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'StageToMinimapConversion')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Minimap.conversion = val;
        
        set(handles.txtStageToMinimapConversion,'String',['Minimap conversion - ' num2str(handles.Minimap.conversion)]);
        msg = ['Stage-to-Minimap conversion set - ' num2str(val)];
    else
        msg = 'StageToMinimapConversion must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MaxPixels')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            handles.const.Camera.MaxPixels = val;
            [handles] = setParams(handles,'Height',val(1));
            [handles] = setParams(handles,'Width',val(2));
            [handles] = setParams(handles,'xOffset',0);
            [handles] = setParams(handles,'yOffset',0);
            [handles] = setParams(handles,'FOV',val);
            msg = ['MaxPixels set - ' num2str(val)];
        else
            msg = 'MaxPixels must be a [1x2] array';
            errorFlag = 1;
        end
    else
        msg = 'MaxPixels must be an integer array';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'CurrentFileGroup')
    feedbackLvl = 1;
    if ischar(val)
        temp = find(ismember(getParams(handles,'FileGroups'),val)==1);
        if temp > 0
            set(handles.popupFiles,'Value',temp);
            msg = ['CurrentFileGroup set - ' val];
        else
            msg = 'Parameter is not a member of File Groups';
            errorFlag = 1;
        end
        currentLocation = [handles.const.DataSetString val];
        fileNameList = getParams(handles,'FileNameList');
        
        if isfield(fileNameList, currentLocation)
            numberOfFiles = size(fileNameList.(currentLocation).index,2);
            fileList = ['None' fileNameList.(currentLocation).filename];
            
            set(handles.popupSelectPrescan,'String',fileList);
            set(handles.popupSelectPrescan,'Value',1);
            
            set(handles.popupSelectPostscan,'String',fileList);
            set(handles.popupSelectPostscan,'Value',1);
            
        else
            numberOfFiles = 1;
            set(handles.popupSelectPrescan,'String','None');
            set(handles.popupSelectPostscan,'String','None');
        end
        [handles] = setParams(handles,'MainPlotType','Intensity');
        [handles] = setParams(handles,'CurrentFileGroupTotal',numberOfFiles);
        [handles] = setParams(handles,'CurrentFile',1);
    elseif isfloat(val)
        groups = getParams(handles,'FileGroups');
        temp = groups{val};
        set(handles.popupFiles,'Value',val);
        msg = ['Current File Group set - ' temp];
        
        if strcmpi(temp,'none')
            numberOfFiles = 1;
            set(handles.popupSelectPrescan,'String','None');
            set(handles.popupSelectPostscan,'String','None');
        else
            currentLocation = [handles.const.DataSetString temp];
            fileNameList = getParams(handles,'FileNameList');
            fileList = ['None' fileNameList.(currentLocation).filename];
            
            set(handles.popupSelectPrescan,'String',fileList);
            set(handles.popupSelectPrescan,'Value',1);
            
            set(handles.popupSelectPostscan,'String',fileList);
            set(handles.popupSelectPostscan,'Value',1);
            
            numberOfFiles = size(fileNameList.(currentLocation).index,2);
        end
        [handles] = setParams(handles,'MainPlotType','Intensity');
        [handles] = setParams(handles,'CurrentFileGroupTotal',numberOfFiles);
        [handles] = setParams(handles,'CurrentFile',1);
    else
        msg = 'CurrentFileGroup must be a string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FileGroups')
    feedbackLvl = -1;
    if ischar(val) || iscell(val)
        set(handles.popupFiles,'String',val);
        msg = 'FileGroups set';
    else
        msg = 'FileGroups must be a string or cell';
        errorFlag = 1;
    end
    [handles] = setParams(handles,'CurrentFileGroup',val{1});
    
elseif strcmpi(parameter,'FileNameList')
    feedbackLvl = -1;
    if isstruct(val)
        handles.data.fileNameList = val;
        msg = 'FileNameList set';
    else
        msg = 'FileNameList must be a struct';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'CurrentFile')
    feedbackLvl = 1;
    if isfloat(val)
        val = fix(val);
        FileTotal = getParams(handles,'CurrentFileGroupTotal');
        if (val <= FileTotal) && (val > 0)
            fileNameList = getParams(handles,'FileNameList');
            currentLocation = getParams(handles,'CurrentFileGroup');
            
            set(handles.sldSelectedFile,'Value',val);
            set(handles.editSelectedFile,'String',val);
            if isfield(fileNameList,currentLocation)
                set(handles.txtCurrentFile,'String',fileNameList.(currentLocation).filename{val});
                [handles] = IMAGE_MainImage_loadData(handles);
                msg = ['CurrentFile set - ' fileNameList.(currentLocation).filename{val}];
            else
                [handles] = IMAGE_MainImage_reset(handles);
                [handles] = IMAGE_Minimap_reset(handles);
                set(handles.txtCurrentFile,'String','None');
                msg = 'CurrentFile set -  None';
            end
        else
            msg = ['CurrentFile must be between 0 and ' num2str(FileTotal)];
            errorFlag = 1;
        end
    elseif ischar(val)
        fileNameList = getParams(handles,'FileNameList');
        currentLocation = getParams(handles,'CurrentFileGroup');
        temp = find(ismember(fileNameList.(currentLocation).full_path_data,val)==1);
        if temp > 0
            set(handles.sldSelectedFile,'Value',temp);
            set(handles.editSelectedFile,'String',int2str(temp));
            set(handles.txtCurrentFile,'String',fileNameList.(currentLocation).filename{temp});
            handles = IMAGE_MainImage_loadData(handles);
            msg = ['CurrentFile set - ' fileNameList.(currentLocation).filename{temp}];
        else
            msg = ['CurrentFile not set. File is not in current file group - ' val];
            errorFlag = 1;
        end
    else
        msg = 'CurrentFile must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'PrescanFile')
    feedbackLvl = -1;
    if ischar(val)
        list = get(handles.popupSelectPrescan,'String');
        temp = find(ismember(list,val)==1);
        if temp > 0
            handles.PrescanFile.name = list{temp};
            handles.PrescanFile.full_path = [directory handles.PrescanFile.name];
            
            if ~strcmpi(handles.PrescanFile.name,'None')
                load(handles.PrescanFile.full_path);
                handles.PrescanFile.data = data;
            else
                handles.PrescanFile.rect = [0 0 0 0];
                handles.PrescanFile.data = 0;
            end
            msg = ['PrescanFile set - ' list{temp}];
        else
            msg = ['PrescanFile not set. File is not in current file group - ' val];
            errorFlag = 1;
        end
        
    elseif isfloat(val)
        list = get(handles.popupSelectPrescan,'String');
        if val > 0 && val < size(list,1)
            directory = getParams(handles,'Directory');
            handles.PrescanFile.name = list{val};
            handles.PrescanFile.full_path = [directory handles.PrescanFile.name];
            
            if ~strcmpi(handles.PrescanFile.name,'None')
                
                load(handles.PrescanFile.full_path);
                handles.PrescanFile.data = data;
            else
                handles.PrescanFile.rect = [0 0 0 0];
                handles.PrescanFile.data = 0;
            end
            msg = ['PrescanFile set - ' list{val}];
        else
            msg = ['Invalid PrescanFile selection - ' num2str(val)];
            errorFlag = 1;
        end
    else
        msg = 'PrescanFile must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'PostscanFile')
    feedbackLvl = -1;
    if ischar(val)
        list = get(handles.popupSelectPostscan,'String');
        temp = find(ismember(list,val)==1);
        if temp > 0
            directory = getParams(handles,'Directory');
            handles.PostscanFile.name = list{temp};
            handles.PostscanFile.full_path = [directory handles.PostscanFile.name];
            
            if ~strcmpi(handles.PostscanFile.name,'None')
                load(handles.PrescanFile.full_path)
                handles.PostscanFile.data = data;
            else
                handles.PostscanFile.rect = [0 0 0 0];
                handles.PostscanFile.data = 0;
            end
            msg = ['PostscanFile set - ' list{temp}];
        else
            msg = ['PostscanFile not set. File is not in current file group - ' val];
            errorFlag = 1;
        end
    elseif isfloat(val)
        list = get(handles.popupSelectPostscan,'String');
        if val > 0 && val < size(list,1)
            directory = getParams(handles,'Directory');
            handles.PostscanFile.name = list{val};
            handles.PostscanFile.full_path = [directory handles.PostscanFile.name];
            
            if ~strcmpi(handles.PostscanFile.name,'None')
                load(handles.PrescanFile.full_path);
                handles.PostscanFile.data = data;
            else
                handles.PostscanFile.rect = [0 0 0 0];
                handles.PostscanFile.data = 0;
            end
            msg = ['PostscanFile set - ' list{val}];
        else
            msg = ['Invalid PostscanFile selection - ' num2str(val)];
            errorFlag = 1;
        end
    else
        msg = 'PostscanFile must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'CurrentFileGroupTotal')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.sldSelectedFile,'Value',1);
        set(handles.sldSelectedFile,'Max',val);
        set(handles.txtTotalFile,'String',['/' int2str(val) ' - ']);
        if val == 1
            set(handles.sldSelectedFile,'Visible','off');
            set(handles.sldSelectedFile,'SliderStep',[1 1]);
        else
            set(handles.sldSelectedFile,'Visible','on');
            set(handles.sldSelectedFile,'SliderStep',[1/(val-1) 1]);
        end
        msg = ['CurrentFileGroupTotal set - ' num2str(val)];
    else
        msg = 'CurrentFileGroupTotal must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MirrorList')
    feedbackLvl = -1;
    if isstruct(val)
        if (size(val.name,2) == 0)
            val.name = {'None'};
        end
        
        handles.data.mirrorlist = val;
        set(handles.popupValueMirror,'String',val.name);
        msg = 'MirrorList set';
    else
        msg = 'MirrorList must be a struct';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'CurrentMirrorFile')
    feedbackLvl = 1;
    if isfloat(val)
        set(handles.popupValueMirror,'Value',val);
        str = get(handles.popupValueMirror,'String');
        msg = ['CurrentMirrorFile set - ' char(str{1}{val,1})];
    elseif ischar(val)
        str = get(handles.popupValueMirror,'String');
        temp = find(ismember(str,val)==1);
        if temp > 0
            set(handles.popupValueMirror,'Value',temp);
            msg = ['CurrentMirrorFile set - ' val];
        else
            msg = ['CurrentMirrorFile not set. File is not in current file group - ' val];
            errorFlag = 1;
        end
    else
        msg = 'CurrentMirrorFile must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MirrorVar')
    feedbackLvl = -1;
    if isstruct(val)
        handles.data.mirrorVar = val;
        msg = 'MirrorVar set';
    else
        msg = 'MirrorVar must be a struct';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'DataVar')
    feedbackLvl = -1;
    if isstruct(val)
        handles.data.dataVar = val;
        msg = 'DataVar set';
    else
        msg = 'DataVar must be a struct';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'IntensityVisible')
    feedbackLvl = -1;
    if isfloat(val)
        if val > 0
            set(handles.radIntensity,'Visible','on');
        else
            set(handles.radIntensity,'Visible','off');
        end
        msg = ['IntensityVisible set - ' num2str(val)];
    elseif ischar(val)
        if strcmpi(val,'on') || strcmpi(val,'off')
            set(handles.radIntensity,'Visible',val);
            msg = ['IntensityVisible set - ' val];
        else
            msg = ['Incorrect string to IntensityVisible - ' val];
            errorFlag = 1;
        end
    else
        msg = 'IntensityVisible must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ContrastVisible')
    feedbackLvl = -1;
    if isfloat(val)
        if val > 0
            set(handles.radContrast,'Visible','on');
        else
            set(handles.radContrast,'Visible','off');
        end
        msg = ['ConstrastVisible set - ' num2str(val)];
    elseif ischar(val)
        if strcmpi(val,'on') || strcmpi(val,'off')
            set(handles.radContrast,'Visible',val);
            msg = ['ConstrastVisible set - ' val];
        else
            msg = ['Incorrect string to ConstrastVisible - ' val];
            errorFlag = 1;
        end
    else
        msg = 'ConstrastVisible must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ProcessVisible')
    feedbackLvl = -1;
    if isfloat(val)
        if val > 0
            set(handles.radProcess,'Visible','on');
        else
            set(handles.radProcess,'Visible','off');
        end
        msg = ['ProcessVisible set - ' num2str(val)];
    elseif ischar(val)
        if strcmpi(val,'on') || strcmpi(val,'off')
            set(handles.radProcess,'Visible',val);
            msg = ['ProcessVisible set - ' val];
        else
            msg = ['Incorrect string to ProcessVisible - ' val];
            errorFlag = 1;
        end
    else
        msg = 'ProcessVisible must be an integer or string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MainPlotType')
    feedbackLvl = -1;
    if ischar(val)
        %         set(handles.radIntensity,'Value',0);
        %         set(handles.radContrast,'Value',0);
        %         set(handles.radProcess,'Value',0);
        
        if strcmpi(val,'Intensity')
            %             set(handles.radIntensity,'Value',1)
            handles.GUI.plotmain ='data';
            msg = 'Plotting Intensity';
        elseif strcmpi(val,'Contrast')
            %             set(handles.radContrast,'Value',1);
            handles.GUI.plotmain = val;
            msg = 'Plotting Contrast';
        elseif strcmpi(val,'Process')
            %             set(handles.radProcess,'Value',1);
            handles.GUI.plotmain = val;
            msg = 'Plotting Process';
        else
            msg = ['Incorrect MainPlotType parameter - ' val];
            errorFlag = 1;
        end
    elseif isfloat(val)
        if val == 1
            %             set(handles.radIntensity,'Value',1)
            handles.GUI.plotmain = 'data';
            msg = 'Plotting Style -  Intensity';
        elseif val == 2
            %             set(handles.radContrast,'Value',1);
            handles.GUI.plotmain = 'Contrast';
            msg = 'Plotting Style -  Contrast';
        elseif val == 3
            %             set(handles.radProcess,'Value',1);
            handles.GUI.plotmain = 'Process';
            msg = 'Plotting Style -  Process';
        else
            msg = ['Incorrect MainPlotType parameter - ' val];
            errorFlag = 1;
        end
    else
        msg = 'MainPlotType must be a string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'Comment')
    if ischar(val)
        set(handles.editComment,'String',val);
        msg = 'Comment set';
    else
        msg = 'Comment must be a string';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'CameraPreviewStatus')
    feedbackLvl = -1;
    if isfloat(val)
        if(val == 0) || (val == 1)
            handles.Status.Camera.Preview = val;
            msg = ['CameraPreviewStatus set - ' num2str(val)];
        else
            msg = 'CameraPreviewStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'CameraPreviewStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'RefParticleStatus')
    feedbackLvl = -1;
    
    if isfloat(val)
        if(val == 0) || (val == 1)
            set(handles.chkProcessRefParticle,'Value',val);
            set(handles.chkRefParticle,'Value',val);
            handles.Status.RefParticle = val;
            msg = ['RefParticleStatus set - ' num2str(val)];
        else
            msg = 'RefParticleStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'RefParticleStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'SystemStatus')
    feedbackLvl = -1;
    if isfloat(val)
        if(val == 0) || (val == 1)
            handles.Status.System = val;
            msg = ['SystemStatus set - ' num2str(val)];
        else
            msg = 'SystemStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'SystemStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'ChipLoadStatus')
    if isfloat(val)
        if (val==0) || (val==1)
            handles.Status.Chip.Load = val;
            msg = ['ChipLoadStatus set - ' num2str(val)];
        else
            msg = 'ChipLoadStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'ChipLoadStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'StageInitStatus')
    if isfloat(val)
        if (val==0) || (val==1)
            handles.Status.Stage.Init = val;
            msg = ['StageInitStatus set - ' num2str(val)];
        else
            msg = 'StageInitStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'StageInitStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'StageHomeStatus')
    feedbackLvl = -1;
    if isfloat(val)
        if (val==0) || (val==1)
            handles.Status.Stage.Home = val;
            msg = ['StageHomeStatus set - ' num2str(val)];
        else
            msg = 'StageHomeStatus must be a 0/1';
            errorFlag = 1;
        end
    else
        msg = 'StageHomeStatus must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'FocusPos')
    feedbackLvl = -1;
    handles.Stage.FC.Pos = val; %[X Y Z]
    msg = 'FocusPos set';
    
elseif strcmpi(parameter,'LogoPos')
    feedbackLvl = -1;
    handles.Stage.Logo.Pos = val; %[X Y Z]
    msg = 'LogoPos set';
    
elseif strcmpi(parameter,'AllLogoPos')
    feedbackLvl = -1;
    handles.Stage.Logo.AllPos = val; %[X Y Z]
    msg = 'AllLogoPos set';
    
elseif strcmpi(parameter,'ChipOffset')
    if ~isfield(handles.const,'chipOffset')
        handles.const.chipoffset = [0 0];
    end
    handles.const.chipOffset = val; %[X Y]
    msg = ['ChipOffset set - ' num2str(val(1)) ' ' num2str(val(2))];
    
elseif strcmpi(parameter,'ParticleOffset')
    feedbackLvl=-1;
    handles.const.particleOffset = val; %[Z]
    msg = ['ParticleOffset set -  ' num2str(val)];
    
elseif strcmpi(parameter,'PlaneCoeff')
    feedbackLvl=-1;
    
    handles.Stage.PlaneCoefficients = val;
    
    load(handles.Stage.alignment_config_filename);
    
    alignment_config.PlaneCoefficients{end+1}=val;
    
    
    alignment_config.FCpos{end+1}= handles.Stage.FC.Pos;
 
    
    alignment_config.AlignmentInfo{1,end+1}=getParams(handles,'AlignmentDate');
    alignment_config.AlignmentInfo{2,end}=getParams(handles,'AlignmentType');
    
    save(handles.Stage.alignment_config_filename,'alignment_config');
    clear alignment_config;
    
    msg = ['Alignment Updated - '];
    getParams(handles,'Alignment');
    
elseif strcmpi(parameter,'AlignmentDate')
    feedbackLvl=-1;
    handles.Stage.AlignmentDate=val;
    msg = ['AlignmentType set - ' val];
    
elseif strcmpi(parameter,'AlignmentType')
    feedbackLvl=-1;
    handles.Stage.AlignmentType=val;
    msg = ['AlignmentType set - ' val];
    
elseif strcmpi(parameter,'Backlash')
    feedbackLvl = -1;
    if isfloat(val)
        if size(val,2) == 2
            handles.Stage.Backlash = val;
            msg = ['Backlash set - ' num2str(val)];
        else
            msg = 'Backlash must contain XY';
            errorFlag = 1;
        end
    else
        msg = 'Backlash must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'SmartMove')
    feedbackLvl = 1;
    if isfloat(val)
        if (val == 0)
            set(handles.chkSmartMove,'Value',val);
            msg = 'SmartMove Disabled';
        elseif (val == 1)
            set(handles.chkSmartMove,'Value',val);
            msg = 'SmartMove Enabled';
        else
            msg = 'SmartMove must be a 0 or 1';
            errorFlag = 1;
        end
    else
        msg = 'SmartMove must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'IntensityTh')
    feedbackLvl = -1;
    set(handles.editIntensityTh,'String', num2str(val));
    msg = ['IntensityTh - ' num2str(val)];
    
elseif strcmpi(parameter,'EdgeTh')
    feedbackLvl = -1;
    set(handles.editEdgeTh,'String', num2str(val));
    msg = ['EdgeTh - ' num2str(val)];
    
elseif strcmpi(parameter,'TemplateSize')
    feedbackLvl = -1;
    set(handles.editTemplateSize,'String', num2str(val));
    msg = ['TemplateSize - ' num2str(val)];
    
elseif strcmpi(parameter,'SD')
    feedbackLvl = -1;
    set(handles.editSD,'String', num2str(val));
    msg = ['SD - ' num2str(val)];
    
elseif strcmpi(parameter,'GaussianTh')
    feedbackLvl = -1;
    set(handles.editGaussianTh,'String', num2str(val));
    msg = ['GaussianTh - ' num2str(val)];
    
elseif strcmpi(parameter,'InnerRadius')
    feedbackLvl = -1;
    set(handles.editInnerRadius,'String', num2str(val));
    msg = ['InnerRadius - ' num2str(val)];
    
elseif strcmpi(parameter,'OuterRadius')
    feedbackLvl = -1;
    set(handles.editOuterRadius,'String', num2str(val));
    msg = ['OuterRadius - ' num2str(val)];
    
elseif strcmpi(parameter,'SoftwareVersion')
    handles.const.version = val;
    msg = ['Software Version set - ' num2str(val)];
    
elseif strcmpi(parameter,'CameraPointers')
    feedbackLvl = -1;
    handles.Camera = val;
    msg = 'CameraPointers set';
    
elseif strcmpi(parameter,'StagePointers')
    feedbackLvl = -1;
    handles.Stage = val;
    msg = 'StagePointers set';
    
elseif strcmpi(parameter,'Binning')
    feedbackLvl = -1;
    if isfloat(val)
        if (size(val,2)==2)
            handles.Camera.Binning = val;
            msg = ['Binning set - ' num2str(val(1)) ' ' num2str(val(2))];
        elseif size(val,2)
            handles.Camera.Binning = [val val];
            msg = ['Binning set - ' num2str(val) ' ' num2str(val)];
        else
            msg = 'Binning must be 1 or 2 integers';
            errorFlag = 1;
        end
    else
        msg = 'Binning must be an integer';
        errorFlag = 1;
    end
    
elseif strcmpi(parameter,'MaxHist')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editMaxHist,'String',int2str(val));
        set(handles.editProcessMaxHist,'String',int2str(val));
        msg = ['MaxHist set - ' int2str(val)];
    else
        set(handles.editMaxHist,'String',val);
        set(handles.editProcessMaxHist,'String',int2str(val));
        msg = ['MaxHist set - ' val];
    end
    
elseif strcmpi(parameter,'RefMaxHist')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editRefMaxHist,'String',int2str(val));
        set(handles.editProcessRefMaxHist,'String',int2str(val));
        msg = ['RefMaxHist set - ' int2str(val)];
    else
        set(handles.editRefMaxHist,'String',val);
        set(handles.editProcessRefMaxHist,'String',int2str(val));
        msg = ['RefMaxHist set - ' val];
    end
    
elseif strcmpi(parameter,'MinHist')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editMinHist,'String',int2str(val));
        set(handles.editProcessMinHist,'String',int2str(val));
        msg = ['MinHist set - ' int2str(val)];
    else
        set(handles.editMinHist,'String',val);
        set(handles.editProcessMinHist,'String',int2str(val));
        msg = ['MinHist set - ' val];
    end
    
elseif strcmpi(parameter,'RefMinHist')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editRefMinHist,'String',int2str(val));
        set(handles.editProcessRefMinHist,'String',int2str(val));
        msg = ['RefMinHist set - ' int2str(val)];
    else
        set(handles.editRefMinHist,'String',val);
        set(handles.editProcessRefMinHist,'String',int2str(val));
        msg = ['RefMinHist set - ' val];
    end
    
elseif strcmpi(parameter,'HistBin')
    feedbackLvl = -1;
    if isfloat(val)
        set(handles.editHistBins,'String',int2str(val));
        msg = ['HistBin set - ' int2str(val)];
    else
        set(handles.editHistBins,'String',val);
        msg = ['HistBin set - ' val];
    end
    
elseif strcmpi(parameter,'BtnState')
    feedbackLvl = -1;
    if isfloat(val)
        handles.Status.btns = val;
        msg = ['BtnState set - ' int2str(val)];
    else
        msg = 'BtnState must be an integer';
    end
    
elseif strcmpi(parameter,'Instrument')
    if ischar(val)
        [cfg] = HARDWARE_Scan(); % dsf, auto-scan using python code, quick and dirty style
        handles.const.instrument_port_cfg = cfg; %dsf, uber-hack for auto-port config
        if strcmpi(val,'Benchtop') || strcmpi(val,'SP-IRIS1')
            handles.const.instrument = 'SP-IRIS1';
            [handles] = setParams(handles,'EnableStages',0);
            [handles] = setParams(handles,'Camera','Retiga2000R');
            [handles] = setParams(handles,'LEDControl','DAQ');
            [handles.LEDs] = LEDS_INIT_DAQ();
            
        elseif strcmpi(val,'Benchtop2') || strcmpi(val,'SP-IRIS2') ||...
                strcmpi(val,'SP-IRIS 2') || strcmpi(val,'SPIRIS2') ||...
                strcmpi(val,'SPIRIS 2')
            handles.const.instrument = 'SP-IRIS2';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V2');
            [handles] = setParams(handles,'Camera','Retiga2000R');
            [handles] = setParams(handles,'LEDControl','DAQ');
            [handles.LEDs] = LEDS_INIT_DAQ_64();
            
        elseif strcmpi(val,'Benchtop3') || strcmpi(val,'SP-IRIS3') ||...
                strcmpi(val,'SP-IRIS 3') || strcmpi(val,'SPIRIS3') ||...
                strcmpi(val,'SPIRIS 3')
            handles.const.instrument = 'SP-IRIS3';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V2');
            [handles] = setParams(handles,'Camera','Retiga4000R');
            [handles] = setParams(handles,'LEDControl','DAQ');
            [handles.LEDs] = LEDS_INIT_DAQ();
            
        elseif strcmpi(val,'Prototype')
            handles.const.instrument = 'Prototype';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V1');
            [handles] = setParams(handles,'Camera','Grasshopper2');
            [handles] = setParams(handles,'LEDControl','Router');
            [handles.LEDs] = LEDS_INIT_Prototype();
            [handles.Stage] = STAGE_INIT();
        elseif strcmpi(val,'SP-A1000')
            handles.const.instrument = 'SP-A1000';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V3');
            [handles] = setParams(handles,'Camera','Grasshopper3-2_3MP');
            [handles] = setParams(handles,'LEDControl','Arduino');
            [handles.LEDs] = LEDS_INIT_ARDUINO(handles.const.instrument_port_cfg.arduino);
            %[handles.Stage] = STAGE_INIT();
        elseif strcmpi(val,'hybrid')
            handles.const.instrument = 'hybrid';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V5');
            [handles] = setParams(handles,'Camera','Grasshopper3-2_3MP');
            [handles] = setParams(handles,'LEDControl','Analog');
            [handles.LEDs] = LEDS_INIT_ANALOG();
            %[handles.Stage] = STAGE_INIT();
        elseif strcmpi(val,'Ayca')
            handles.const.instrument = 'Ayca';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V6');
            [handles] = setParams(handles,'Camera','Grasshopper3-2_3MP');
            [handles] = setParams(handles,'LEDControl','Analog');
            [handles.LEDs] = LEDS_INIT_ANALOG();
            %[handles.Stage] = STAGE_INIT();
        else
            handles.const.instrument = 'Prototype';
            [handles] = setParams(handles,'EnableStages',1);
            [handles] = setParams(handles,'StageType','V1');
            [handles] = setParams(handles,'Camera','Grasshopper2');
            [handles] = setParams(handles,'LEDControl','Router');
            [handles.LEDs] = LEDS_INIT_Prototype();
            [handles.Stage] = STAGE_INIT();
        end
        set(handles.txtInstrumentName,'String',handles.const.instrument);
        msg = ['Instrument - ' handles.const.instrument];
    else
        msg = 'Instrument must be a string';
    end
    
elseif strcmpi(parameter,'StageType')
    feedbackLvl = -1;
    if char(val)
        handles.const.StageType = val;
        msg = ['StageType set - ' val];
    else
        msg = 'StageType must be an string';
    end
    
elseif strcmpi(parameter,'EnableStages')
    feedbackLvl = -1;
    if isfloat(val)
        if (val == 0) || (val == 1)
            handles.const.EnableStages = val;
            msg = ['EnablesStages set - ' int2str(val)];
        else
            msg = 'EnablesStages must be a 0/1';
        end
    else
        msg = 'EnablesStages must be an integer';
    end
    
elseif strcmpi(parameter,'LEDControl')
    feedbackLvl = -1;
    if char(val)
        handles.const.LEDControl = val;
        msg = ['LEDControl set - ' val];
    else
        msg = 'LEDControl must be an string';
    end
    
elseif strcmpi(parameter,'ZVelocity')
    feedbackLvl = -1;
    whatStages = getParams(handles,'StageType'); 
    if isfloat(val)
        if ~isfield(handles.const.Stage,'ZVelocity')
            if getParams(handles,'Mode') %online   
                
                if strcmpi(whatStages,'V1') ||  strcmpi(whatStages,'V2') %Stages in the NSF AIR prototype
                    handles.const.Stage.ZVelocity =...
                    STAGE_getVelocityAxis(handles.Stage,handles.Stage.axis.z);
                elseif strcmpi(whatStages,'V3')
                    handles.const.Stage.ZVelocity = 1000; %1 mm/s for PPS-20, reduced functionality here
                end
            else
                handles.const.Stage.ZVelocity = 1;
            end
        else
            handles.const.Stage.ZVelocity = val;
        end
        
        if getParams(handles,'Mode') %online   
            if strcmpi(whatStages,'V1') ||  strcmpi(whatStages,'V2') %Stages in the NSF AIR prototype
                STAGE_setVelocityAxis(handles.Stage,handles.Stage.axis.z,val);
            end
        else %offline

        end
        
        set(handles.editZVelocity,'String',val);
        
        msg = ['ZVelocity set - ' int2str(val)];
    else
        msg = 'ZVelocity must be an integer';
    end
    
elseif strcmpi(parameter,'XYVelocity')
    feedbackLvl = -1;
    whatStages = getParams(handles,'StageType'); 
    if isfloat(val)
        if ~isfield(handles.const.Stage,'XYVelocity')
            if getParams(handles,'Mode') %online
                if strcmpi(whatStages,'V1') ||  strcmpi(whatStages,'V2') %Stages in the NSF AIR prototype
                    handles.const.Stage.XYVelocity =...
                    STAGE_getVelocityAxis(handles.Stage,handles.Stage.axis.x);
                elseif strcmpi(whatStages,'V3')
                    handles.const.Stage.XYVelocity = 1000; %1 mm/s for PPS-20, reduced functionality here
                end
                
            else
                handles.const.Stage.XYVelocity = 1;
            end
        else
            handles.const.Stage.XYVelocity = val;
        end
        
        if getParams(handles,'Mode') %online
            if strcmpi(whatStages,'V1') ||  strcmpi(whatStages,'V2') %Stages in the NSF AIR prototype
                STAGE_setVelocityAxis(handles.Stage,handles.Stage.axis.x,val);
                STAGE_setVelocityAxis(handles.Stage,handles.Stage.axis.y,val);
            end
        else
            
        end
        
        msg = ['XYVelocity set - ' int2str(val)];
    else
        msg = 'XYVelocity must be an integer';
    end

elseif strcmpi(parameter,'temp')
    feedbackLvl = -1;
    handles.const.tempVar = val;
    if isfloat(val)
        msg = ['Temp set - ' num2str(val)];
    else
        msg = ['Temp set - ' val];
    end

else
    msg = ['Incorrect parameter give to setParams - ' parameter];
    errorFlag = 1;
end

[handles] = GUI_logMsg(handles,msg,handles.const.log.parameter,handles.txtLog,feedbackLvl,errorFlag);