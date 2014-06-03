function varargout = GUI_Analysis(varargin)
% GUI_ANALYSIS MATLAB code for GUI_Analysis.fig
%      GUI_ANALYSIS, by itself, creates a new GUI_ANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_ANALYSIS returns the handle to a new GUI_ANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ANALYSIS.M with the given input arguments.
%
%      GUI_ANALYSIS('Property','Value',...) creates a new GUI_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Analysis

% Last Modified by GUIDE v2.5 25-Apr-2014 13:19:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Analysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% ----------------------------------------------------------------------------------------------------------------------------------------------------------
%GUI Initialization and Output Functions
% ----------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes just before GUI_Analysis is made visible.
function GUI_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Analysis (see VARARGIN)

% Choose default command line output for GUI_Analysis
handles.output = hObject;

warning('off');

handles.compatibility_min=1.5;
handles.software_version='1.5';

handles.analysis_type='raw';

handles.mirdir='';
handles.mirname='';
handles.signaldir='';
handles.refdir='';
handles.chipname_signal='';
handles.chipname_reference='';
handles.signal_namelist = [];
handles.signal_imagesfound = [];
handles.signal_indices = [];
handles.signal_dataID='DataSet';
handles.reference_namelist = [];
handles.reference_imagesfound = [];
handles.reference_indices = [];
handles.reference_dataID='DataSet';
handles.display_image_path='';
handles.display_image_name='';
handles.FOV=[];
handles.crop_rect_image_signal=[];
handles.current_index=[];

handles.crop_rect_image_signal=[];
handles.crop_rect_image_reference=[];

handles.IntTh=.3;
handles.EdgeTh=2; %not displayed
handles.ImScale=2;
handles.InnerRad=9;
handles.OuterRad=12;
handles.NA=.8;
handles.backradius=4;
handles.pixelsize=.1172;
handles.limits_display=[.5,1,1,1.1];
handles.limits_signal=[.7,1,1.01,1.07];
handles.particletype='dielectric';
handles.signal_rect=[];
handles.fullwell=65535;

handles.analysis_complete=0;
handles=GUI_Analysis_displayUpdate(handles);
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = GUI_Analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ----------------------------------------------------------------------------------------------------------------------------------------------------------
%GUI Display Update Function
% ----------------------------------------------------------------------------------------------------------------------------------------------------------

function handles=GUI_Analysis_displayUpdate(handles)
%Updates GUI_Analysis Figure display objects to reflect current handles
%parameters




set(handles.edit_signaldir,'String',handles.signaldir);
set(handles.edit_refdir,'String',handles.refdir);
% set(handles.edit_chipname_signal,'String',handles.chipname_signal);
% set(handles.edit_chipname_reference,'String',handles.chipname_reference);

set(handles.text_imagesfound_signal,'String',['Images Found: ' num2str(handles.signal_imagesfound)]);
set(handles.edit_indices_signal,'String',num2str(handles.signal_indices));
set(handles.text_imagesfound_reference,'String',['Images Found: ' num2str(handles.reference_imagesfound)]);
set(handles.edit_indices_reference,'String',num2str(handles.reference_indices));

set(handles.edit_IntTh,'String',num2str(handles.IntTh));


set(handles.edit_ImScale,'String',num2str(handles.ImScale));

set(handles.edit_InnerRad,'String',num2str(handles.InnerRad));
set(handles.edit_OuterRad,'String',num2str(handles.OuterRad));

set(handles.edit_NA,'String',num2str(handles.NA));
set(handles.edit_backradius,'String',num2str(handles.backradius));

set(handles.edit_pixelsize,'String',num2str(handles.pixelsize));

set(handles.edit_limits_display,'String',num2str(handles.limits_display));
set(handles.edit_limits_signal,'String',num2str(handles.limits_signal));

set(handles.edit_signal_dataID,'String',num2str(handles.signal_dataID));
set(handles.edit_reference_dataID,'String',num2str(handles.reference_dataID));

set(handles.edit_crop_signal,'String',num2str(handles.crop_rect_image_signal));
set(handles.edit_crop_reference,'String',num2str(handles.crop_rect_image_reference));

set(handles.edit_fullwell,'String',num2str(handles.fullwell));


