function [ delta_rev ] = align_calc(dZ,im_span,screw_span,tpi)
% ouputs the necessary angle change for the chip alignment screws
%   Detailed explanation goes here

delta_rev=dZ*screw_span*tpi/im_span; %delta_angle in radians
delta_rev=360*delta_rev; %delta_angle in degrees

end

