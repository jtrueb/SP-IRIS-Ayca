function circleParticles(i, im, KPData, saveName, outFolderName)

fig = figure('Visible','off');  % for making output figures
imshow(im,[]), axis image, colormap gray, hold on;

for circleindex=1:size(KPData.VKPs,2)
    circle([KPData.VKPs(1,circleindex),KPData.VKPs(2,circleindex)], 6, 100, '-g');
end

print(fig, [outFolderName saveName], '-djpeg');