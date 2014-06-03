function [leds] = LEDS_INIT_DAQ()
%% [leds] = LEDS_INIT_DAQ
% leds is a struct that contains the relevant information for controlling
% the IRIS-DAQ interface

leds.enabled = 0;

try
    info = daqhwinfo('nidaq');
    for i = size(info.BoardNames,2)
        if strcmpi(info.BoardNames{i},'USB-6009')
            ind = i;
            break;
        end
    end
    leds.daq = digitalio('nidaq',info.InstalledBoardIds{ind});
    addline(leds.daq,0:7,'out',{'L0','L1','L2','L3','L4','L5','L6','L7'});
    leds.enabled = 1;
catch
    leds.enabled = 0;
end

leds.commands = struct();
leds.commands.led1 = 'L1';
leds.commands.led2 = 'L2';
leds.commands.led3 = 'L3';
leds.commands.led4 = 'L4';
leds.commands.leds_off = 'O';
leds.commands.leds_on = 'A';

% leds.commands.led1 = [1 0 0 0 0 0 0 0];
% leds.commands.led2 = [0 1 0 0 0 0 0 0];
% leds.commands.led3 = [0 0 1 0 0 0 0 0];
% leds.commands.led4 = [0 0 0 1 0 0 0 0];
% leds.commands.leds_off = [0 0 0 0 0 0 0 0];
% leds.commands.leds_on = [1 1 1 1 0 0 0 0];