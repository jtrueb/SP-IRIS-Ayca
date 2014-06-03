function IMAGE_clearAxis(figureHandle,axesHandle)

figure(figureHandle);
set(gcf,'CurrentAxes',axesHandle); %point to main Axes
cla(axesHandle,'reset');