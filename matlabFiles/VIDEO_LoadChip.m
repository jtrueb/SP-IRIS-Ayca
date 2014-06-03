function VIDEO_LoadChip(hObject, eventdata)
[handles] = guidata(hObject);

figure(handles.icon);
set(handles.icon,'WindowStyle','modal');

vid = getParams(handles.mainGUI,'loadGIF');
vids{1} = VideoReader(vid{1});
vids{2} = VideoReader(vid{2});
vids{3} = VideoReader(vid{3});
vids{4} = VideoReader(vid{4});

for i = 1:size(vids,2)
    nFrames = vids{i}.NumberOfFrames;
    vidHeight = vids{i}.Height;
    vidWidth = vids{i}.Width;
    
    % Preallocate movie structure.
    mov(1:nFrames) = ...
        struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
        'colormap', []);
    hStart = {100; 185; 50; 150};
    hEnd = {400; 485; 350; 450};
    
    wStart = {400; 460; 400; 400};
    wEnd = {1100; 1160; 1100; 1100};
    
    % Read one frame at a time.
    for k = 1 : nFrames
        temp = read(vids{i}, k);
        mov(k).cdata = temp(hStart{i}:hEnd{i},wStart{i}:wEnd{i},:);
    end
            
    % Play back the movie once at the video's frame rate.
    if i == 3
        movie(handles.icon, mov, 1, vids{i}.FrameRate*15);
    else
        movie(handles.icon, mov, 1, vids{i}.FrameRate*3);
    end
    clear mov;
end
set(handles.icon,'WindowStyle','normal');
figure(handles.popupFigure);