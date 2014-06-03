function [handles,data_out] = ACQUIRE_scan3x3(handles)
%ACQUIRE_scan3x3 acquires a 3x3 grid of images with the current FOV being
%the center image
%   Images are acquired in a 3x3 grid around the assumed corner location.
%   Stepping occurs according to the FOV variable. Data is stored in data
%   then merged for data_out

stages = getParams(handles,'StagePointers');
axes = {stages.axis.x,stages.axis.y};
FOV = fix(getParams(handles,'FOV')); % [Y X]
initial_pos = getParams(handles,'Stage_XYPos');% [X Y]

%Acquire images Right->Left Top->Bottom
for j = 1:3
    for i = 1:3
        posx = initial_pos(1)-(2-i)*FOV(2);
        posy = initial_pos(2)-(j-2)*FOV(1);
        pos = [posx posy];
        [handles] = setParams(handles,'Stage_XYPos',pos);
        [handles] = STAGE_MoveAbsolute(handles,axes,pos);
        [handles,data{i,j}] = ACQUIRE_scan(handles,'ROI');
        if FLAG_StopBtn('check')
            [smart_flag] = getParams(handles,'SmartMove');
            if smart_flag
                [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,initial_pos);
            else
                [handles] = STAGE_MoveAbsolute(handles,axes,initial_pos);
            end
            data_out = [];
            return;
        end
    end
end

data_out = [data{3,1} data{2,1} data{1,1};
            data{3,2} data{2,2} data{1,2};
            data{3,3} data{2,3} data{1,3}];
        
%Troubleshoot
%figure; imshow(data_out./max(max(data_out)));