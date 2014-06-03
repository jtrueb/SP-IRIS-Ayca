function [stages] = STAGE_INIT_v4()
%% [stages] = STAGES_INIT_v4
% stages is a struct that contains the relevant information for controlling
% the IRIS STAGES-V4 interface (hybrid)
%
% These are the stages on SP-A1000 and communicate through USB-COM

stages = struct();
ports = instrhwinfo('serial');
% stages.host = ports.SerialPorts{1};
stages.enabled = 0;
stages.version = 'V4';
stages.host = 'COM10';
stages.mmc_host = 'COM12';
stages.portnumber = [];
stages.mmc_portnumber = [];
stages.communicationType = 'Serial';
stages.axis = struct();
stages.axis.x = '1';
stages.axis.y = '2';
stages.axis.z = '3';
stages.axis.xy = '-3'; %Calculated by [N][M] = -2^(N-1) - 2^(M-1)
stages.axis.xz = '-5';
stages.axis.yz = '-6';
stages.axis.xyz = '-7';
stages.axis.Vx = 0;
stages.axis.Vy = 0;
stages.axis.Vz = 0;
stages.powerOff = 0;

stages.commands = struct();
%% PPS-20 commands (MMC100)
stages.commands.mmc_move_relative = 'MVR';
stages.commands.mmc_move_absolute = 'MVA';
stages.commands.mmc_current_position = 'POS?';
stages.commands.mmc_home = 'HOM';
stages.commands.mmc_zero = 'ZRO';
stages.commands.mmc_limit_positive = 'TLP';
stages.commands.mmc_limit_negative = 'TLN';
stages.commands.mmc_abort = 'EST';
stages.commands.mmc_status = 'STA?';
stages.commands.mmc_closed_loop_enable = 'FBK 3';
stages.commands.mmc_closed_loop_disable = 'FBK 0';

%Open connection and set communication protocol
client = serial(stages.host);
set(client, 'BaudRate', 38400, 'StopBits', 1);
set(client, 'Terminator', 'LF', 'Parity', 'none');
set(client, 'FlowControl', 'none');
    
try
    fopen(client);    
    set(client, 'ReadAsyncMode','continuous');
    stages.mmc_portnumber = client;
    stages.enabled = 1;
catch
    stages.enabled = 0;
end

%% VT-21 & VT-50 commands (SMC-Pollux)
stages.commands.current_position = 'npos'; % The command npos returns the current axis coordinate. (mm)
stages.commands.calibrate_limit = 'ncal';  %The command ncal  executes a limit-switch move to the cal limit-switch. This procedure determines the origin and lower limit of the selected axis. 
%stages.commands.range_measurement = 'nrm'; %The command nrm executes a limit-switch movement to the rm limit-switch. This procedure determines the upper limit of the selected axis.
stages.commands.closed_loop = 'setcloop'; 
stages.commands.set_axis_enabled = 'setaxis'; %The command  setaxis  enables or disables the specified axis for positioning tasks.
stages.commands.move_absolute = 'nm'; %The command nmove  executes  point to point positioning tasks to absolute coordinates based on the point of origin
stages.commands.move_relative = 'nr'; %The command nrmove  executes point to point  positioning tasks relative to the current position.
stages.commands.status = 'nst'; %TThe command nstatus returns the current state of the axis.
stages.commands.getVoltage = 'getumotmin';
stages.commands.setVoltage = 'setumotmin';
stages.commands.getClosedLoop = 'getcloop';
stages.commands.setClosedLoop = 'setcloop';
stages.commands.getSelPos = 'getselpos';
stages.commands.setSelPos = 'setselpos';
stages.commands.getClWindow = 'getclwindow';
stages.commands.setClWindow = 'setclwindow';

stages.commands.setVelocity = 'snv';%[vel] [axisID] snv
stages.commands.getVelocity = 'gnv';%[axisID] gnv
stages.commands.setCalVelocity = 'setncalvel';%[vel] [axisID] setncalvel
stages.commands.getCalVelocity = 'getncalvel';%[axisID] getncalvel
stages.commands.setNRMVelocity = 'setnrmvel';%[vel] [axisID] setnrmvel
stages.commands.getNRMVelocity = 'getnrmvel';%[axisID] getnrmvel

stages.commands.setAcceleration = 'sna';%[accel] [axisID] sna
stages.commands.getAcceleration = 'gna';%[axisID] gna
stages.commands.setAcceleration = 'sna';%[accel] [axisID] sna
stages.commands.getAcceleration = 'gna';%[axisID] gna

stages.commands.loadToStack = 'npush'; % [position] [axisID] npush 
%npush example: 2.0 1 snv, 4.0 2 snv, 10. 1 npush, 20. 2 npush, -3 nr
stages.commands.removeFromStack = 'npop'; %[axisID] npop
stages.commands.startConstantMove = 'speed'; %[speed] [axisID] speed
stages.commands.stopConstantMove = 'stopspeed';%[axisID] stopspeed


stages.commands.enable_char = '1';
stages.commands.disable_char = '0';

stages.status = [0 0 32];

stages.convert = 1/1000; %Converts Position[um] to Stage units [mm]

%Open connection and set communication protocol
client = serial(stages.host);
set(client, 'BaudRate', 19200, 'StopBits', 1);
set(client, 'Terminator', 'LF', 'Parity', 'none');
set(client, 'FlowControl', 'none');
    
try
    fopen(client);    
    set(client, 'ReadAsyncMode','continuous');
    stages.portnumber = client;
    if (stages.enabled == 1)
        stages.enabled = 1;
    else
        stages.enabled = 0; %somehow we ended up down here even though the MMC failed above. dsf 2013-03-11
    end
catch
    stages.enabled = 0;
end

   
