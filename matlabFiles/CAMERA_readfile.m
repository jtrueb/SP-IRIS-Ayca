function image = CAMERA_readfile(CAMERA)
%First we must read in the Header file
%pause(.8)
fp = fopen([CAMERA.dir '\' CAMERA.file '.chdr']);
a = textscan(fp,'%d');
fclose(fp);

Header.xstart = double(a{1}(1));
Header.ystart = double(a{1}(2));
Header.xsize = double(a{1}(3));
Header.ysize = double(a{1}(4));
Header.xbin = double(a{1}(5));
Header.ybin = double(a{1}(6));
Header.exposure = double(a{1}(7));
Header.numframes = double(a{1}(8));

%Now the image is read using the information in the header
fp = fopen([CAMERA.dir '\' CAMERA.file  '.cdat']);
matrix = fread(fp,[Header.xsize,Header.ysize],'*uint16');
fclose(fp);
%image = reshape(matrix,Header.xsize,Header.ysize)';
image = double(matrix'); 
%image;
%imshow(image,[4.94e4 5.82e4])