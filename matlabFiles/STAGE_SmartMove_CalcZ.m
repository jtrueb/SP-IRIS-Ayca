function [z] = STAGE_SmartMove_CalcZ(handles,steps)
%This function will interpolate the z-plane for a given x/y coordinate. The
%FC. 
%should move in the Z due to the lay of the chip. 

if(~isfield(handles.Stage,'PlaneCoefficients'))
    %If the calibration has not been done, there is no plane to fit and
    %this function is useless. 
    return;    
end

z = handles.Stage.PlaneCoefficients(1)*steps(1) + handles.Stage.PlaneCoefficients(2)*steps(2) + handles.Stage.PlaneCoefficients(3);
end