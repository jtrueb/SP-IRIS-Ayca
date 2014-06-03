function [ParticleData_Cell] = ZSTACK_generate_particles_SIFTonly_v2( image,defaultParams,IntTh,NA,mag,kernelSize,backradius,eff_pixel,pwindow)
%Analyzes a single image over a range of NA



%Load default analysis parameters
color=defaultParams.color;
EdgeTh=defaultParams.EdgeTh;
TemplateSize=defaultParams.TemplateSize;
% SD=defaultParams.SD;
% SD=1.5;
InnerRadius=defaultParams.InnerRadius;
OuterRadius=defaultParams.OuterRadius;
particle_type=defaultParams.particle_type;
CurveData=defaultParams.CurveData;
Diameters=defaultParams.Diameters;
clear defaultParams;

%Set Size filter values
%SmallTh = SizeLimits(1,1);
%LargeTh = SizeLimits(1,2);
if nargin<9
    SmallThan_contrast=1.2;
    LargeThan_contrast=.9;
    corr_hibound=1;
    corr_lowbound=-1;
else
    SmallThan_contrast=pwindow(2);
    LargeThan_contrast=pwindow(1);
    corr_hibound=pwindow(4);
    corr_lowbound=pwindow(3);
end



tic;
KPData=getParticles_scalefix(image,IntTh,EdgeTh); %Detect Particles based on IntensityTh




%Generate Particle Size and Contrast Arrays
ParticleData_Cell = airyHistograms(image, KPData, CurveData, Diameters, InnerRadius, OuterRadius);

% ParticleData_Cell.correlations=airyTemplate_fromSift(image,KPData.VKPs,[kernelSize kernelSize],NA,mag,backradius,eff_pixel);

   
clear KPData;


ParticleData_Raw=ParticleData_Cell;

%generate Logical arrays for curve boundaries
[Contrasts_inRange]=ParticleData_Raw.Contrasts;

        
[contrastLargeEnough] = (Contrasts_inRange>=LargeThan_contrast);
[contrastSmallEnough] = (Contrasts_inRange<=SmallThan_contrast);
 [contrast_filtered]= (contrastLargeEnough & contrastSmallEnough);

contrast_filtered=contrastSmallEnough&contrastLargeEnough;
        
% [corr_keep]=ParticleData_Raw.correlations;
% [corhi_mask]=corr_keep>corr_lowbound;
% [corlow_mask]=corr_keep<corr_hibound;
% [corr_filtered_mask]=corhi_mask&corlow_mask;


        
ParticleData_Cell.Size = ParticleData_Raw.Size(contrast_filtered(:));
ParticleData_Cell.Contrasts = ParticleData_Raw.Contrasts(contrast_filtered(:));
ParticleData_Cell.xylocs=ParticleData_Cell.xylocs(contrast_filtered(:),:);

ParticleData_Cell.Count=length(ParticleData_Cell.Contrasts(:));



end

