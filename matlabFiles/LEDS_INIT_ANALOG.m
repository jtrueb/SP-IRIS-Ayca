function [leds] = LEDS_INIT_ANALOG(port_cfg)
%% [leds] = LEDS_INIT_ARDUINO
% leds is a struct that contains the relevant information for controlling
% the NGA-ARDUINO IRIS-SHIELD interface

%Analog version is just a place holder, no actulal LED communication
%required

leds = struct();
leds.enabled = 0;

try
    leds.enabled = 1;
catch
    leds.enabled = 0;
end

leds.commands = struct();
if nargin < 1
    leds.host = 'COM11';
else
    leds.host = port_cfg;
end

leds.commands.led1 = 'L1';
leds.commands.led2 = 'L2';
leds.commands.led3 = 'L3';
leds.commands.led4 = 'L4';
leds.commands.leds_off = 'O';
leds.commands.leds_on = 'A';
leds.commands.state_status = 'S';
leds.commands.vacuum_on = 'VAC1';
leds.commands.vacuum_off = 'VAC0';
leds.commands.valve_on = 'VAL1';
leds.commands.valve_off = 'VAL0';
leds.commands.pressure = 'P';
leds.commands.front_button0 = 'FB0';
leds.commands.front_button1 = 'FB1';
leds.commands.front_button2 = 'FB2';

leds.pneumatics = struct();
leds.pneumatics.valve = 0;
leds.pneumatics.vac = 0;
leds.pneumatics.pressure = 0;

%Open connection and set communication protocol
% client = serial(leds.host);
% set(client, 'BaudRate', 9600, 'StopBits', 1);
% set(client, 'Terminator', 'LF', 'Parity', 'none');
% set(client, 'FlowControl', 'none');
   

leds.enabled=1;
leds.portnumber=[];
% try
%     fopen(client);    
%     set(client, 'ReadAsyncMode','continuous');
%     leds.portnumber = client;
%     leds.enabled = 1;
%     
%     %% CLEAR OUT FIRST ENTRY, BUG WITH ARDUINO
%     fprintf(client, sprintf('O\r'));
%     data = fscanf(client);
%     flushinput(client);
% catch
%     leds.enabled = 0;
% end

