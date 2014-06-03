function GUI_Callback_popupSelectRefParticle(hObject, eventdata)
%callback function - Initializes stages and moves for sample loading
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupSelectRefParticle,'Value');
[handles] = setParams(handles,'RefParticleType',currentIndex);

guidata(hObject,handles);