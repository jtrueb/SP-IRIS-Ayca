function GUI_Callback_btnMoveYUp(hObject, eventdata)
%Shifts the stage up by step
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[step] = STAGE_getStep(handles); %X Y
val = getParams(handles,'YPos') + step(2);

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = [getParams(handles,'XPos') val];
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.y};
    pos = val;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

guidata(hObject,handles);