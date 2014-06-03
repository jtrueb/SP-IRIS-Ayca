function [handles] = CONTROL_zoomMode(handles,clickButton)
% Determines what to do when the click buttons are enabled

[color] =  GUI_Colors();
oncolor = color.btnOn;
offcolor = color.btnOff;

if (strcmpi(clickButton,'zoom in'))
    [handles] = CONTROL_setPan(handles,'off');
    zoom(handles.panels.figure, 2);

elseif (strcmpi(clickButton,'zoom out'))
    [handles] = CONTROL_setPan(handles,'off');
    zoom(handles.panels.figure, 1/2);
    
elseif (strcmpi(clickButton,'zoom full'))
    [handles] = CONTROL_setPan(handles,'off');
    zoom(handles.panels.figure,'out');
    
elseif (strcmpi(clickButton,'pan'))
     if (get(handles.btnPan,'BackgroundColor') == oncolor)
         pn_color = offcolor;
         [handles] = CONTROL_setPan(handles,'off');
     else
         pn_color = oncolor;
         [handles] = CONTROL_setPan(handles,'on');
     end
     set(handles.btnPan,'BackgroundColor',pn_color);
end