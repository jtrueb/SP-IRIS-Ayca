function [isRunning] = CAMERA_checkServer(exename)

[status, result] = dos(['tasklist /fi "ImageName eq ' exename '.exe"']);
if (strfind(result,exename) > 0)
    isRunning = 1;
else
    isRunning = 0;
end
