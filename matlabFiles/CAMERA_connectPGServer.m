function [CAMERA, isConnected] = CAMERA_connectPGServer(handles,exename)
%Connects to the point grey camera. isConnected is 'done' if successful or
%'error' if not
system (['start "PGServer" "' handles.const.directories.library '\' exename '"']);

pause(1);

import System.*
import System.Net.Sockets.*
import System.IO.*

PORT = 2055;
ADDRESS = String('localhost');

client = TcpClient(ADDRESS,PORT);

s = client.GetStream();
sr = StreamReader(s);
sw = StreamWriter(s);
sw.AutoFlush = true;
welcomeMsg = char(sr.ReadLine());
[handles] = GUI_logMsg(handles,welcomeMsg,handles.const.log.instrument,handles.txtLog,1);
sw.WriteLine('camconnect;gige');
holdMsg = ['Connecting - ' char(sr.ReadLine())];
[handles] = GUI_logMsg(handles,holdMsg,handles.const.log.camera,handles.txtLog,1);
isConnected = char(sr.ReadLine());
[handles] = GUI_logMsg(handles,isConnected,handles.const.log.camera,handles.txtLog,1);
sw.WriteLine('camparam;shutter;20;framecount;5;bin;binh;2;binv;2');
sr.ReadLine();
sw.WriteLine('camparam;roi;left;0;top;0;width;1224;height;1024');
sr.ReadLine();

CAMERA.sw = sw;
CAMERA.sr = sr;
CAMERA.client = client;
CAMERA.s = s;
CAMERA.dir = handles.const.directories.CameraTemp; %This is where the acquired file will be stored
% CAMERA.dir = pwd; %This is where the acquired file will be stored
CAMERA.file = 'Example';