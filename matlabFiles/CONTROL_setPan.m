function [handles] = CONTROL_setPan(handles,state)

[color] =  GUI_Colors();
oncolor = color.btnOn;
offcolor = color.btnOff;

h = pan;
% set(h,'ActionPostCallback',@GUI_Callback_Pan);

if strcmpi(state,'off')
    pn_color = offcolor;
    set(h,'Enable','off');
    setAllowAxesPan(h,handles.axesMain,false);

elseif strcmpi(state,'on')
    pn_color = oncolor;
    set(h,'Enable','on');
    setAllowAxesPan(h,handles.axesMain,true);
end
set(handles.btnPan,'BackgroundColor',pn_color);