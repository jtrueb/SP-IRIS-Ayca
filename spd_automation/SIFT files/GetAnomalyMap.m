function [BWAnomalyMap]= GetAnomalyMap(Image,Th)

if nargin <2
    Th=100;
end

Image=Image-min(Image(:));
Image=255*Image./max(Image(:));
ContrastMap=rangefilt(Image, ones(5,5));
clear Image
BWContrastMap=ContrastMap> Th;
clear ContrastMap
BWAnomalyMap=imclose(BWContrastMap,ones(5,5));
clear BWContrastMap
BWAnomalyMap=imfill(BWAnomalyMap,'holes');