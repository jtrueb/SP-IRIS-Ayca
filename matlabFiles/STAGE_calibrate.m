function handles = STAGE_calibrate(handles)
%callback function - Initializes stages and focuses sample
% guidata(hObject, handles); %save handles data

useStages = getParams(handles,'EnableStages');
calibrated_stages = 0;

whatstages=getParams(handles,'StageType');



if useStages
    if strcmpi(whatstages,'V5')
        %initialze pps-20 z
         
            msg = 'Initializing Z'; feedbackLvl = 1; errorFlag = 0;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                handles.txtLog,feedbackLvl,errorFlag);
            
            STAGE_MMC_HOME_hybrid(handles.Stage)
            
            [handles] = setParams(handles,'StageInitStatus',1);
            msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
            calibrated_stages = 1;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                handles.txtLog,feedbackLvl,errorFlag);
        
            
%             initialize vt-21 xy
                msg = 'Initializing xy'; feedbackLvl = 1; errorFlag = 0;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                    handles.txtLog,feedbackLvl,errorFlag);
                
                if handles.Stage.powerOff
                    STAGE_setVoltage(handles.Stage, [handles.Stage.axis.Vx handles.Stage.axis.Vy]);
                end
                STAGE_calibrate_polluxHybrid(handles.Stage)
%                 [handles.Stage] = STAGE_getVoltageForStages(handles.Stage);
                
                [handles] = setParams(handles,'StageInitStatus',1);
                msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
                calibrated_stages = 1;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                    handles.txtLog,feedbackLvl,errorFlag);
        
    elseif strcmpi(whatstages,'V6')
         msg = 'Initializing Z'; feedbackLvl = 1; errorFlag = 0;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                handles.txtLog,feedbackLvl,errorFlag);
            
            STAGE_MMC_HOME_V6(handles.Stage)
            
            [handles] = setParams(handles,'StageInitStatus',1);
            msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
            calibrated_stages = 1;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                handles.txtLog,feedbackLvl,errorFlag);
        
        
    end
else
        
        if isfield(handles.Stage,'mmc_host') %hybrid PPS-20/VT-21
            [handles] = LEDS_setState(handles,'Status');
            msg = 'Initializing'; feedbackLvl = 1; errorFlag = 0;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                handles.txtLog,feedbackLvl,errorFlag);
            
            STAGE_MMC_HOME(handles.Stage)
            
            [handles] = setParams(handles,'StageInitStatus',1);
            msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
            calibrated_stages = 1;
            [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                  handles.txtLog,feedbackLvl,errorFlag);
        end
            if isfield(handles.Stage,'host')
                [handles] = LEDS_setState(handles,'Status');
                msg = 'Initializing'; feedbackLvl = 1; errorFlag = 0;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                    handles.txtLog,feedbackLvl,errorFlag);
                
                if handles.Stage.powerOff
                    STAGE_setVoltage(handles.Stage, [handles.Stage.axis.Vx handles.Stage.axis.Vy handles.Stage.axis.Vz]);
                end
                STAGE_calibrateAndUnlock(handles.Stage)
                [handles.Stage] = STAGE_getVoltageForStages(handles.Stage);
                
                [handles] = setParams(handles,'StageInitStatus',1);
                msg = 'Complete'; feedbackLvl = 1; errorFlag = 0;
                calibrated_stages = 1;
                [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,...
                    handles.txtLog,feedbackLvl,errorFlag);
            end
end
    
    if (calibrated_stages == 0)
        msg = 'Not connected to stages (handles.Stage.Serial DNE)';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.stage,handles.txtLog);
    end
end
