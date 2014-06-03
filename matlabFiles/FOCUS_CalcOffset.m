function [handles] = FOCUS_CalcOffset(handles)
%This function will tell the focusing function how to go about focusing by
%determining the offset from the hard coded focus positions. 
%
%Operation: Moves to the 1st point. Prompts the user to move XY until
%the corner is found. After prompt is closed, the code determines offset and continues.

offset = getParams(handles,'ChipOffset');
FC_pos = getParams(handles,'FocusPos');
stages = getParams(handles,'StagePointers');
axes = {stages.axis.x,stages.axis.y,stages.axis.z};

pos = [FC_pos{1}(1) FC_pos{1}(2)] + offset;
[handles] = setParams(handles,'Stage_Pos',[pos FC_pos{1}(3)]);
[handles] = STAGE_MoveAbsolute(handles,axes,[pos FC_pos{1}(3)]);
[handles,data] = ACQUIRE_scan(handles,'preview');

[handles] = GUI_makePopup_FocusOffset(handles);