function [handles Q] = FOCUS_Fine(handles,range)
%This function takes the serial port object as an input and autofocuses the
%z-stage (the 2nd axis). The serial port communication must already be setup
%for this to work. Also, the stage must be initialized. 

%The stages are moved to below the focus value determined by the coarse
%alignment.
stages = getParams(handles,'StagePointers');

ZPos = getParams(handles,'ZPos');
% [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},ZPos-0.5);
[handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},ZPos-1);
moveDir = 1;

%This is the total distance we need to move to get above the focal plane
% total_dist = 5; %5 microns
total_dist = 2; %2 microns

SS = .1; %100 nanometers
numsteps = ceil(total_dist/SS);

%The Stages are now moved
% curpos = getParams(handles,'ZPos');
[x y curpos] = STAGE_getPositions(stages);
[handles Q] = FOCUS_Step(handles,curpos,SS,range,numsteps,0,moveDir);