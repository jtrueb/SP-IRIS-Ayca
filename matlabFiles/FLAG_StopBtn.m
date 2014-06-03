function [status] = FLAG_StopBtn(option)
% [status] = FLAG_StopBtn(option)
%
%Used to interrupt the GUI's actions. 
%Throws, checks, and clears the flag. The flag is temp.lck

status = -1;

if strcmpi(option,'check')
    if exist('temp.lck','file') == 2
        status = 1;
    else
        status = 0;
    end
    
elseif strcmpi(option,'clear')
    if exist('temp.lck','file') == 2
        delete('temp.lck')
    end
    
elseif strcmpi(option,'throw')
    a = fopen('temp.lck','w');
    fclose(a);
end