function CAMERA_setParams(CAMERA, exposure, ROI, nFrames, binning, fps)
%set framerate!
params = ['camparam;shutter;' num2str(exposure) ';framecount;' num2str(nFrames),...
    ';framerate;' num2str(fps) ';bin;binh;' num2str(binning(1)) ';binv;' num2str(binning(2))];
roi = ['camparam;roi;left;' num2str(ROI(2)) ';top;' num2str(ROI(1)) ';width;' num2str(ROI(4)) ';height;' num2str(ROI(3))];
CAMERA.sw.WriteLine(params);
CAMERA.sr.ReadLine();
CAMERA.sw.WriteLine(roi);
CAMERA.sr.ReadLine();
