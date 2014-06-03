function CAMERA = CAMERA_closePreview(CAMERA)

CAMERA.sw.WriteLine('preview;off');
CAMERA.sr.ReadLine();