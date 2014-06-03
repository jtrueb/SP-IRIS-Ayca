function GUI_Callback_btnProcessGUI(hObject,eventdata)

GUI_Analysis;

[handles] = guidata(hObject);

% addpath(handles.const.directories.detection);
% cd(handles.const.directories.detection);
% run('SIFTParticleDetection');

% particle_type = getParams(handles,'ParticleType');
% [minSize] = getParams(handles,'MinHist');
% [maxSize] = getParams(handles,'MaxHist');
% [Prescan] = getParams(handles,'Prescan');
% [Postscan] = getParams(handles,'Postscan');
% [particle_count] = spd_automated(handles,data,particle_type,maxSize,minSize); %Detect particles
% msg = ['Number of particles detected: ' num2str(particle_count)];

msg = 'GUI_Analysis module activated';
[handles] = GUI_logMsg(handles,msg,handles.const.log.particlefinder,handles.txtLog,1,0);

guidata(hObject,handles);