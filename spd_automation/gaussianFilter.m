function KPData =  gaussianFilter(im, KPData, TemplateSize, SD,GaussianTh)

[GaussianCorrCoefsPreSpot]=GaussianTemplateMatch(im, KPData.VKPs, TemplateSize, SD);
SimilartoGaussianPre=GaussianCorrCoefsPreSpot > GaussianTh;
KPData.VKPs= KPData.VKPs(:,SimilartoGaussianPre);
KPData.Peaks= im(sub2ind(size(im), round(KPData.VKPs(2,:).'), round(KPData.VKPs(1,:).')));
end