
function [handles, particles_found] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,zLoc,pInfo)
% [handles, particles_found] = ACQUIRE_DefocusMoveAndScan(handles,zAxes,zLoc,pInfo)
% handles is the GUI handles struct
% zAxes is the zaxis string identirfier
% zLoc is the z height in (microns?)
% pInfo is a struct with particle info parameters.

a1 = tic();
[handles] = STAGE_MoveAbsolute(handles,zAxes,zLoc);
a2 = toc(a1);
a3 = tic();
[handles,data] = ACQUIRE_scan(handles,'take'); %Acquire a scan
a4 = toc(a3);
%img_time(end+1) = a2;
a5 = tic();
[particles_found,ParticleData] = spd_automated(handles,data,pInfo.p_type,...
  pInfo.p_min,pInfo.p_max); %Detect particles
a6 = toc(a5);
disp(['ROI - Particles found: ' num2str(particles_found) ' - ZPos: ' num2str(zLoc)]);

%disp([a2 a4 a6]);
