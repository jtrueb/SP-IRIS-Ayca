function KPData = anomalyFilter(im,KPData)

Th = 100;
BWAnomalyMap= GetAnomalyMap(im,Th);
[AnY, AnX] =find(BWAnomalyMap==1);
size_im = size(im);
clear BWAnomalyMap im;
LinearAnIndices= sub2ind(size_im,AnY, AnX);
clear AnY AnX;
LinearKeyLocs= sub2ind(size_im, round(KPData.VKPs(2,:)'),round(KPData.VKPs(1,:)'));
InAnomaly=repmat(LinearAnIndices(:)',length(LinearKeyLocs),1)-repmat(LinearKeyLocs(:),1,length(LinearAnIndices));
clear LinearAnIndices LinearKeyLocs;
[InAnomaly,dummy]=find(InAnomaly==0);
KPData.VKPs(:,InAnomaly)=[];
KPData.Peaks(InAnomaly)=[];
clear InAnomaly
end