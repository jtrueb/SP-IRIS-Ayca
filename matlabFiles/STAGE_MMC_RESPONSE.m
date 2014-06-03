function [data] = STAGE_MMC_RESPONSE(stages, command,port)
% to send commands (no response) to serial port -> MMC100
%data = ' ';
%fprintf(['RECEIVE: ' command stages.NL]);

if nargin<3
    port=stages.mmc_portnumber;
end
fprintf(port, [command]); % stages.NL]);
%flushinput(stages.mmc_portnumber);
data = fscanf(port,'%s\n');
if (length(data) > 0)
    if (data(1) == '#')
        data = data;
    else
        data = ' ';
    end
else
    data = ' ';
end
