function handles = GUI_logSpotNum(handles,numSpot,totalSpot)

if isfloat(numSpot)
    spot = num2str(numSpot);
else
    spot = numSpot;
end
if isfloat(totalSpot)
    total = num2str(totalSpot);
else
    total = totalSpot;
end

set(handles.txtScanPos,'String',[spot '/' total])
drawnow;