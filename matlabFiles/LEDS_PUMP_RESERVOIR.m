function [handles] = LEDS_PUMP_RESERVOIR(handles)

% if (handles.LEDs.pneumatics.valve ~= 1) && (handles.LEDs.pneumatics.vac ~= 0)
%     [handles] = LEDS_setState(handles,'vacuumres');
%     pause(0.02);
% end
% 
% 
% %check pressure
% [handles] = LEDS_setState(handles,'vacuumpres');
% if (handles.LEDs.pneumatics.pressure > 850)
%     if (handles.LEDs.pneumatics.vac ~= 1)
%         [handles] = LEDS_setState(handles,'vacuumres');
%         pause(0.05);
%     end
%     while (handles.LEDs.pneumatics.pressure > 650)
%         pause(0.05);
%         fprintf('Pressure: %d\n',handles.LEDs.pneumatics.pressure);
%         [handles] = LEDS_setState(handles,'vacuumpres');
%     end
%     %[handles] = LEDS_setState(handles,'res');
% end
% pause(0.05);
% fprintf('a\n');
% [handles] = LEDS_setState(handles,'res');
% fprintf('b\n');
% fprintf('Pressure: %d\n',handles.LEDs.pneumatics.pressure);


