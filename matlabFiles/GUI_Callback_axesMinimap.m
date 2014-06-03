function GUI_Callback_axesMinimap(hObject, eventdata)
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);


%Get cursor position
cursor = round(get(gca,'CurrentPoint'));
pos = [cursor(1,1) cursor(1,2)];    

%Move to position
% [handles] = setParams(handles, 'Stage_XYPos', pos);

if getParams(handles,'SmartMove')
    axes = {handles.Stage.axis.x handles.Stage.axis.y handles.Stage.axis.z};
    [handles] = STAGE_SmartMove_MoveAbsolute(handles,axes,pos);
else
    axes = {handles.Stage.axis.x handles.Stage.axis.y};
    [handles] = STAGE_MoveAbsolute(handles,axes,pos);
end

guidata(hObject,handles);