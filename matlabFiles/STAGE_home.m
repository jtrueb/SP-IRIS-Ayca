function handles = STAGE_home(handles)
%callback function - Initializes stages and focuses sample
% guidata(hObject, handles); %save handles data


if handles.Stage.enabled > 0
    msg = 'Homing'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
        handles.txtLog,feedbackLvl,errorFlag);
    
    %% MOVE TO HOME POS
    axes2 = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    home2 = getParams(handles,'StageHomePos');
    
    
    

    if getParams(handles,'SmartMove');
        axes = axes2;
        pos = home2(1:2);
        [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
    else
        whatstages=getParams(handles,'StageType');
        if strcmpi(whatstages,'V5')||strcmpi(whatstages,'V6');
            [handles] = STAGE_MoveAbsolute(handles,axes2,home2);
        else
            
            axes = {axes2{3} axes2{2} axes2{1}};
            home = [home2(3) home2(2) home2(1)];
            
            pos = home;
            [handles] = STAGE_MoveAbsolute(handles,axes,pos);
        end
    end

    [handles] = setParams(handles,'StageHomeStatus',1);
    msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
    [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
        handles.txtLog,feedbackLvl,errorFlag);
else
    msg = 'Not connected to stages (handles.Stage.Serial DNE)';
    [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,handles.txtLog);
end
