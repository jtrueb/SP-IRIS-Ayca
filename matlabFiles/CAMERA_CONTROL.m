function [data] = CAMERA_CONTROL(camera,command)
%% [data] = CAMERA_CONTROL(camera,command)
% camera is a struct created by CAMERA_INIT
% command is a string of the action one wants to send.
%
% camera.commands should contain a list of relevant commands
% camera.parameters should contain a list of parameters
% camera.response should contain a list of response
%
% data should be a blank string

% data = 0;
[data] = NET_ASync(camera.host,camera.portnumber,command);