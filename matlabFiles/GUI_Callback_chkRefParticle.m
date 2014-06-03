function GUI_Callback_chkRefParticle(hObject, eventdata)
%callback function - enables/disables RefParticles material
handles = guidata(hObject);

%Get value
state = get(handles.chkRefParticle,'Value');

%Enable/disable refparticle
[handles] = CONTROL_RefParticleBtns(handles, state);

guidata(hObject,handles);