%Determine display type from kde radiobuttons
if get(handles.radiobutton_kde_norm,'Value')==1
    handles.display_options=1;
elseif get(handles.radiobutton_kde_raw,'Value')==1
    handles.display_options=2;
elseif get(handles.radiobutton_kde_reference,'Value')==1
    handles.display_options=3;
end

% if ~isempty(handles.signal_indices);
   
    if handles.display_options==3
        
        if ~isempty(handles.reference_indices);
            
            if handles.current_index>length(handles.reference_indices)
                handles.current_index=1;
            end
            set(handles.text_currentimage,'String',['Reference Image: ' num2str(handles.reference_indices(handles.current_index)) '/' num2str(handles.reference_imagesfound)...
                ' - Index: ' num2str(handles.current_index) '/' num2str(length(handles.reference_indices))]);
            
            set(handles.slider_currentimage,'Max',length(handles.reference_indices));
            set(handles.slider_currentimage,'Min',1);
            
            
            if length(handles.reference_indices)>1
                sliderstep=1/(length(handles.reference_indices)-1);
            else
                sliderstep=1;
            end
            
            handles.display_image_name=handles.reference_namelist{handles.reference_indices(handles.current_index)};
            handles.display_image_path=[handles.refdir,handles.display_image_name];
        else
            handles.display_image_name='';
            handles.display_image_path=[handles.refdir,handles.display_image_name];
        end
        
        
    else %display_options = 1 or 2
        
        if ~isempty(handles.signal_indices);
            
            if handles.current_index>length(handles.signal_indices)
                handles.current_index=1;
            end
            set(handles.text_currentimage,'String',['Signal Image: ' num2str(handles.signal_indices(handles.current_index)) '/' num2str(handles.signal_imagesfound)...
                ' - Index: ' num2str(handles.current_index) '/' num2str(length(handles.signal_indices))]);
            
            set(handles.slider_currentimage,'Max',length(handles.signal_indices));
            set(handles.slider_currentimage,'Min',1);
            
            if length(handles.signal_indices)>1
                sliderstep=1/(length(handles.signal_indices)-1);
            else
                sliderstep=1;
            end
            
            handles.display_image_name=handles.signal_namelist{handles.signal_indices(handles.current_index)};
            handles.display_image_path=[handles.signaldir,handles.display_image_name];
        else
            handles.display_image_name='';
            handles.display_image_path=[handles.signaldir,handles.display_image_name];
        end
        
    end
    
    if exist(handles.display_image_path,'file')==2
        
        
        set(handles.text_current_image_name,'String',['Filename: ' handles.display_image_name]);
        
        clear frame;
        clear data;
        
        load(handles.display_image_path);
        axes(handles.axes_image);
        
        
        set(handles.slider_currentimage,'SliderStep',[sliderstep,sliderstep]);
        set(handles.slider_currentimage,'Value',handles.current_index);
        
        if exist('frame')
            imshow(frame,[mean(frame(:))-2*std(frame(:)),mean(frame(:))+2*std(frame(:))]);
            handles.FOV=[size(frame,2),size(frame,1)];
        elseif exist('data');
            imshow(data,[mean(data(:))-2*std(data(:)),mean(data(:))+2*std(data(:))]);
            handles.FOV=[size(data,2),size(data,1)];
        end
        
        if ~isempty(handles.crop_rect_image_signal) && handles.display_options ~=3
            axes(handles.axes_image)
            hold on;
            rectangle('Position',handles.crop_rect_image_signal,'LineStyle','--','EdgeColor','w');
            hold off;
            
            set(handles.edit_crop_signal,'String',num2str(handles.crop_rect_image_signal));
            
        elseif ~isempty(handles.crop_rect_image_reference) && handles.display_options ==3
            axes(handles.axes_image)
            hold on;
            rectangle('Position',handles.crop_rect_image_reference,'LineStyle','--','EdgeColor','m');
            hold off;
        end
        
    else    
        axes(handles.axes_image);
        
        plot([3,3]);
        view(2)
    end
   
   
    
    %     imshow(I);
    if get(handles.radiobutton_colormap_jet,'Value')==1
        
        colormap(jet);
    else
        colormap(gray)
    end
    
    
    if ~isempty(handles.signal_indices);
        
        handles.analysis_path=[handles.signaldir handles.chipname_signal '_ANALYSIS_' handles.signal_namelist{handles.signal_indices(handles.current_index)}(end-9:end-4) '.mat'];
        
        
        if exist(handles.analysis_path,'file')==2
            load(handles.analysis_path);
            
            temp_analysis_data=analysis_data;
            clear analysis_data;
            
            if isfield(temp_analysis_data,'software_version') && (str2num(temp_analysis_data.software_version)>=handles.compatibility_min) %check analysis version compatibility
                
                axes(handles.axes_kde);
                hold off;
                
                if handles.display_options==1
                    surf(temp_analysis_data.kde_xticks,temp_analysis_data.kde_yticks,temp_analysis_data.signal_pdf_pos);
                    caxis([0,temp_analysis_data.color_max]);
                    view(2)
                    
                    shading interp;
                    set(gcf,'Renderer','zbuffer');
                    
                    set(handles.text_kde_count,'FontWeight','bold');
                    set(handles.text_kde_count_raw,'FontWeight','normal');
                    set(handles.text_kde_count_reference,'FontWeight','normal');
                    
                    if ~isempty(temp_analysis_data.crop_rect_signal)
                        axes(handles.axes_image)
                        hold on;
                        rectangle('Position',temp_analysis_data.crop_rect_signal,'LineStyle','-','EdgeColor','w');
                        hold off;
                        
                    end
                    
                    
                elseif handles.display_options==2
                    surf(temp_analysis_data.kde_xticks,temp_analysis_data.kde_yticks,temp_analysis_data.calc_pdf_displaylimits);
                    caxis([0,temp_analysis_data.color_max]);
                    view(2)
                    shading interp;
                    set(gcf,'Renderer','zbuffer');
                    
                    set(handles.text_kde_count,'FontWeight','normal');
                    set(handles.text_kde_count_raw,'FontWeight','bold');
                    set(handles.text_kde_count_reference,'FontWeight','normal');
                    
                    if ~isempty(temp_analysis_data.crop_rect_signal)
                        axes(handles.axes_image)
                        hold on;
                        rectangle('Position',temp_analysis_data.crop_rect_signal,'LineStyle','-','EdgeColor','w');
                        hold off;
                        
                    end
                    
                elseif handles.display_options==3
                    surf(temp_analysis_data.kde_xticks,temp_analysis_data.kde_yticks,temp_analysis_data.ref_pdf_displaylimits);
                    caxis([0,temp_analysis_data.color_max]);
                    view(2)
                    shading interp;
                    set(gcf,'Renderer','zbuffer');
                    
                    set(handles.text_kde_count,'FontWeight','normal');
                    set(handles.text_kde_count_raw,'FontWeight','normal');
                    set(handles.text_kde_count_reference,'FontWeight','bold');
                    
                    if ~isempty(temp_analysis_data.crop_rect_reference)
                        axes(handles.axes_image)
                        hold on;
                        rectangle('Position',temp_analysis_data.crop_rect_reference,'LineStyle','-','EdgeColor','m');
                        hold off;
                        
                    end
                   
                    
                end
                
                set(handles.text_saved_analysis_type,'String',['Analysis Type: ' temp_analysis_data.analysis_type_string]);
                
                
                
                cmax=temp_analysis_data.color_max;
                rect_analysis=temp_analysis_data.limits_signal;
                rect_analysis_xvector=[rect_analysis(1),rect_analysis(1),rect_analysis(2),rect_analysis(2),rect_analysis(1)];
                rect_analysis_yvector=[rect_analysis(3),rect_analysis(4),rect_analysis(4),rect_analysis(3),rect_analysis(3)];
                rect_analysis_zvector=[cmax,cmax,cmax,cmax,cmax];
                
                axes(handles.axes_kde);
                hold on;
                plot3(rect_analysis_xvector,rect_analysis_yvector,rect_analysis_zvector,'-g')
                hold off;
                view(2);
                
                
                if ~isempty(handles.signal_rect)
                    
                    %             cmax=temp_analysis_data.color_max;
                    rect_temp=handles.signal_rect;
                    rect_xvector=[rect_temp(1),rect_temp(1),rect_temp(1)+rect_temp(3),rect_temp(1)+rect_temp(3),rect_temp(1)];
                    rect_yvector=[rect_temp(2),rect_temp(2)+rect_temp(4),rect_temp(2)+rect_temp(4),rect_temp(2),rect_temp(2)];
                    rect_zvector=[cmax,cmax,cmax,cmax,cmax];
                    
                    axes(handles.axes_kde);
                    hold on;
                    plot3(rect_xvector,rect_yvector,rect_zvector,'--r')
                    hold off;
                    view(2);
                    
                end
                
                set(handles.text_kde_count,'String',['Normalized Count: ' num2str(temp_analysis_data.count_signal_normalized)]);
                set(handles.text_kde_count_raw,'String',['Raw Count: ' num2str(temp_analysis_data.count_signal_raw)]);
                set(handles.text_kde_count_reference,'String',['Reference Count: ' num2str(temp_analysis_data.count_reference)]);
                
            else
                
                disp(['Analysis file ' handles.analysis_path ' is incompatible with current software version.']);
                axes(handles.axes_kde);
                plot([3,3]);
                view(2)
            end
            
        else
            axes(handles.axes_kde);
            plot([3,3]);
            view(2)
            
        end
        
    else
        axes(handles.axes_kde);
        plot([3,3]);
        view(2)
    end
    

    
