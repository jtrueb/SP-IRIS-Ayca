function [stages] = STAGE_INIT_v6(prt_in_xy,prt_in_z)
%% [stages] = STAGES_INIT_v3
% stages is a struct that contains the relevant information for controlling
% the IRIS STAGES-V3 interface (MMC-100, PPS-20, x,y,z)
%
% These are the stages on SP-A1000 and communicate through USB-COM

stages = struct();
% ports = instrhwinfo('serial');
% stages.host = ports.SerialPorts{1};
stages.enabled = 0;
stages.version = 'V6';
stages.mmc_host_xy = prt_in_xy;
stages.mmc_host_z=prt_in_z;
stages.portnumber = [];
stages.mmc_portnumber = [];
stages.mmc_portnumber_z=[];
stages.communicationType = 'Serial';
stages.NL = sprintf('\n');
stages.axis = struct();
stages.axis.x = '1';
stages.axis.y = '2';
stages.axis.z = '3';
stages.axis.xy = '-3'; %Calculated by [N][M] = -2^(N-1) - 2^(M-1)
stages.axis.xz = '-5';
stages.axis.yz = '-6';
stages.axis.xyz = '-7';

stages.convert = 1/1000; %Converts Position[um] to Stage units [mm]


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

% HACK, NEED THESE
stages.commands.move_absolute = stages.commands.mmc_move_absolute;
stages.commands.move_relative = stages.commands.mmc_move_relative;

%Open connection and set communication protocol
client = serial(stages.mmc_host_xy);
set(client, 'BaudRate', 38400, 'StopBits', 1);
set(client, 'Terminator', 'CR', 'Parity', 'none');
set(client, 'FlowControl', 'none');
    
xy_enable_flag=0;

try
    fopen(client);    
    %set(client, 'ReadAsyncMode','continuous');
    stages.mmc_portnumber = client;
    xy_enable_flag=1;
catch
    disp('Could not connect to XY PPS-28 stages');
end

client_z = serial(stages.mmc_host_z);
set(client_z, 'BaudRate', 38400, 'StopBits', 1);
set(client_z, 'Terminator', 'CR', 'Parity', 'none');
set(client_z, 'FlowControl', 'none');
    
z_enable_flag=0;

try
    fopen(client_z);    
    %set(client, 'ReadAsyncMode','continuous');
    stages.mmc_portnumber_z = client_z;
    z_enable_flag=1;
catch
    disp('Could not connect to Z PPS-20 stage');
end

if (xy_enable_flag)&&(z_enable_flag)
    stages.enabled=1;
else
    stages.enabled=0;
end



   
