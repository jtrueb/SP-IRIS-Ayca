function [CAMERA] = CAMERA_acquire(CAMERA)
%directory is where you want to save the file

Cmd = ['acquire; ' CAMERA.dir '\' CAMERA.file];
CAMERA.sw.WriteLine(Cmd);
str = CAMERA.sr.ReadLine();
if (isequal(char(str),'wait'))
   CAMERA.sr.ReadLine();
end
