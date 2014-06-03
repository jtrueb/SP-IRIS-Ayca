function [cfg] = HARDWARE_Scan()

instrreset();
[a,b] = system('C:\Python27\python.exe ../python/Serial_Scan.pyc');
[cfg] = loadConfig('..\config\config.com.ports.txt');


%[cfg] = getDefaultConfig();
%% THIS DOESN't WORK !
%[cfg] = scan_ports(cfg);


function [cfg] = loadConfig(fn)
cfg = getDefaultConfig();
if exist(fn,'file') == 2
    fid = fopen(fn, 'r');
    tline = fgetl(fid);
    while ischar(tline)
        numberOfColons = length(find(tline==':'));
        if (numberOfColons > 0)
            C = textscan(tline, '%s', 'delimiter', ':');    
            D = C{1};
            str = deblank(D{1});
            str2 = deblank(D{2});
            if (isfield(cfg,str))
                cfg.(str) = str2;
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end


function [cfg] = scan_ports(cfg)
prts = getAvailableComPort();
for i = 1:size(prts,1)
    fprintf('%s\n',prts{i});
    %[cfg] = identify_port(cfg,prts{i});
end
    


function write_config(in)
fn = '..\config\config.ports.txt';
if (isstruct(in))
    flds = fields(in);
    fid = fopen(fn,'w');

    for i = 1:size(flds,1)
        fprintf(fid,'%s:%s\r\n',flds{i},in.(flds{i}));
    end  
    fclose(fid);
else
    fprintf('Incorrect function input, not a struct!\n');
end

function [out] = getDefaultConfig()

out = struct();
out.mmc100 = 'COM0';
out.mmc100Z = 'COM0';
out.pollux = 'COM0';
out.arduino = 'COM0';
out.mfc2000 = 'COM0';

function lCOM_Port = getAvailableComPort()
% function lCOM_Port = getAvailableComPort()
% Return a Cell Array of COM port names available on your computer

try
    s=serial('IMPOSSIBLE_NAME_ON_PORT');fopen(s); 
catch
    lErrMsg = lasterr;
end

%Start of the COM available port
lIndex1 = findstr(lErrMsg,'COM');
%End of COM available port
lIndex2 = findstr(lErrMsg,'Use')-3;

lComStr = lErrMsg(lIndex1:lIndex2);

%Parse the resulting string
lIndexDot = findstr(lComStr,',');

% If no Port are available
if isempty(lIndex1)
    lCOM_Port{1}='';
    return;
end

% If only one Port is available
if isempty(lIndexDot)
    lCOM_Port{1}=lComStr;
    return;
end

lCOM_Port{1} = lComStr(1:lIndexDot(1)-1);

for i=1:numel(lIndexDot)+1
    % First One
    if (i==1)
        lCOM_Port{1,1} = lComStr(1:lIndexDot(i)-1);
    % Last One
    elseif (i==numel(lIndexDot)+1)
        lCOM_Port{i,1} = lComStr(lIndexDot(i-1)+2:end);       
    % Others
    else
        lCOM_Port{i,1} = lComStr(lIndexDot(i-1)+2:lIndexDot(i)-1);
    end
end    