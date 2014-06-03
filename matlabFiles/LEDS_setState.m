function [handles] = LEDS_setState(handles,option)
feedbackLvl = -1;
LEDControl = getParams(handles,'LEDControl');

if ischar(option)
    if strcmpi(option,'off')
        %Turn LED off
        if strcmpi(LEDControl,'Router')
            [data] = LEDS_CONTROL_Prototype(handles.LEDs,handles.LEDs.commands.leds_off);
        elseif strcmpi(LEDControl,'DAQ')
            [data] = LEDS_CONTROL_DAQ(handles.LEDs,handles.LEDs.commands.leds_off);
        elseif strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.leds_off);
            
        elseif strcmpi(LEDControl,'Analog')
            [data] = [];
        end
        msg = 'LED turned off';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
        
    elseif strcmpi(option,'on')
        % Turn LED on
        val = getParams(handles,'LED');
        if strcmpi(LEDControl,'Router')
            [data] = LEDS_CONTROL_Prototype(handles.LEDs,val);
        elseif strcmpi(LEDControl,'DAQ')
            [data] = LEDS_CONTROL_DAQ(handles.LEDs,val);
        elseif strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,val);
        elseif strcmpi(LEDControl,'Analog')
            [data] = [];
            
        end
        msg = 'LED turned on';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
     elseif strcmpi(option,'vacuumon1')
        % Turn LED on
        if strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.vacuum_on);
            pause(0.02);
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.valve_off);
        end
        handles.LEDs.pneumatics.valve = 0;
        handles.LEDs.pneumatics.vac = 1;
        msg = 'VACUUM turned on';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
     elseif strcmpi(option,'vacuumres1')
        % Turn vacuum on
        if strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.vacuum_on);
            pause(0.02);
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.valve_on);
        end
        handles.LEDs.pneumatics.valve = 1;
        handles.LEDs.pneumatics.vac = 1;
        msg = 'VACUUM RES turned on';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
     elseif strcmpi(option,'res1')
        % Turn vacuum on
        if strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.vacuum_off);
            pause(0.05);
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.valve_on);
        end
        handles.LEDs.pneumatics.valve = 1;
        handles.LEDs.pneumatics.vac = 0;
        msg = 'VACUUM RES turned on';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
         
            
        
     elseif strcmpi(option,'vacuumoff1')
        % Turn vacuum off
        if strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.vacuum_off);
            pause(0.02);
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.valve_off);
        end
        handles.LEDs.pneumatics.valve = 0;
        handles.LEDs.pneumatics.vac = 0;
        msg = 'VACUUM turned off';
        [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
    elseif strcmpi(option,'vacuumpres1')
        % measure pressure
        if strcmpi(LEDControl,'Arduino')
            %[data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.pressure);
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,'P');
        end
        firstchar = findstr(data,':');
        val_t = 1000;
        if (size(firstchar,2) == 2)
            val_t = str2num(strtrim(data(firstchar(2)+1:end)));
        end
        val_t = 600;
        handles.LEDs.pneumatics.pressure = val_t;
            %:Pressure: 563
        %data
        %msg = 'VACUUM RES turned on';
        %[handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,feedbackLvl);
                 
    elseif strcmpi(option,'status')
        if strcmpi(LEDControl,'Router')
            [data] = LEDS_CONTROL_Prototype(handles.LEDs,handles.LEDs.commands.state_status);
            val = str2double(data);
        elseif strcmpi(LEDControl,'DAQ')
            val = 1;
        elseif strcmpi(LEDControl,'Arduino')
            [data] = LEDS_CONTROL_ARDUINO(handles.LEDs,handles.LEDs.commands.state_status);
            val = str2double(data(2:end)); %first char is ":"
        elseif strcmpi(LEDControl,'Analog')
            [data] = 'Analog LEDs';
            val =  1; %first char is ":"
        end
        [handles] = setParams(handles,'SystemStatus',val);
    end
else
    msg = 'Incorrect input to LED_setState';
    [handles] = GUI_logMsg(handles,msg,handles.const.log.instrument,handles.txtLog,2);
end