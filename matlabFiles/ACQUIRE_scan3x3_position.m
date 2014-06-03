function [handles,data_out] = ACQUIRE_scan3x3_position(handles, starting_position)

stages = getParams(handles,'StagePointers');
axes = {stages.axis.x,stages.axis.y,stages.axis.z};
xoffset = handles.const.Camera.FOV(1);
yoffset = handles.const.Camera.FOV(2);


for j = 1:3
    for i = 1:3
        posx = starting_position(1)-(i-2)*yoffset;
        posy = starting_position(2)-(j-2)*xoffset;
        pos = [posx posy];
        [handles] = setParams(handles,'Stage_XYPos',pos);
        [handles] = STAGE_MoveAbsolute(handles,[axes(1), axes(2)],pos);
        [handles,data{i,j}] = ACQUIRE_scan(handles,'ROI');
    end
end

%figure; 
vec = [7 8 9 4 5 6 1 2 3];
k = 0;
for j = 1:3
    for i = 1:3
        k = k +1;
         posx = starting_position(1)-(i-2)*yoffset;
        posy = starting_position(2)-(j-2)*xoffset;
       % subplot(3,3,k); imshow(data{i,j},[0 2^16]); title(sprintf('Position X:%d Position Y: %d , i= %d, j = %d',posx,posy,i,j));

    end 
end


data_out = [data{1,1} data{2,1} data{3,1};
            data{1,2} data{2,2} data{3,2};
            data{1,3} data{2,3} data{3,3}];
        
%        figure;
%imshow(data_out,[0 2^16]);

%disp('Happy Face');