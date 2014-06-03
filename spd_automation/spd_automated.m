function [particle_count, ParticleData] = spd_automated(handles,im,particle_type,particle_min_width,particle_max_width,FLAG_debug,output_directory)
% IRIS Settings
color = getParams(handles,'LED');
% particle_type = getParams(handles,'ParticleType');

% SIFT Detection Parameters
[IntensityTh] = getParams(handles,'IntensityTh');
[EdgeTh] = getParams(handles,'EdgeTh');

% Gaussian Filtering Parameters
TemplateSize = getParams(handles,'TemplateSize');
SD = getParams(handles,'SD');
GaussianTh = getParams(handles,'GaussianTh');

% Histogram/Save settings
[innerRadius] = getParams(handles,'InnerRadius');
[outerRadius] = getParams(handles,'OuterRadius');

% Particle Size Parameters
% [particle_max_width] = getParams(handles,'MaxHist');
% [particle_min_width] = getParams(handles,'MinHist');
clear handles;

% Initial steps for histogram and mirror file
[CurveData Diameters]= getCurveData(color,particle_type);

% First Part: Run SIFTDetection, Anomaly Filtering and Gaussian Filtering
% step 1 - perform particle detection on the image
KPData = getParticles(im, IntensityTh, EdgeTh);
    
% step 2 - perform anomaly filtering
%%%%%%%%Commented out until memory issue is solved%%%%%%%%
% KPData = anomalyFilter(im, KPData); 

% step 3 - perform gaussian filtering
KPData = gaussianFilter(im, KPData, TemplateSize, SD,GaussianTh);
    
% step 4 - make histogram data
ParticleData = histograms(im, KPData, CurveData, Diameters, innerRadius, outerRadius);
clear im KPData;

% step 5 - perform histogram filtering based on particle sizes
% sizes = ParticleData.Size;
% sizes(sizes<particle_min_width | sizes>particle_max_width) = [];

SmallTh = particle_min_width;
LargeTh = particle_max_width;
Diameters = ParticleData.Size;
[ParticlesLargeEnough] = (Diameters >= SmallTh);
[ParticlesSmallEnough] = (Diameters <= LargeTh);
ParticlesFiltered = ParticlesLargeEnough & ParticlesSmallEnough;
Contrasts = ParticleData.Contrasts;

ParticleData.Size = ParticleData.Size(ParticlesFiltered(:)& (Contrasts>1));
particle_count = length(ParticleData.Size);
FLAG_debug =0;
if FLAG_debug
    %Circle filtered particles & save image
    KPData.VKPs = KPData.VKPs(:, ParticlesFiltered);
    circleParticles(i, im, KPData, output_directory, '');
end

ParticleData.Contrasts = ParticleData.Contrasts(ParticlesFiltered(:)& (Contrasts>1));

% ParticleData.density = ParticleData.counts/ParticleData.regionArea_pixels;