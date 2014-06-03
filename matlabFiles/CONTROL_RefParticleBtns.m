function handles = CONTROL_RefParticleBtns(handles, state)
%callback function - Disables/Enables the reference particle btns
if nargin < 2
    state = 0;
end

%Set flag
[handles] = setParams(handles,'RefParticleStatus',state);

% set(handles.chkProcessRefParticle,'Value',state);
% set(handles.chkRefParticle,'Value',state);

if state == 1
    set(handles.popupSelectRefParticle,'Enable','on');
    set(handles.editRefMinHist,'Enable','on');
    set(handles.editRefMaxHist,'Enable','on');
    
    set(handles.popupProcessSelectRefParticle,'Enable','on');
    set(handles.editProcessRefMaxHist,'Enable','on');
    set(handles.editProcessRefMinHist,'Enable','on');
else
    set(handles.popupSelectRefParticle,'Enable','off');
    set(handles.editRefMinHist,'Enable','off');
    set(handles.editRefMaxHist,'Enable','off');
    
    set(handles.popupProcessSelectRefParticle,'Enable','off');
    set(handles.editProcessRefMaxHist,'Enable','off');
    set(handles.editProcessRefMinHist,'Enable','off');
end