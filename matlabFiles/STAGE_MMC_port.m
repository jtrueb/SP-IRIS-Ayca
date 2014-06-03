function [data] = STAGE_MMC_port(stages, command,port)
% to send commands (no response) to serial port -> MMC100
if nargin<3
    port=stages.mmc_portnumber;
end

data = ' ';
%NL = sprintf('\n');
fprintf(['SEND: ' command stages.NL]);
fprintf(port, [command]); % stages.NL]);
%flushinput(stages.mmc_portnumber);