% else
%     axes(handles.axes_image);
%         plot([3,3]);
%         view(2)
%         
%         axes(handles.axes_kde);
%         plot([3,3]);
%         view(2)
%     
% end




% handles.analysis_readystatus=0;

% Update handles structure
guidata(handles.output, handles);

function handles = populate_chipname_signal(handles)
fileList = dir ([handles.signaldir '/'  '*' handles.signal_dataID '*' ...
    '.mat']);

fileNameList=struct();

for i = 1:length(fileList)
    [fileNameList] = DATA_scanFilenameAndProcess_GUI(handles,fileNameList,fileList(i).name,'signal');
end

signal_names=fieldnames(fileNameList);
if ~isempty(signal_names)
    set(handles.popupmenu_chipname_signal,'String',signal_names);
    set(handles.popupmenu_chipname_signal,'Value',1);
    handles.chipname_signal=signal_names{1};
else
    set(handles.popupmenu_chipname_signal,'String',{'N/A'});
    set(handles.popupmenu_chipname_signal,'Value',1);
    handles.chipname_signal='';
end


function handles = populate_chipname_reference(handles)
fileList = dir ([handles.refdir '/'  '*' handles.reference_dataID '*' ...
    '.mat']);

fileNameList=struct();

for i = 1:length(fileList)
    [fileNameList] = DATA_scanFilenameAndProcess_GUI(handles,fileNameList,fileList(i).name,'reference');
