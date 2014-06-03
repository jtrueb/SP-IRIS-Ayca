function [handles] = STAGE_MoveAbsolute(handles,axes,steps)
%This function will move the stage to an absolute position. 
%It can move one, two, or all three axes. 

%handles.Stage is a struct created by STAGES_INIT

%axes a cell array of strings of the axis(es) one desires to move
% i.e. {1} or {stages.axis.x} or 
% {stages.axis.x,stages.axis.y,stages.axis.z}, etc.

%steps must be the same length as axes and corresponds to the distance in
%mm one desires to move each axis. 
% i.e. [0.4] or [1.3 -3.3] or [-2.3 4.5 -5.55]

[handles] = STAGE_checkStatus(handles);

whatstages=getParams(handles,'StageType');
[handles] = CONTROL_MoveBtns(handles, 0);



if strcmpi(whatstages,'V5')
    xInd=1;
    yInd=2;
    zInd=3;
else
    xInd = find(strcmpi(axes,handles.Stage.axis.x),1);
    yInd = find(strcmpi(axes,handles.Stage.axis.y),1);
    zInd = find(strcmpi(axes,handles.Stage.axis.z),1);
end

backlash = getParams(handles,'Backlash');

if (~strcmpi(handles.Stage.version,'V5'))&&(~strcmpi(handles.Stage.version,'V3'))&&(~strcmpi(handles.Stage.version,'V6'));
% if (handles.Stage.version ~= 'V3') && (handles.Stage.version ~= 'V5')
    [x y z] = STAGE_getPositions(handles.Stage);
    zSlow=500;
    zMed=500;
    zFast=1000;


    xyVel = getParams(handles,'XYVelocity');
    zVel = getParams(handles,'ZVelocity');


    if(~isempty(zInd))
        if(abs(z-steps) <= 1)
            if(zVel~=zSlow)
                [handles] = setParams(handles,'ZVelocity',zSlow);
            end
        elseif(abs(z-steps) < 50)
            if(zVel~=zMed)
                [handles] = setParams(handles,'ZVelocity',zMed);
            end
        else
            if(zVel~=zFast)
                [handles] = setParams(handles,'ZVelocity',zFast);
            end
        end
    end
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

end
    


% pause(.25);
[handles] = STAGE_updatePos(handles,axes,steps,handles.Stage.commands.move_absolute);
% STAGE_move(handles.Stage,axes,steps,handles.Stage.commands.move_absolute,handles.txtEncoderReadout);
[handles] = CONTROL_MoveBtns(handles, 1);
[handles] = IMAGE_Minimap_display(handles);