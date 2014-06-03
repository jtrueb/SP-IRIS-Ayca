function GUI_Callback_popupProcessSelectParticle(hObject, eventdata)
%callback function - 
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupProcessSelectParticle,'Value');
[handles] = setParams(handles,'ParticleType',currentIndex);

guidata(hObject,handles);