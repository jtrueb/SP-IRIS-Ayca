function [handles,data] = ACQUIRE_scan(handles,options)
% [handles,data] = ACQUIRE_scan(handles,options)
%Options can be hist, previews, take, save, mirror, focus, minimap

%Check if server is running and restart server if it is not running
if strcmpi(getParams(handles,'Camera'),'Grasshopper2')
    try
        [handles isConnected] = CAMERA_INIT(handles,'isConnected');
        
        if strcmpi(isConnected,'error')
            [handles] = setParams(handles,'Mode','offline');
            msg = 'Error connecting to Camera. Running in off-line mode.';
            feedbackLvl = 1;
            errorFlag = 1;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
                handles.txtLog,feedbackLvl,errorFlag);
            return;
        end
    catch
        [handles] = setParams(handles,'Mode','offline');
        msg = 'Error connecting to Camera.';
        feedbackLvl = 1;
        errorFlag = 1;
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
            handles.txtLog,feedbackLvl,errorFlag);
        data = 0;
        return;
    end
end

%Set flags
skip = 1; %
capture_mode = 0; %Default to preview, 1 = acquire image
histInt_flag = 0; %Plot image intensity
histSize_flag = 0; %Plot particle size 
histContrast_flag = 0; %Plot particle contrast

mir_flag = 0; %Save as mirror
save_flag = 0; %Save the data
ROI_flag = 0; %Shrink the ROI of the image
mini_flag = 0; %Acquire minimap images
analyze_flag = 0; % Analyze the data

errorFlag = 0;
feedbackLvl = 1;

if ischar(options)
    if strcmpi(options,'hist')
        %Take frame and plot intensity histogram
        capture_mode = 1;
        histInt_flag = 1;
        analyze_flag = 1;

    elseif strcmpi(options,'Size')
        %Take frame and plot size histogram
        capture_mode = 1;
        analyze_flag = 1;
        histSize_flag = 1;
        
    elseif strcmpi(options,'Contrast')
        %Take frame and plot contrast histogram
        capture_mode = 1;
        analyze_flag = 1;
        histContrast_flag = 1;

    elseif strcmpi(options,'preview')
        
        
    elseif strcmpi(options,'take')
        capture_mode = 1;
        
    elseif strcmpi(options,'ROI')
        capture_mode = 1;

    elseif strcmpi(options,'save')
        capture_mode = 1;
        analyze_flag = 0;
        save_flag = 1;
        
    elseif strcmpi(options,'mirror')
        capture_mode = 1;
        save_flag = 1;
        mir_flag = 1;
        
    elseif strcmpi(options,'focus')
        capture_mode = 1;
        ROI_flag = 1;
        
    elseif strcmpi(options,'minimap')
        capture_mode = 1;
        mini_flag = 1;
        
    end
else
    msg = 'Incorrect option for ACQUIRE_scan.';
    skip = 0;    
    errorFlag = 1;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl,errorFlag);
end

%[handles] = LEDS_setState(handles,'vacuumpres');
[handles] = LEDS_PUMP_RESERVOIR(handles);

if skip %you are happy
    data = zeros(getParams(handles,'Height'), getParams(handles,'Width'));
    
    %% Record data
    camera = getParams(handles,'Camera');
    
    %Connect to camera and setup video parameters
    %PGServer needs exposure as [ms] and matlab needs [s].
    if(strcmpi(camera,'GrassHopper2'))
        [handles,initial] = CAMERA_GrassHopper2(handles,'init');        
        initial.capture_mode=capture_mode;
        initial.timeout = 1000;
        initial.save_raw_integer_data = 0;
        initial.number_of_frames = getParams(handles,'ScanAvg');
        initial.exposure = getParams(handles,'Exposure'); %[ms]
        initial.ROI = getParams(handles,'ROI');
        initial.binning = getParams(handles,'Binning');
        initial.fps = getParams(handles,'FPS');
        
        if ROI_flag
            totalROI = initial.ROI.*[initial.binning initial.binning];
            initial.number_of_frames = 4;
            initial.binning = [4 4];
            initial.exposure = initial.exposure/4;
            initial.ROI = totalROI./[initial.binning initial.binning];
            initial.fps = initial.fps*4;
            
            clear data;
            data = zeros(initial.ROI(3), initial.ROI(4));
            
        elseif mini_flag
            maxPixels = getParams(handles,'MaxPixels');%[Height Width]
            totalPixels = maxPixels.*initial.binning;
            initial.number_of_frames = 2;
            initial.binning = [4 4];
            initial.exposure = initial.exposure/4;
            initial.ROI = [0 0 totalPixels./initial.binning];
            initial.fps = inital.fps*4;
            
            clear data;
            data = zeros(initial.ROI(3), initial.ROI(4));
        end
        
        [handles,output] = CAMERA_GrassHopper2(handles,initial);
        
    elseif(strcmpi(camera,'GrassHopper'))
        [handles,initial] = CAMERA_GrassHopper(handles,'init');
        initial.capture_mode=capture_mode;
        initial.timeout = 1000;
        initial.save_raw_integer_data = 0;
        initial.number_of_frames = getParams(handles,'ScanAvg');
        initial.exposure = getParams(handles,'Exposure')/1000;%[s]
        initial.ROI = getParams(handles,'ROI');
        
