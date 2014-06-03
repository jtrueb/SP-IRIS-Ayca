function out = CAMERA_QuantFocus(image)
%This function takes in an image and outputs the quantification of how in
%focus it is. The nighter this output number, the more in focus the sample
%is.

[r c]=size(image);
norma = sum(sum(image));
%norma = 1;

a = abs(fft2(image));
%This will take the top and bottom 10 percent of the image
%This is a high pass filter
botr = floor(.1*r);
topr = ceil(.9*r);
botc = floor(.1*c);
topc = ceil(.9*c);
a(botr:topr,botc:topc) = 0;

% h = fspecial('gaussian', [r c], r/10);
% mask = h>1e-8;

out = sum(sum(a))/norma;