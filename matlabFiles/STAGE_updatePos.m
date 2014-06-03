function [handles] = STAGE_updatePos(handles,axes,steps,relativeOrAbsolute)
%Updates the XYZ position of the GUI
if strcmpi(relativeOrAbsolute,handles.Stage.commands.move_absolute)
    for i = 1:size(axes,2)
        if strcmpi(axes{i},handles.Stage.axis.x)
            [handles] = setParams(handles,'XPos',steps(i));
        elseif strcmpi(axes{i},handles.Stage.axis.y)
            [handles] = setParams(handles,'YPos',steps(i));
        elseif strcmpi(axes{i},handles.Stage.axis.z)
            [handles] = setParams(handles,'ZPos',steps(i));
        end
    end
else
    [pos] = getParams(handles, 'Stage_Pos');
    for i = 1:size(axes,2)
        if strcmpi(axes{i},handles.Stage.axis.x)
            [handles] = setParams(handles,'XPos',pos(1)+steps(i));
        elseif strcmpi(axes{i},handles.Stage.axis.y)
            [handles] = setParams(handles,'YPos',pos(2)+steps(i));
        elseif strcmpi(axes{i},handles.Stage.axis.z)
            [handles] = setParams(handles,'ZPos',pos(3)+steps(i));
        end
    end
end
    