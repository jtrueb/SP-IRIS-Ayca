function GUI_Callback_btnMoveXLeft(hObject, eventdata)
%Shifts the stage left by step
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


[step] = STAGE_getStep(handles); %X Y
val = getParams(handles,'XPos') - step(1);

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = [val getParams(handles,'YPos')];
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.x};
    pos = val;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

guidata(hObject,handles);