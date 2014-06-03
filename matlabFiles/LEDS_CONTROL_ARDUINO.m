function [data] = LEDS_CONTROL_ARDUINO(leds,command)
%% [data] = CONTROL_LEDS(leds,command)
% leds is a struct created by LEDS_INIT
% command is a string of the action one wants to send.
%
% leds.commands should contain a list of relevant commands
% data should be a blank string

%if (~strcmpi(command,leds.commands.state_status))
%    [data] = NET_ASync_v2(leds.host,leds.host,command,'Serial');
%else
    [data] = NET_Sync_v2(leds.host,leds.portnumber,[command sprintf('\r')],'Serial');
%end