end

reference_names=fieldnames(fileNameList);
if ~isempty(reference_names)
    set(handles.popupmenu_chipname_reference,'String',reference_names);
    set(handles.popupmenu_chipname_reference,'Value',1);
    handles.chipname_reference=reference_names{1};
else
    set(handles.popupmenu_chipname_reference,'String',{'N/A'});
    set(handles.popupmenu_chipname_reference,'Value',1);
    handles.chipname_reference='';
end

% ----------------------------------------------------------------------------------------------------------------------------------------------------------
%Callback Functions - Pushbuttons, popup menus, and check boxes
% ----------------------------------------------------------------------------------------------------------------------------------------------------------
function checkbox_mirror_Callback(hObject, eventdata, handles)
val=get(hObject,'Value');

if val
    try
        [temp_name, temp_path]=uigetfile(handles.mirdir,'Select Mirror File');
        set(hObject,'String',['Mirror: ' temp_name]);
        handles.mirdir=temp_path;
        handles.mirname=temp_name;
    catch
        set(hObject,'String',['Mirror: N/A']);
    end
else
    handles.mirdir='';
    handles.mirname='';
    set(hObject,'String',['Mirror: N/A']);
end
guidata(handles.output, handles);
    




function popupmenu_chipname_signal_Callback(hObject, eventdata, handles)
temp_name=get(hObject,'String');
temp_val=get(hObject,'Value');
if strcmpi(temp_name{temp_val},'N/A')
    handles.chipname_signal='';
