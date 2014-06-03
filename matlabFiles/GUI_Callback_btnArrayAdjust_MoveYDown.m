function GUI_Callback_btnArrayAdjust_MoveYDown(hObject, eventdata)
%Shifts the stage up by step
[handles_popup] = guidata(hObject);
handles = handles_popup.mainGUI;

[step] = [10 10]; %X Y
val = getParams(handles,'YPos') - step(2);

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    pos = [getParams(handles,'XPos') val];
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.y};
    pos = val;
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

handles_popup.mainGUI = handles;
guidata(hObject,handles_popup);