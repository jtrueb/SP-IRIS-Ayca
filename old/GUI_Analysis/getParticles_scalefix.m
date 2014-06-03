function KPData = getParticles_scalefix(I, IntensityTh, EdgeTh)

ImScale = 2; % this is fixed in Ahmet's version
MatchFlag = 0;

KPData.Feats=[];
KPData = SIFTDetection_scalefix(I, IntensityTh, EdgeTh, MatchFlag, ImScale);
KPData.Peaks=I(sub2ind(size(I), round(KPData.VKPs(2,:).'), round(KPData.VKPs(1,:).')));
end