else
    handles.chipname_signal=temp_name{temp_val};
end

guidata(handles.output,handles);

function popupmenu_chipname_reference_Callback(hObject, eventdata, handles)
temp_name=get(hObject,'String');
temp_val=get(hObject,'Value');
if strcmpi(temp_name{temp_val},'N/A')
    handles.chipname_reference='';
else
    handles.chipname_reference=temp_name{temp_val};
end

guidata(handles.output,handles);



function pushbutton_signaldir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_signaldir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp_dir=uigetdir(handles.signaldir,'Select Signal Directory');

if temp_dir==0
    handles.signaldir='';
else
    
handles.signaldir=[temp_dir '\'];
end

handles=populate_chipname_signal(handles);

handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output, handles);

function pushbutton_refdir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.refdir)
temp_dir=uigetdir(handles.refdir,'Select Reference Directory');
else
    temp_dir=uigetdir(handles.signaldir,'Select Reference Directory');
end

if temp_dir==0
    handles.refdir='';
else
    handles.refdir=[temp_dir '\'];
end
handles=populate_chipname_reference(handles);
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output, handles);

function pushbutton_load_signal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% temp_name=get(handles.edit_chipname_signal,'String');
% temp_dataID=get(handles.edit_signal_dataID,'String');
file_path= [handles.signaldir handles.chipname_signal handles.signal_dataID];     
FileList = dir([file_path '*' '.mat']);
FileCount = size(FileList,1);

if (FileCount==0) || (isempty(handles.chipname_signal))
    disp('Signal directory or chipname is invalid');
else
    for i=1:FileCount
        namelist{i}=FileList(i).name;
    end
    
%     handles.chipname_signal=temp_name;
%     handles.signal_dataID=temp_dataID;
    handles.signal_namelist = namelist;
    handles.signal_imagesfound = FileCount;
    handles.signal_indices = 1:FileCount;
    handles.current_index=1;

end

handles=GUI_Analysis_displayUpdate(handles);

guidata(handles.output,handles);

function pushbutton_load_reference_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% temp_name=get(handles.edit_chipname_reference,'String');
% temp_dataID=get(handles.edit_reference_dataID,'String');
file_path= [handles.refdir handles.chipname_reference handles.reference_dataID];     
FileList = dir([file_path '*' '.mat']);
FileCount = size(FileList,1);

if (FileCount==0) || (isempty(handles.chipname_signal))
    disp('Signal directory or chipname is invalid');
else
    for i=1:FileCount
        namelist{i}=FileList(i).name;
    end
    
%     handles.chipname_reference=temp_name;
%     handles.reference_dataID=temp_dataID;
    handles.reference_namelist = namelist;
    handles.reference_imagesfound = FileCount;
    handles.reference_indices = 1:FileCount;

end

handles=GUI_Analysis_displayUpdate(handles);

guidata(handles.output,handles);

function pushbutton_measureNA_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_measureNA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
measured_pdata=filescan_measureCurrentNA(handles,handles.signaldir,[handles.chipname_signal,handles.signal_dataID],handles.signal_indices,'signal');


function pushbutton_analyzeChip_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analyzeChip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, signal ] = eval_chip_SPIRIS2_GUI(handles);
handles.ANALYSIS_output=signal;
handles=GUI_Analysis_displayUpdate(handles);

guidata(handles.output,handles);

% --- Executes on button press in pushbutton_set_signal_limits.
function pushbutton_set_signal_limits_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_signal_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.axes_kde);
handles.signal_rect=getrect(handles.axes_kde);
handles.limits_signal=[handles.signal_rect(1),handles.signal_rect(1)+handles.signal_rect(3),...
    handles.signal_rect(2),handles.signal_rect(2)+handles.signal_rect(4)];
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

% --- Executes on button press in pushbutton_clear_signal_limits.
function pushbutton_clear_signal_limits_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_signal_limits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.signal_rect=[];
handles.limits_signal=handles.limits_display;
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);



function pushbutton_savedata_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function pushbutton_loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function pushbutton_outputexcel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outputexcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultname=[handles.signaldir,handles.chipname_signal,'_analysis.xls'];
[filename,pathname,filterindex]=uiputfile('.xls','Save Analysis Spreadsheet',defaultname);

