function out=CAMERA_getImage(CAMERA)
%This function returns the image

CAMERA = CAMERA_acquire(CAMERA);
out = CAMERA_readfile(CAMERA);