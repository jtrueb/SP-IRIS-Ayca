function [handles] = CONTROL_StageBtns(handles)
%Disables the stage movement btns if the stage isn't attached
useStages = getParams(handles,'EnableStages');

if useStages
    state = 'on';
    if strcmpi(getParams(handles,'StageType'),'V1')
        [handles] = CONTROL_WelcomeBtns(handles, 1);%Enables only load chip
        [handles] = CONTROL_Tabs(handles,7);%Disables only Instrument tab
    elseif strcmpi(getParams(handles,'StageType'),'V3') %SP-A1000, do same as prototype, dsf 2014-03-11
        [handles] = CONTROL_WelcomeBtns(handles, 1);%Enables only load chip
        [handles] = CONTROL_Tabs(handles,7);%Disables only Instrument tab
    elseif strcmpi(getParams(handles,'StageType'),'V5') %hybrid, do same as v3, jtt 2014-4-28
        [handles] = CONTROL_WelcomeBtns(handles, 1);%Enables only load chip
        [handles] = CONTROL_Tabs(handles,7);%Disables only Instrument tab
    else
        [handles] = CONTROL_WelcomeBtns(handles, 2);%Enables only load chip
        [handles] = CONTROL_Tabs(handles,0);%Disables only Instrument tab
        [handles] = setParams(handles,'ChipLoadStatus',1);
        [handles] = STAGE_home(handles);
    end
else
    state = 'off';
    [handles] = CONTROL_WelcomeBtns(handles, 100);%Disables all Welcome Btns
    [handles] = CONTROL_Tabs(handles,8);%Disables only Welcome tab
end

set(handles.btnAutofocus,'Enable',state);
set(handles.btnFocusPlane,'Enable',state);
set(handles.editZPos,'Enable',state);
set(handles.editZStep,'Enable',state);
set(handles.btnZUp,'Enable',state);
set(handles.btnZDown,'Enable',state);
set(handles.editXPos,'Enable',state);
set(handles.editYPos,'Enable',state);
set(handles.btnMoveYUp,'Enable',state);
set(handles.btnMoveYDown,'Enable',state);
set(handles.btnMoveXRight,'Enable',state);
set(handles.btnMoveXLeft,'Enable',state);
set(handles.radUser,'Enable',state);
set(handles.radFOV,'Enable',state);
set(handles.radPitch,'Enable',state);
set(handles.chkSmartMove,'Enable',state);
set(handles.btnPreviewArray,'Enable',state);
set(handles.btnScanArray,'Enable',state);
set(handles.btnDefocusScan,'Enable',state);
set(handles.btnSaveMinimap,'Enable',state);
set(handles.editMinimapContrast,'Enable',state);
set(handles.editZOffset,'Enable',state);
set(handles.editZMax,'Enable',state);
set(handles.editXMax,'Enable',state);
set(handles.editYMax,'Enable',state);