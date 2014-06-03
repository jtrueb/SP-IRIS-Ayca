function KPData = getParticles_gui_input(image,handles)

% ImScale = 2.75; % this is fixed in Ahmet's version
ImScale=handles.ImScale;
IntTh=handles.IntTh;
EdgeTh=handles.EdgeTh;
fullwell=handles.fullwell;
MatchFlag = 0;

KPData.Feats=[];
% KPData = SIFTDetection_scalefix(I, IntensityTh, EdgeTh, MatchFlag, ImScale);



%Upsample the image to enlargen the features:
UpInputIm=single(imresize(image,ImScale,'bilinear'));


UpInputIm(UpInputIm>fullwell)=fullwell;

UpInputIm(UpInputIm<0)=0;

UpInputIm=255*UpInputIm./fullwell;

%[BWAnomalyMap]= GetAnomalyMap(UpInputIm);
%figure, imagesc(BWAnomalyMap), axis image, colormap gray, title('Anomaly
%map of the chip');

if MatchFlag==1
    [KPData.KPs,KPData.Feats] = vl_sift(UpInputIm, 'PeakThresh',IntTh,'EdgeThresh',EdgeTh);
else
    [KPData.KPs] = vl_sift(UpInputIm, 'PeakThresh',IntTh,'EdgeThresh',EdgeTh);
    KPData.Feats=[];
end

[KPData.VKPs]= ComputeVisualKeyPoints(KPData.KPs,ImScale, size(image));











KPData.Peaks=image(sub2ind(size(image), round(KPData.VKPs(2,:).'), round(KPData.VKPs(1,:).')));
end