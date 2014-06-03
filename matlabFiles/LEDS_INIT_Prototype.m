function [leds] = LEDS_INIT_Prototype()
%% [leds] = LEDS_INIT
% leds is a struct that contains the relevant information for controlling
% the IRIS-ETHERNET interface

leds = struct();
leds.host = '192.168.111.20';
leds.portnumber = 10001;
leds.commands = struct();
leds.commands.led1 = 'L1';
leds.commands.led2 = 'L2';
leds.commands.led3 = 'L3';
leds.commands.led4 = 'L4';
leds.commands.leds_off = 'O';
leds.commands.fans_on = 'F';
leds.commands.fans_off = 'G';
leds.commands.leds_on = 'A';
leds.commands.state_status = 'S';