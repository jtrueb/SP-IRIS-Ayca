function [handles] = FAN_setState(handles,option)

if isfloat(option)
    if option == 0
        %Turn fan off        
        [data] = LEDS_CONTROL(handles.LEDs,handles.LEDs.commands.fans_off);
        msg = 'Fans on';
    elseif option == 1
        %Turn LED on
        [data] = LEDS_CONTROL(handles.LEDs,handles.LEDs.commands.fans_on);
        msg = 'Fans on';
    end
    
elseif ischar(option)
    if strcmpi(option,'off')
        %Turn fan off        
        [data] = LEDS_CONTROL(handles.LEDs,handles.LEDs.commands.fans_off);
        msg = 'Fans off';
    elseif strcmpi(option,'on')
        %Turn LED on
        [data] = LEDS_CONTROL(handles.LEDs,handles.LEDs.commands.fans_on);
        msg = 'Fans on';
    end    
else
    msg = 'Incorrect input to FAN_setState';    
end
[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,2);