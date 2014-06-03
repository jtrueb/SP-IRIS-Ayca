function [handles] = FOCUS_ThreeCorners_morph(handles)
%This function will tell the focusing function how to go about focusing by
%determining exactly where the focus is for four far apart corners of the
%chip. 

[offset] = getParams(handles,'ChipOffset');
[FC_pos] = getParams(handles,'FocusPos');
[stages] = getParams(handles,'StagePointers');
[axes] = {stages.axis.x,stages.axis.y,stages.axis.z};

[arrayTotal] = getParams(handles,'ArrayTotal'); %
[arraySize] = getParams(handles,'ArraySize'); %[X Y]
[pos_init] = getParams(handles,'Stage_XYPos'); %[X Y]
[z_init]=getParams(handles,'ZPos'); %[Z]
[array_pitch] = getParams(handles,'Stage_XYIndex'); %[X Y]


[rowOffset] = getParams(handles,'RowOffset');

array_end_x=(arraySize(1)-1)*array_pitch(1);
array_end_y=(arraySize(2)-1)*array_pitch(2);



flag = 0;

for i=1:2 %columns
    for j=1:2 %rows
        if FLAG_StopBtn('check')
            return
        end
        
        if (i==2)&&(j==2)
            continue
        end
        
        tic;
        pos=pos_init+[(j-1)*array_end_x,(-1)*(i-1)*array_end_y];
        corner_num=(i-1)*2+j;
        [handles] = STAGE_MoveAbsolute(handles,[axes(1), axes(2)],pos);
        
        FC_pos{corner_num}=pos;
        
        
        
        
        if flag == 0
            flag = 1;
            [handles,val] = ACQUIRE_DefocusScan_RP_planecalc(handles,1,1,0,0);
        else
            [handles,val] = ACQUIRE_DefocusScan_RP_planecalc(handles,1,1,0,0);
        end
        FC_pos{corner_num}(3) = val;
        
        disp(['Corner ' num2str(corner_num) ': Position = [' num2str(FC_pos{corner_num}) 'Time Elapsed: ' num2str(toc)]);
    end
    [handles] = STAGE_MoveAbsolute(handles,axes,FC_pos{1});
end

    [handles] = STAGE_MoveAbsolute(handles,axes,FC_pos{1});

%Determine plane coefficients
x = [FC_pos{1}(1)+offset(1) FC_pos{2}(1)+offset(1) FC_pos{3}(1)+offset(1)];
y = [FC_pos{1}(2)+offset(2) FC_pos{2}(2)+offset(2) FC_pos{3}(2)+offset(2)];
z = [FC_pos{1}(3) FC_pos{2}(3) FC_pos{3}(3)];

Xcolv = x(:); % Make X a column vector
Ycolv = y(:); % Make Y a column vector
Zcolv = z(:); % Make Z a column vector
Const = ones(size(Xcolv)); % Vector of ones for constant term

Coefficients = [Xcolv Ycolv Const]\Zcolv; % Find the coefficients
XCoeff = Coefficients(1); % X coefficient
YCoeff = Coefficients(2); % X coefficient
CCoeff = Coefficients(3); % constant term

[handles] = setParams(handles,'FocusPos',FC_pos);
[handles] = setParams(handles,'PlaneCoeff',Coefficients);
[handles] = setParams(handles,'SmartMove',1);