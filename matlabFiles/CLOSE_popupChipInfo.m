function CLOSE_popupChipInfo(hObject, eventdata)
handles = guidata(hObject);

if handles.keep == 1
    [handles.mainGUI] = setParams(handles.mainGUI,'Directory',getParams(handles,'Directory'));
    [handles.mainGUI] = setParams(handles.mainGUI,'ChipID',getParams(handles,'ChipID'));
    [handles.mainGUI] = setParams(handles.mainGUI,'ArrayX',getParams(handles,'ArrayX'));
    [handles.mainGUI] = setParams(handles.mainGUI,'ArrayY',getParams(handles,'ArrayY'));
    [handles.mainGUI] = setParams(handles.mainGUI,'PitchX',getParams(handles,'PitchX'));
    [handles.mainGUI] = setParams(handles.mainGUI,'PitchY',getParams(handles,'PitchY'));
    [handles.mainGUI] = setParams(handles.mainGUI,'ScanType',getParams(handles,'ScanType')); %Update pre/post scan
    [handles.mainGUI] = setParams(handles.mainGUI,'ParticleType',getParams(handles,'ParticleType'));
    [handles.mainGUI] = setParams(handles.mainGUI,'MinHist',getParams(handles,'MinHist'));
    [handles.mainGUI] = setParams(handles.mainGUI,'MaxHist',getParams(handles,'MaxHist'));
    [handles.mainGUI] = setParams(handles.mainGUI,'RefParticleType',getParams(handles,'RefParticleType'));
    [handles.mainGUI] = setParams(handles.mainGUI,'RefMinHist',getParams(handles,'RefMinHist'));
    [handles.mainGUI] = setParams(handles.mainGUI,'RefMaxHist',getParams(handles,'RefMaxHist'));
end

% [handles.mainGUI] = CONTROL_WelcomeBtns(handles.mainGUI, 1);
guidata(handles.mainGUI.panels.figure,handles.mainGUI);
delete(handles.popupFigure);