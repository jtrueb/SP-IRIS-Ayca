function [ParticleData] = ZSTACK_generate_particles_PSF( image,handles)
%Analyzes a single image with a signle template

contrastcurve_filename='Poly100ContrastCurves.mat';


%Load default analysis parameters

EdgeTh=handles.EdgeTh;

% SD=defaultParams.SD;
% SD=1.5;
InnerRadius=handles.InnerRad;
OuterRadius=handles.OuterRad;
backradius=handles.backradius;
pixelsize=handles.pixelsize;
IntTh=handles.IntTh;
NA=handles.NA;
kernelSize=2*(ceil(backradius)+1)+1;

Contrast_ceil=handles.limits_display(4);
Contrast_floor=handles.limits_display(3);


% CurveData=parameters.CurveData;
% Diameters=parameters.Diameters;
load(contrastcurve_filename);
CurveData=data(:,3);
Diameters=data(:,1)*2;
clear data;




clear defaultParams;

%Set Size filter values
%SmallTh = SizeLimits(1,1);
%LargeTh = SizeLimits(1,2);
% SmallTh=190;
% LargeTh=40;





KPData=getParticles_scalefix(image,IntTh,EdgeTh); %Detect Particles based on IntensityTh

%Generate Particle Size and Contrast Arrays

temp_pdata = airyHistograms(image, KPData, CurveData, Diameters, InnerRadius, OuterRadius);

Contrasts_inrange_mask=(temp_pdata.Contrasts(:)>Contrast_floor) & (temp_pdata.Contrasts(:)<Contrast_ceil);

ParticleData.Contrasts=temp_pdata.Contrasts(Contrasts_inrange_mask(:));
ParticleData.Size=temp_pdata.Size(Contrasts_inrange_mask(:));
ParticleData.xylocs=temp_pdata.xylocs(Contrasts_inrange_mask(:),:);


temp_VKPs=KPData.VKPs(:,Contrasts_inrange_mask(:));





% ParticleData_Cell.correlations=airyTemplate_fromSift(image,KPData.VKPs,[kernelSize kernelSize],NA,mag,backradius,pixel_image,ParticleData_Cell.Contrasts,showfigure_flag);
ParticleData.correlations=airyTemplate_preAllocate(image,temp_VKPs,[kernelSize kernelSize],NA,backradius,pixelsize,ParticleData.Contrasts,0);

clear KPData;

    
ParticleData.Count=length(ParticleData.Contrasts(:));
ParticleData.contrast_window=[Contrast_floor,Contrast_ceil];



end

