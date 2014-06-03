function handles = GUI_makePopup_LoadChip(handles)
%% Constants
[color] =  GUI_Colors();
fHeight = 75;
fWidth = 350;

%% Display loading video
pos = get(handles.panels.figure,'Position');

% Size a figure based on the video's width and height.
vidHeight = 300;
vidWidth = 700;
Icon = figure('Position',[pos(1) pos(2)+pos(4)/2-vidHeight/2 vidWidth vidHeight],...
    'WindowStyle','modal','MenuBar','none','Resize','off','Visible','off');
 
% vid = getParams(handles,'loadGIF');
% vids{1} = VideoReader(vid{1});
% vids{2} = VideoReader(vid{2});
% vids{3} = VideoReader(vid{3});
% vids{4} = VideoReader(vid{4});
% 
% 
% for i = 1:size(vids,2)
%     nFrames = vids{i}.NumberOfFrames;
%     vidHeight = vids{i}.Height;
%     vidWidth = vids{i}.Width;
%     
%     % Preallocate movie structure.
%     mov(1:nFrames) = ...
%         struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
%         'colormap', []);
%     hStart = {100; 185; 50; 150};
%     hEnd = {400; 485; 350; 450};
%     
%     wStart = {400; 460; 400; 400};
%     wEnd = {1100; 1160; 1100; 1100};
%     
%     % Read one frame at a time.
%     for k = 1 : nFrames
%         temp = read(vids{i}, k);
%         mov(k).cdata = temp(hStart{i}:hEnd{i},wStart{i}:wEnd{i},:);
%     end
%             
%     % Play back the movie once at the video's frame rate.
%     if i == 3
%         movie(Icon, mov, 1, vids{i}.FrameRate*15);
%     else
%         movie(Icon, mov, 1, vids{i}.FrameRate*3);
%     end
%     clear mov;
% end
% set(Icon,'WindowStyle','normal');

%% Display message
popupFigure = figure('Toolbar','none','Menu','none','Units','pixel',...
    'WindowStyle','modal',...
    'Resize','off','position',[pos(1) pos(2)+pos(4)/2-fHeight/2 fWidth fHeight],...
    'NumberTitle','off',...
    'tag','popupFigure',...
    'CloseRequestFcn',@CLOSE_popupLoadChip,...
    'Name','How to Load Chip');

txtLoadChip = uicontrol(popupFigure,'Style','text',...
    'BackgroundColor',color.bgc{3},...
    'FontSize',10,...
    'String','Slide door open. Load chip. Slide door close.','Units','normalized',...
    'HorizontalAlignment','Center',...
    'Position',[0.01 0.5 0.98 0.4]);

btnContinue  = uicontrol(popupFigure,'Tag','btnContinue',...
    'Style','pushbutton',...
    'String','Continue','Units','normalized',...
    'Callback',@CLOSE_popupLoadChip,...
    'HorizontalAlignment','Left',...
    'Position',[0.05 0.01 0.3 0.45]);

btnReplay  = uicontrol(popupFigure,'Tag','btnReplay',...
    'Style','pushbutton',...
    'String','Play Load Video','Units','normalized',...
    'Callback',@VIDEO_LoadChip,...
    'HorizontalAlignment','Left',...
    'Position',[0.55 0.01 0.3 0.45]);

handles_popup = guihandles(popupFigure);
handles_popup.icon = Icon;
handles_popup.mainGUI = handles;
guidata(popupFigure, handles_popup); %save handles data
