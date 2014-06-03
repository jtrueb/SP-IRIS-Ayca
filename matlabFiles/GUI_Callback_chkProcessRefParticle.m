function GUI_Callback_chkProcessRefParticle(hObject, eventdata)
%callback function - enables/disables RefParticles material
handles = guidata(hObject);

%Get value
state = get(handles.chkProcessRefParticle,'Value');

%Enable/disable refparticle
[handles] = CONTROL_RefParticleBtns(handles, state);

guidata(hObject,handles);