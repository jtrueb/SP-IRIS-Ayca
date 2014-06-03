function [Minimap_pos] = IMAGE_Minimap_convertStagePos(handles,Stage_pos)
%Converts an [X Y] stage position to an [Y X] location on the minimap

conversion = getParams(handles,'StageToMinimapConversion'); % [Y X] [um/pixel]
startPos = getParams(handles,'MinimapStartPos'); %Starting Position

xPos = Stage_pos(1)-startPos(1); %Determine Stage XPos
yPos = Stage_pos(2)-startPos(2); %Determine Stage YPos

Minimap_pos = fix([yPos xPos]./conversion); %Determine location in minimap [pixel]

minimap = getParams(handles,'Minimap'); %[Y X]
if Minimap_pos(1) == 0
    Minimap_pos(1) = 1;
end
if Minimap_pos(2) == 0
    Minimap_pos(2) = 1;
end

if (Minimap_pos < 0) | (Minimap_pos > size(minimap))
    Minimap_pos = [nan nan];
    msg = 'Stage position is outside of the minimap';
    [handles] = GUI_logMsg(handles,msg,handles.const.log.parameter,handles.txtLog);
end