%         [handles,output] = CAMERA_GrassHopper(handles,initial);
        disp('Implement CAMERA_GrassHopper');
        output.data = randi([0,2],[initial.ROI(3),initial.ROI(4)]);
        
    elseif(strcmpi(camera,'Retiga2000R'))
        [handles,initial] = CAMERA_Retiga2000R(handles,'init');
        initial.capture_mode=capture_mode;
        initial.gain = 1;
        initial.timeout = 1000;
        initial.number_of_frames = getParams(handles,'ScanAvg');
        initial.exposure = getParams(handles,'Exposure')/1000;%[s]
        ROI = getParams(handles,'ROI');
        initial.ROI = [ROI(2) ROI(1) ROI(4) ROI(3)];
        
        [handles,output] = CAMERA_Retiga2000R(handles,initial);
        
    elseif(strcmpi(camera,'Retiga4000R'))
        [handles,initial] = CAMERA_Retiga4000R(handles,'init');
        initial.capture_mode=capture_mode;
        initial.gain = 1;
        initial.timeout = 1000;
        initial.number_of_frames = getParams(handles,'ScanAvg');
        initial.exposure = getParams(handles,'Exposure')/1000;%[s]
        ROI = getParams(handles,'ROI');
        initial.ROI = [ROI(2) ROI(1) ROI(4) ROI(3)];
        
        [handles,output] = CAMERA_Retiga4000R(handles,initial);
    elseif(strcmpi(camera,'Grasshopper3-2_3MP'))
        [handles,initial] = CAMERA_Grasshopper3_Fast(handles,'init');
        initial.capture_mode=capture_mode;
        initial.gain = 1;
        initial.timeout = 1000;
        initial.number_of_frames = getParams(handles,'ScanAvg');
        initial.exposure = getParams(handles,'Exposure')/1000;%[s]
        ROI = getParams(handles,'ROI');
        initial.ROI = [ROI(2) ROI(1) ROI(4) ROI(3)];
        
        [handles,output] = CAMERA_Grasshopper3_Fast(handles,initial);
    end
    
    if capture_mode == 1
        data=double(output.data);
        clear output initial;
        data_raw=data;
%         data(1,1)=4096;
        curROI = getParams(handles,'ROI');
%         curDir=userpath;
%         mirPath=strcat(curDir(1:size(curDir,2)-1),'\',getParams(handles,'CurrentMirrorFile'));

        curDir=pwd;
        % THIS IS THE WRONG DIRECTORY, I THINK
        %mirPath=strcat(curDir,'\',getParams(handles,'CurrentMirrorFile'));
        % TRY THIS INSTEAD
        mirPath=strcat(getParams(handles,'MirrorDirectory'),getParams(handles,'CurrentMirrorFile'));
        

        % BUG HERE. SEE IF CHECKING FOR MIR_FLAG FIXES. DSF 2014-03-26
%         if (mir_flag == 0)
%             load(mirPath{1});
%             data_mirror_full=data_mir;
%             data_mirror_cropped=data_mir(curROI(1)+1:(curROI(1)+curROI(3)),curROI(2)+1:(curROI(2)+curROI(4)));
%             clear data_mir;
%         end
        %normalize by mirror file
%         data=data./data_mirror_cropped;
        
        [handles] = IMAGE_MainImage_display(handles,data,'image');
        
        %Detect the analyzed image
        if analyze_flag
            %Define particles to detect
                [particle_type] = getParams(handles,'ParticleType');
                [minSize] = getParams(handles,'MinHist');
                [maxSize] = getParams(handles,'MaxHist');
                
                [particle_count,ParticleData] = spd_automated(handles,data_raw,particle_type,minSize,maxSize); %Detect particles
                disp([particle_type  ' Particles found: ' num2str(particle_count)]);
                
                output.particle_count = particle_count;
        else
            particle_count=-10;
        end
        
        %Plot histogram
        if histInt_flag %now using data_raw instead of data
            data = data_raw./(2.^getParams(handles,'BitDepth'));
            [handles] = IMAGE_Plot_display(handles,data,'hist');
        end
        if histSize_flag
            [handles] = IMAGE_Plot_display(handles,ParticleData.Size,'hist');
        end
        if histContrast_flag
            [handles] = IMAGE_Plot_display(handles,ParticleData.Contrasts,'hist');
        end
        
        
        if save_flag
            if mir_flag
                data_mir = data_raw; %set to temp raw variable to avoid self-normalization
                data_wav_mir = getParams(handles,'LEDColor');
                data_date_mir = datestr(now);
                instrument = getParams(handles,'Instrument');
                software_version = getParams(handles,'SoftwareVersion');

                root_name = [getParams(handles,'Directory') getParams(handles,'ChipID')...
                    handles.const.MirrorString data_date_mir(13:14) data_date_mir(16:17) data_date_mir(19:20)];
                save(root_name,'data_mir','data_wav_mir','data_date_mir',...
                    'instrument','software_version');
                
            else                
                data_date = datestr(now);
                dateString = [data_date(13:14) data_date(16:17) data_date(19:20)];
                [root_name] = [getParams(handles,'Directory') getParams(handles,'ChipID')];
                
                %Construct output struct
                offset = 0;
                output = OUTPUT_getVariables(handles,root_name,data,particle_count,offset);
                output.xspot = 1;
                output.yspot = 1;
                output.data_raw=data_raw;
                output.mirror_name=getParams(handles,'CurrentMirrorFile');
                
                %Save
                [handles] = OUTPUT_matFile(handles,output.matName,output);
%                 [handles] = OUTPUT_excelFile(handles,output.xlsName,output);
                    
                %Determines if the rootname needs to be added to fileGroups or
                %updates
                %Removed 1/7/2014 - Redundancy, already called within
                %defocus_scan_v3_RP
%                 [handles] = DATA_CheckFileGroup(handles,getParams(handles,'ChipID'));
            end
            
            msg = root_name;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog,1,0);
        end
    end
end