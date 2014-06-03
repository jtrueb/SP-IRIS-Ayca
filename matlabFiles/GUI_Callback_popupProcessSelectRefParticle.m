function GUI_Callback_popupProcessSelectRefParticle(hObject, eventdata)
%callback function - 
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupProcessSelectRefParticle,'Value');
[handles] = setParams(handles,'RefParticleType',currentIndex);

guidata(hObject,handles);