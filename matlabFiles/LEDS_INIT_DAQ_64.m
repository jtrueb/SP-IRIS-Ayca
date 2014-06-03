function [leds] = LEDS_INIT_DAQ_64()
%% [leds] = LEDS_INIT_DAQ
% leds is a struct that contains the relevant information for controlling
% the IRIS-DAQ interface

leds.enabled = 0;

try

    leds.session = daq.createSession('ni');
    info = daq.getDevices();
    for i = size(info,2)
        if strcmpi(info(i).Model,'USB-6009')
            ind = i;
            break;
        end
    end
    %leds.daq = digitalio('nidaq',info.InstalledBoardIds{ind});

    leds.daq = leds.session.addDigitalChannel(info(i).ID,'Port0/Line0:7','OutputOnly');

    names={'L0','L1','L2','L3','L4','L5','L6','L7'};
    for j=1:size(names,2)
        leds.session.Channels(j).Name=names{j};
    end
    leds.enabled = 1;
catch
    leds.enabled = 0;
end

%s.Channels}.Name = {'L0','L1','L2','L3','L4','L5','L6','L7'};

%addline(leds.daq,0:7,'out',{'L0','L1','L2','L3','L4','L5','L6','L7'});
%%Legacy session dio construction


leds.commands = struct();
leds.commands.led1 = 'L1';
leds.commands.led2 = 'L2';
leds.commands.led3 = 'L3';
leds.commands.led4 = 'L4';
leds.commands.leds_off = 'O';
leds.commands.leds_on = 'A';
end


% leds.commands.led1 = [1 0 0 0 0 0 0 0];
% leds.commands.led2 = [0 1 0 0 0 0 0 0];
% leds.commands.led3 = [0 0 1 0 0 0 0 0];
% leds.commands.led4 = [0 0 0 1 0 0 0 0];
% leds.commands.leds_off = [0 0 0 0 0 0 0 0];
% leds.commands.leds_on = [1 1 1 1 0 0 0 0];