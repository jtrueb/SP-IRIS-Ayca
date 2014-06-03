function [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,steps)
%This function will move the stage to an absolute position. 
%It moves all three axes. Z is derived from the surface plane

%handles.Stage is a struct created by STAGES_INIT

%axes a cell array of strings of the axis(es) one desires to move
% i.e. {1} or {stages.axis.x} or 
% {stages.axis.x,stages.axis.y,stages.axis.z}, etc.

%steps must be the same length as axes and corresponds to the distance in
%mm one desires to move each axis. 
% i.e. [0.4] or [1.3 -3.3] or [-2.3 4.5 -5.55]

whatstages=getParams(handles,'StageType');

[handles] = STAGE_checkStatus(handles);
[handles] = CONTROL_MoveBtns(handles, 0);
xInd = find(strcmpi(axes,handles.Stage.axis.x),1);
yInd = find(strcmpi(axes,handles.Stage.axis.y),1);
zInd = find(strcmpi(axes,handles.Stage.axis.z),1);
backlash = getParams(handles,'Backlash');
[x y z] = STAGE_getPositions(handles.Stage);
zSlow=10;
zMed=100;
zFast=1000;










%Backlash correction
if ~isempty(xInd)
    xPos = getParams(handles,'XPos');
%     if steps(xInd) < xPos %Moving Right?
        %Move further right then back left
        handles = setParams(handles,'XPos',steps(xInd)-backlash(1));
%         STAGE_move(handles.Stage,axes(xInd),steps(xInd)-backlash(1),handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
%     end    
end

if ~isempty(yInd)
    yPos = getParams(handles,'YPos');
%     if steps(yInd) > yPos %Moving Up?
        %Move further up then back down
        handles = setParams(handles,'YPos',steps(yInd)+backlash(2));
%         STAGE_move(handles.Stage,axes(yInd),steps(yInd)+backlash(2),handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
%     end
end

% pause(.25);

[z_plane_out] = STAGE_SmartMove_CalcZ(handles,steps);

if (~strcmpi(handles.Stage.version,'V5'))&&(~strcmpi(handles.Stage.version,'V3'))&&(~strcmpi(handles.Stage.version,'V6'));
    
    xyVel = getParams(handles,'XYVelocity');
    zVel = getParams(handles,'ZVelocity');
    
    
    if(~isempty(zInd))
        if(abs(z-z_plane_out) <= 1)
            if(zVel~=zSlow)
                [handles] = setParams(handles,'ZVelocity',zSlow);
            end
        elseif(abs(z-z_plane_out) < 50)
            if(zVel~=zMed)
                [handles] = setParams(handles,'ZVelocity',zMed);
            end
        else
            if(zVel~=zFast)
                [handles] = setParams(handles,'ZVelocity',zFast);
            end
        end
    end
    
end

[handles] = STAGE_updatePos(handles,axes,[steps z_plane_out],handles.Stage.commands.move_absolute);
[handles] = CONTROL_MoveBtns(handles, 1);
[handles] = IMAGE_Minimap_display(handles);