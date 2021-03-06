
function [handles, output] = ACQUIRE_DefocusMoveAndScan_diffG(handles,zAxes,zLoc)
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


I=data;

s1=1.5;
s2=3;

G1 = fspecial('gaussian',[11,11],s1);
G2= fspecial('gaussian',[11,11],s2);
%# Filter it
Ig = imfilter(I,G1,'same');
Ig2=imfilter(I,G2,'same');
IgDiff=Ig-Ig2;
% IgDiffPos=IgDiff;
% IgDiffPos(IgDiffPos(:)<0)=0;

% IgDiffNeg=IgDiff;
% IgDiffNeg(IgDiffNeg(:)>0)=0;
IgDiffAbs=abs(IgDiff);
output=sum(IgDiffAbs(:));




% [particles_found,ParticleData] = spd_automated(handles,data,pInfo.p_type,...
%   pInfo.p_min,pInfo.p_max); %Detect particles



a6 = toc(a5);
disp(['DiffG - Signal Sum: ' num2str(output) ' - ZPos: ' num2str(zLoc)]);

%disp([a2 a4 a6]);
