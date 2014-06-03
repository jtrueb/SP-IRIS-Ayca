function [step] = STAGE_getStep(handles)
% [step] = STAGE_getStep(handles)
% step is X Y

MoveType = getParams(handles,'MoveType');

if strcmpi(MoveType,'User')
    step = [getParams(handles,'XStep') getParams(handles,'YStep')];
elseif strcmpi(MoveType,'FOV')
    FOV = getParams(handles,'FOV');
    step = [FOV(2) FOV(1)];
elseif strcmpi(MoveType,'Pitch')
    step =[getParams(handles,'PitchX')  getParams(handles,'PitchY')];
end