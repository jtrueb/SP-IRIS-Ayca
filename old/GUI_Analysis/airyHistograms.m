function [ParticleData] = airyHistograms(im, KPData, CurveData, Diameters, innerRadius, outerRadius)
% Saves the contrasts, sizes and area size

ParticleData.Contrasts = ComputeContrast(im, KPData.Peaks, KPData.VKPs(1:2,:), innerRadius, outerRadius);

[unused,DiameterIndices]=min(abs(repmat(CurveData(:),1,length(ParticleData.Contrasts))-repmat(ParticleData.Contrasts(:)',length(CurveData),1)));

%insert a logical array mask for particle contrasts that fall outside of
%the CurveData bounds.
%[unused,DiameterIndices]=


ParticleData.Size = Diameters(DiameterIndices).';

ParticleData.regionArea_pixels = size(im,1)*size(im,2);
ParticleData.xylocs=KPData.VKPs(1:2,:).';

end

% helper function  CHANGE THIS to account for peak offsets by normalizing
% to the filter peak?
function ParticleContrasts= ComputeContrast(InputIm, PeakValues, PeakLocations, innerRadius, outerRadius)

MedianValues=zeros(size(PeakValues));
for peakindex=1:length(PeakValues)
    LocationVec=PeakLocations(:,peakindex);
    MedianValues(peakindex)=MedianOuterAnnuli(InputIm, LocationVec, innerRadius, outerRadius);
end

ParticleContrasts = PeakValues./MedianValues;
end

% helper helper function function :)
function OuterMedian=MedianOuterAnnuli(InputIm, LocationVec, innerRadius, outerRadius)
%function find_imedian find the median of background the bead in the
%intensity image

xi=round(LocationVec(1));
yi=round(LocationVec(2));

radius1 = innerRadius;
radius2 =outerRadius;

median_array=[];
i_=0;
for i1=-radius2:radius2;
    if yi+i1<1
        continue
    elseif yi+i1> size(InputIm,1)
        continue
    else
        for i2=-radius2:radius2
            if xi+i2<1
                continue
            elseif xi+i2>size(InputIm,2)
                continue
            else
                r_temp=i1^2+i2^2;
                if r_temp<radius2^2 && r_temp>radius1^2
                    i_=i_+1;
                    median_array(i_)=InputIm(yi+i1,xi+i2);
                end
            end
        end
    end
end
OuterMedian = median(median_array);

end