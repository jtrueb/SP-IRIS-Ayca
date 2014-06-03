function [handles] = FOCUS_Coarse_Automatic(handles)
%This function will tell the focusing function how to go about focusing by
%determining the offset from the hard coded focus positions. 
%
%Operation: Moves to logo. Focus the image. Determine the logo offset.

logo_pos = getParams(handles,'LogoPos');
stages = getParams(handles,'StagePointers');
axes = {stages.axis.x,stages.axis.y,stages.axis.z};
home = getParams(handles,'StageHomePos');

%% Move to logo_pos
[handles] = STAGE_MoveAbsolute(handles,axes,logo_pos);

%% Course Focus
[handles, val] = FOCUS_Image(handles,1,0,0,0);

%% Move to home
[handles] = STAGE_MoveAbsolute(handles,[axes(1) axes(2)],[home(1) home(2)]);
[handles,data] = ACQUIRE_scan(handles,'ROI');

end