if ~isempty(filename)
    
    handles.current_index=1;
    handles=GUI_Analysis_displayUpdate(handles);
    
    chipname_length=length(handles.chipname_signal);
    ID_length=length(handles.signal_dataID);
    
    
    excel_array = {'Filename','Image Index','Signal Limits','Analysis Type','Normalized Count','Raw Count','Reference Count','Confidence Ratio','Crop Area (mm^2)','Signal Density'};
    for i=1:length(handles.signal_indices)
        analysis_path=[handles.signaldir handles.chipname_signal '_ANALYSIS_' handles.signal_namelist{handles.signal_indices(i)}(end-9:end-4) '.mat'];
        clear(analysis_path);
        load(analysis_path);
        %loads analysis_data
        if ~isempty(analysis_data.crop_rect_signal)
        crop_area=analysis_data.crop_rect_signal(3)*analysis_data.crop_rect_signal(4)*(handles.pixelsize*.001)^2;
        else
            crop_area=1600*1200*(handles.pixelsize*.001)^2;
        end
        
        excel_line={handles.signal_namelist{handles.signal_indices(i)},[num2str(handles.signal_indices(i)) ' of ' num2str(length(handles.signal_indices))],...
            num2str(analysis_data.limits_signal),analysis_data.analysis_type_string,analysis_data.count_signal_normalized,analysis_data.count_signal_raw,analysis_data.count_reference,...
            analysis_data.count_signal_normalized/analysis_data.count_reference,crop_area,analysis_data.count_signal_normalized./crop_area};
       
        excel_array=[excel_array;excel_line];
    end
    
    xlswrite([pathname,filename],excel_array);
    disp(['Output written to ' filename]);
    
        
end
    
        




function pushbutton_resetGUI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.output);
h=GUI_Analysis;

function pushbutton_set_crop_signal_Callback(hObject, eventdata, handles)
crop_rect_user_signal=getrect(handles.axes_image);
crop_rect_image_signal=round(crop_rect_user_signal);

if (crop_rect_image_signal(1)<1) || (crop_rect_image_signal(1) > handles.FOV(1))
    crop_rect_image_signal(1)=1;
end

if (crop_rect_image_signal(2)<1) || (crop_rect_image_signal(2) > handles.FOV(2))
    crop_rect_image_signal(2)=1;
end

if (crop_rect_image_signal(1)+crop_rect_image_signal(3)) > handles.FOV(1)
    crop_rect_image_signal(3)=handles.FOV(1)-crop_rect_image_signal(1);
end

if (crop_rect_image_signal(2)+crop_rect_image_signal(4)) > handles.FOV(2)
    crop_rect_image_signal(4)=handles.FOV(2)-crop_rect_image_signal(2);
end

handles.crop_rect_image_signal=crop_rect_image_signal;

handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);





function pushbutton_set_crop_reference_Callback(hObject, eventdata, handles)
crop_rect_user_reference=getrect(handles.axes_image);
crop_rect_image_reference=round(crop_rect_user_reference);

if (crop_rect_image_reference(1)<1) || (crop_rect_image_reference(1) > handles.FOV(1))
    crop_rect_image_reference(1)=1;
end

if (crop_rect_image_reference(2)<1) || (crop_rect_image_reference(2) > handles.FOV(2))
    crop_rect_image_reference(2)=1;
end

if (crop_rect_image_reference(1)+crop_rect_image_reference(3)) > handles.FOV(1)
    crop_rect_image_reference(3)=handles.FOV(1)-crop_rect_image_reference(1);
end

if (crop_rect_image_reference(2)+crop_rect_image_reference(4)) > handles.FOV(2)
    crop_rect_image_reference(4)=handles.FOV(2)-crop_rect_image_reference(2);
end

handles.crop_rect_image_reference=crop_rect_image_reference;

handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function pushbutton_clear_crop_signal_Callback(hObject, eventdata, handles)
handles.crop_rect_image_signal=[];
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function pushbutton_clear_crop_reference_Callback(hObject, eventdata, handles)
handles.crop_rect_image_reference=[];
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);


