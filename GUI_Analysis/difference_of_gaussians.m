%%# Read an image
% f=figure;
clear sumpos;
clear sumneg;
clear sumAbs;
clear sumIm;
for x=1:length(zStack.slice)
    

I=zStack.slice(x).image;
I=I.*median(mir(:))./mir;


G = fspecial('gaussian',[9,9],2^.5);
%# Filter it
Ig = imfilter(I,G,'same');
Ig2=imfilter(Ig,G,'same');
IgDiff=Ig-Ig2;
IgDiffPos=IgDiff;
IgDiffPos(IgDiffPos(:)<0)=0;

IgDiffNeg=IgDiff;
IgDiffNeg(IgDiffNeg(:)>0)=0;
IgDiffAbs=abs(IgDiff);

sumpos(x)=sum(IgDiffPos(:));
sumneg(x)=sum(IgDiffNeg(:));
sumAbs(x)=sum(IgDiffAbs(:));
sumIm(x)=sum(I(:));

% end



if x==9
    figure;
    title(['Slice ',num2str(x)]);
    subplot(2,2,1);
    imshow(I,[mean(I(:))-2*std(I(:)),mean(I(:))+2*std(I(:))]);
    title('Original');
    
    subplot(2,2,2);
    imshow(IgDiff,[mean(IgDiff(:))-2*std(IgDiff(:)),mean(IgDiff(:))+2*std(IgDiff(:))]);
    title('Diff of Gauss');
    
    
    subplot(2,2,3);
    imshow(IgDiffAbs,[mean(IgDiffAbs(:))-2*std(IgDiffAbs(:)),mean(IgDiffAbs(:))+2*std(IgDiffAbs(:))]);
    title(['Absolute diff of Gauss, sum = ', num2str(sum(IgDiffAbs(:)))]);
    
    
    
    subplot(2,2,4);
    imshow(IgDiffPos,[mean(IgDiffPos(:))-2*std(IgDiffPos(:)),mean(IgDiffPos(:))+2*std(IgDiffPos(:))]);
    title(['Positive diff of Gauss, sum = ',num2str(sum(IgDiffPos(:)))]);

end
end

figure; hold off;
subplot 221;
plot(sumpos(:));
title('pos');
subplot 222;
plot(sumneg(:));
title('neg');
subplot 223;
plot(sumAbs(:));
title('abs');
subplot 224;
plot(sumIm(:));
title('original');


%# Display
% imshow(Ig)