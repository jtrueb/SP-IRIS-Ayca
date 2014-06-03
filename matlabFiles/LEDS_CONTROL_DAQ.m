function [data] = LEDS_CONTROL_DAQ(leds,command,type)
%% [data] = CONTROL_LEDS(leds,command)
% leds is a struct created by LEDS_INIT
% command is a string of the action one wants to send.
%
% leds.commands should contain a list of relevant commands
% data should be a blank string
% type [UNUSED] is the communication protocol (Serial, Ethernet, etc)

data = [];

if strcmpi(command,'L1')
    led = [1 0 0 0 0 0 0 0];
elseif strcmpi(command,'L2')
    led = [0 1 0 0 0 0 0 0];
elseif strcmpi(command,'L3')
    led = [0 0 1 0 0 0 0 0];
elseif strcmpi(command,'L4')
    led = [0 0 0 1 0 0 0 0];
elseif strcmpi(command,'O')
    led = [0 0 0 0 0 0 0 0];
elseif strcmpi(command,'A')
    led = [1 1 1 1 0 0 0 0];
end
leds.session.outputSingleScan(led);
%putvalue(leds.daq.Line,led);
