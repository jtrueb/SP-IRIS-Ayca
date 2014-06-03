function GUI_Callback_popupSelectParticle(hObject, eventdata)
%callback function - 
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupSelectParticle,'Value');
[handles] = setParams(handles,'ParticleType',currentIndex);

guidata(hObject,handles);