function pushbutton_sync_crop_Callback(hObject, eventdata, handles)
handles.crop_rect_image_reference=handles.crop_rect_image_signal;
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function pushbutton_load_current_index_Callback(hObject, eventdata, handles)

index_temp=handles.signal_indices(handles.current_index);
outofrange=(index_temp(:)>handles.signal_imagesfound) | (index_temp(:)<1);

if (~isempty(index_temp)) && (sum(outofrange(:))==0)
    handles.signal_indices=index_temp;
    handles.reference_indices=index_temp;
end
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function pushbutton_analyzeZstack_Callback(hObject, eventdata, handles)

handles.limits_display=[-1,1,.8,1.2];
handles.limits_signal=[-1,1,.8,1.2];
handles.IntTh=.1;
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);
% [ output ] = ALIGN_zstack_calibrate_par(handles);
[ output ] = ALIGN_zstack_calibrate_par_diffG(handles);

% [ output ] = ALIGN_zstack_calibrate(handles);
% output=concentrator_align_script(handles);
% save('C:\User_Scratch\1 - Jake - keep\Data\022114 - alignment testing\ZSCAN_DATA_p2.mat','output');

% --- Executes on button press in pushbutton_circles.
function pushbutton_circles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_circles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
output=circle_particles(handles);





% ----------------------------------------------------------------------------------------------------------------------------------------------------------
%Callback Functions - Radiobuttons and Sliders
% ----------------------------------------------------------------------------------------------------------------------------------------------------------

function slider_currentimage_Callback(hObject, eventdata, handles)
% hObject    handle to slider_currentimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

new_pos=round(get(hObject,'Value'));
handles.current_index=new_pos;
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

% --- Executes when selected object is changed in panel_analysis_type.
function panel_analysis_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_analysis_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton_analysis_type1,'Value')==1
    handles.analysis_type='raw';
elseif get(handles.radiobutton_analysis_type2,'Value')==1
    if ~isempty(handles.signal_indices) && ~isempty(handles.reference_indices) && (length(handles.signal_indices)==length(handles.reference_indices))
        handles.analysis_type='match';
    else
        set(handles.radiobutton_analysis_type1,'Value',1);
%         set(handles.radiobutton_analysis_type2,'Value',0);
        disp('Number of Signal and Reference indices must be equal');
    end
    
else
    
     if ~isempty(handles.signal_indices) && ~isempty(handles.reference_indices)
        handles.analysis_type='average';
    else
        set(handles.radiobutton_analysis_type1,'Value',1);
%         set(handles.radiobutton_analysis_type3,'Value',0);
        disp('Signal and Reference datasets must first be loaded');
    end
end
guidata(handles.output,handles);

% --- Executes when selected object is changed in panel_particle_type.
function panel_particle_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_particle_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton_particletype_dielectric,'Value')==1
    handles.particletype='dielectric';
elseif get(handles.radiobutton_particletype_gold,'Value')==1
    handles.particletype='gold';
end

guidata(handles.output,handles);

% --- Executes when selected object is changed in kde_type.
function kde_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in kde_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

% --- Executes when selected object is changed in colormap_type.
function colormap_type_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in colormap_type 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);


function panel_cropping_method_SelectionChangeFcn(hObject, eventdata, handles)

% ----------------------------------------------------------------------------------------------------------------------------------------------------------
%Callback Functions - Edit Boxes
% ----------------------------------------------------------------------------------------------------------------------------------------------------------

function edit_crop_signal_Callback(hObject, eventdata, handles)


function edit_indices_signal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_indices_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_indices_signal as text
%        str2double(get(hObject,'String')) returns contents of edit_indices_signal as a double
indices_temp=str2num(get(hObject,'String'));
outofrange=(indices_temp(:)>handles.signal_imagesfound) | (indices_temp(:)<1);

if (~isempty(indices_temp)) && (sum(outofrange(:))==0)
    handles.signal_indices=indices_temp;
end
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_indices_reference_Callback(hObject, eventdata, handles)
% hObject    handle to edit_indices_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_indices_reference as text
%        str2double(get(hObject,'String')) returns contents of edit_indices_reference as a double
indices_temp=str2num(get(hObject,'String'));
outofrange=(indices_temp(:)>handles.reference_imagesfound) | (indices_temp(:)<1);

