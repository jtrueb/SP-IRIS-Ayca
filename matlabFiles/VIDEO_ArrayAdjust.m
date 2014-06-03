function VIDEO_ArrayAdjust(hObject, eventdata)
[handles] = guidata(hObject);

figure(handles.icon);
set(handles.icon,'WindowStyle','modal');

vid_name = getParams(handles.mainGUI,'adjustGIF');
vid = VideoReader(vid_name);

nFrames = vid.NumberOfFrames;
vidHeight = vid.Height;
vidWidth = vid.Width;

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
    'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames
    temp = read(vid, k);
    mov(k).cdata = temp;
end

% Play back the movie once at the video's frame rate.
movie(handles.icon, mov, 1, vid.FrameRate*1);
clear mov;

set(handles.icon,'WindowStyle','normal');
figure(handles.popupFigure);