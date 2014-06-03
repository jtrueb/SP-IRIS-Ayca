function [handles,newROI] = FOCUS_CropRefSquare(handles)
%FOCUS_CropRefSquare detects the reference square in the image & returns an
%ROI surround it
%   An image is taken. Image morphology and a multi-step thresholding are
%   used to isolate 1 square in a binary image for detection. The ROI is
%   1/16th the field-of-view with the square as the center.

%Acquire the image
[handles,data] = ACQUIRE_scan(handles,'take');

%Detect the reference square
[center] = DETECT_RefSquare(data,0.98,40); %Y/X

%Determine the ROI around the returned center
image_size = size(data); %Determine size of the image
sq_size = floor(image_size./3); %Calculate 1/9 image_size
offset = center - sq_size./2;%Determine ROI offset

if offset(1) <= 0 %Adjust crop size if there is an edge
    sq_size(1) = sq_size(1) + offset(1)+1;
    offset(1) = 1;
end
if (offset(1)+sq_size(1)) >= image_size(1) %Adjust crop size if there is an edge
    sq_size(1) = image_size(1) - offset(1);
end
if offset(2) <= 0 %Adjust crop size if there is an edge
    sq_size(2) = sq_size(2) + offset(2)+1;
    offset(2) = 1;
end
if (offset(2)+sq_size(2)) >= image_size(2) %Adjust crop size if there is an edge
    sq_size(2) = image_size(2) - offset(2);
end

newROI = [offset sq_size];
%figure; imshow(data./max(max(data))); rectangle('Position',[newROI(2)...
%newROI(1) newROI(4) newROI(3)])