if (~isempty(indices_temp)) && (sum(outofrange(:))==0)
    handles.reference_indices=indices_temp;
end
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_reference_dataID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_reference_dataID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_reference_dataID as text
%        str2double(get(hObject,'String')) returns contents of edit_reference_dataID as a double

handles.reference_dataID=get(handles.edit_reference_dataID,'String');
handles=populate_chipname_reference(handles);
guidata(handles.output,handles);






function edit_signal_dataID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_signal_dataID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_signal_dataID as text
%        str2double(get(hObject,'String')) returns contents of edit_signal_dataID as a double

handles.signal_dataID=get(handles.edit_signal_dataID,'String');
handles=populate_chipname_signal(handles);
guidata(handles.output,handles);


function edit_refdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_refdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_refdir as text
%        str2double(get(hObject,'String')) returns contents of edit_refdir as a double

function edit_chipname_reference_Callback(hObject, eventdata, handles)
% hObject    handle to edit_chipname_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_chipname_reference as text
%        str2double(get(hObject,'String')) returns contents of edit_chipname_reference as a double

function edit_chipname_signal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_chipname_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_chipname_signal as text
%        str2double(get(hObject,'String')) returns contents of edit_chipname_signal as a double

function edit_signaldir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_signaldir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_signaldir as text
%        str2double(get(hObject,'String')) returns contents of edit_signaldir as a double

function edit_IntTh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_IntTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_IntTh as text
%        str2double(get(hObject,'String')) returns contents of edit_IntTh as a double
handles.IntTh=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_ImScale_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ImScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_ImScale as text
%        str2double(get(hObject,'String')) returns contents of edit_ImScale as a double
handles.ImScale=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);

guidata(handles.output,handles);

function edit_InnerRad_Callback(hObject, eventdata, handles)
% hObject    handle to edit_InnerRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_InnerRad as text
%        str2double(get(hObject,'String')) returns contents of edit_InnerRad as a double
handles.InnerRad=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_OuterRad_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OuterRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_OuterRad as text
%        str2double(get(hObject,'String')) returns contents of edit_OuterRad as a double
handles.OuterRad=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_NA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_NA as text
%        str2double(get(hObject,'String')) returns contents of edit_NA as a double
handles.NA=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_backradius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_backradius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_backradius as text
%        str2double(get(hObject,'String')) returns contents of edit_backradius as a double
handles.backradius=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_limits_display_Callback(hObject, eventdata, handles)
% hObject    handle to edit_limits_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_limits_display as text
%        str2double(get(hObject,'String')) returns contents of edit_limits_display as a double
handles.limits_display=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_limits_signal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_limits_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_limits_signal as text
%        str2double(get(hObject,'String')) returns contents of edit_limits_signal as a double
handles.limits_signal=str2num(get(hObject,'String'));


handles.signal_rect=[handles.limits_signal(1),handles.limits_signal(3),handles.limits_signal(2)-handles.limits_signal(1),...
    handles.limits_signal(4)-handles.limits_signal(3)];
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

function edit_pixelsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_pixelsize as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelsize as a double
handles.pixelsize=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);


function edit_fullwell_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fullwell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fullwell=str2num(get(hObject,'String'));
handles=GUI_Analysis_displayUpdate(handles);
guidata(handles.output,handles);

% ----------------------------------------------------------------------------------------------------------------------------------------------------------
% Create Functions
% ----------------------------------------------------------------------------------------------------------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function edit_reference_dataID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_reference_dataID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_signal_dataID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_signal_dataID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_indices_reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_indices_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_refdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_refdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_chipname_reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_chipname_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_chipname_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_chipname_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_signaldir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_signaldir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_indices_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_indices_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slider_currentimage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_currentimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit_IntTh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_IntTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_ImScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ImScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_InnerRad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_InnerRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_OuterRad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OuterRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_NA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_limits_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_limits_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_limits_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_limits_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_pixelsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_backradius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_backradius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_crop_signal_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit_crop_reference_Callback(hObject, eventdata, handles)


function edit_crop_reference_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function popupmenu_chipname_signal_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function popupmenu_chipname_reference_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function edit_fullwell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fullwell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end