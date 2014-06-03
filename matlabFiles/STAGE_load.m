function handles = STAGE_load(handles)
%callback function - Initializes stages and focuses sample
% guidata(hObject, handles); %save handles data

%% Move stage to door for loading
if handles.Stage.enabled > 0 %check for common thing, not just Pollux, dsf 2014-03-11
    msg = 'Moving to load position'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
        handles.txtLog,feedbackLvl,errorFlag);
    
    %% DSF, move Z to zero first to not crash stage, extra paranoid
    axes = {handles.Stage.axis.z};
    pos = 0;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
    
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = getParams(handles,'StageLoadPos');
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
    
    %% DSF, move Z to zero first to not crash stage, extra paranoid
    %axes = {handles.Stage.axis.z handles.Stage.axis.y handles.Stage.axis.x};
    %pos = [pos2(3) pos2(2) pos2(1)];
    
%     [handles] = STAGE_MoveAbsolute(handles,axes,pos);
    
    [handles ] = setParams(handles,'ChipLoadStatus',1);
    msg = 'Ready for loading'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    msg = 'Not connected to stages (handles.Stage.Serial DNE)';
    [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,handles.txtLog);
end