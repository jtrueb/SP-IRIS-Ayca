function [handles] = FOCUS_FourCorners(handles)
%This function will tell the focusing function how to go about focusing by
%determining exactly where the focus is for four far apart corners of the
%chip. 

[offset] = getParams(handles,'ChipOffset');
[FC_pos] = getParams(handles,'FocusPos');
[stages] = getParams(handles,'StagePointers');
[axes] = {stages.axis.x,stages.axis.y,stages.axis.z};
flag = 0;

for i=1:4
    if FLAG_StopBtn('check')
        return
    end
    
    pos = [FC_pos{i}(1) FC_pos{i}(2)] + offset;
    [handles] = STAGE_MoveAbsolute(handles,[axes(1), axes(2)],pos);

    if flag == 0
        flag = 1;
        [handles, val] = FOCUS_Image(handles,2,1,1,0);
    else
        [handles, val] = FOCUS_Image(handles,2,1,1,0);
    end
    FC_pos{i}(3) = val;
end

%Determine plane coefficients
x = [FC_pos{1}(1)+offset(1) FC_pos{2}(1)+offset(1) FC_pos{3}(1)+offset(1) FC_pos{4}(1)+offset(1)];
y = [FC_pos{1}(2)+offset(2) FC_pos{2}(2)+offset(2) FC_pos{3}(2)+offset(2) FC_pos{4}(2)+offset(2)];
z = [FC_pos{1}(3) FC_pos{2}(3) FC_pos{3}(3) FC_pos{4}(3)];

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