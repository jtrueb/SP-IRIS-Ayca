function [handles Q] = FOCUS_Coarse(handles,range,doCoarseFocus)
%This function coarsely focuses the z-stage. The stage must be within 300um
%1/11/13 changes: doCoarseFocus == 1 changed to 150 distance from 200
stages = getParams(handles,'StagePointers');

%This is the total distance we need to move to get above the focal plane
if(doCoarseFocus == 1)
    %Course focusing for locating the logo. 
    total_dist = 50; %Was 100
    SS = 5; %Was 10
    moveDir = 1;
elseif(doCoarseFocus == 2)
    %Course focusing once near focus
    total_dist = 30; %Was 100
    SS = 5; %Was 10
    moveDir = 1;
end

numsteps = ceil(total_dist/SS);

%The Stages are now moved
[x y curpos] = STAGE_getPositions(stages);
[handles Q] = FOCUS_Step(handles,curpos,SS,range,numsteps,1,moveDir);