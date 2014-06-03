function [output,IgDiffAbs] = QUANTIFY_diffG(handles,image, figure_flag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin<3
    figure_flag=0;
end

s1=1.5;
s2=3;

G1 = fspecial('gaussian',[11,11],s1);
G2= fspecial('gaussian',[11,11],s2);
%# Filter it
Ig = imfilter(image,G1,'same');
Ig2=imfilter(image,G2,'same');
IgDiff=Ig-Ig2;
% IgDiffPos=IgDiff;
% IgDiffPos(IgDiffPos(:)<0)=0;

% IgDiffNeg=IgDiff;
% IgDiffNeg(IgDiffNeg(:)>0)=0;
IgDiffAbs=abs(IgDiff);
output=sum(IgDiffAbs(:));

if figure_flag
    
    figure(1);
    imshow(IgDiffAbs,[mean(IgDiffAbs(:))-2*std(IgDiffAbs(:)),mean(IgDiffAbs(:))+2*std(IgDiffAbs(:))]);
    
    
end



end

