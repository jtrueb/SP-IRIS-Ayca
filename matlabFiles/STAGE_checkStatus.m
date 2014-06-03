function [handles] = STAGE_checkStatus(handles)
%Checks if the instrument has been power cycled
%Recalibrates the stages if yes.

[handles] = LEDS_setState(handles,'Status');
if ~getParams(handles,'SystemStatus')
    pos = getParams(handles,'Stage_Pos');
    [handles] = STAGE_calibrate(handles);
    
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end