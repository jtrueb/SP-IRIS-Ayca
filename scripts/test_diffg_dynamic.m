%%
handles=[];
figure(2);
for m=1:length(zStack.slice)
    temp=zStack.slice(m).image;
    [focus_trace(m),diff_im]=QUANTIFY_diffG(handles,temp,0);
    
    subplot(211);
    imshow(temp,[mean(temp(:))-2*std(temp(:)),mean(temp(:))+2*std(temp(:))]);
    
    subplot(212);
    
    imshow(diff_im,[mean(diff_im(:))-2*std(diff_im(:)),mean(diff_im(:))+2*std(diff_im(:))]);
    
%     subplot(133);
%     plot(focus_trace);
    title(['Slice ' num2str(m) ' / ' num2str(length(zStack.slice))])
    pause();
end

figure(3);
plot(focus_trace);

%%
[xmax,imax,xmin,imin] = extrema(focus_trace);

% out=QUANTIFY_diffG(handles,zStack.slice(imax(1)).image,1);

