function STAGE_setVoltage(stages, V)

sendCommands(stages,V);
    
function sendCommands(stages,V)
%% do z first!
% loopCommands(stages,stages.axis.z,V(3));
loopCommands(stages,stages.axis.x,V(1));
loopCommands(stages,stages.axis.y,V(2));

function loopCommands(stages,axis_in,val)
loopenable = 1;
while(loopenable)
    [data] = STAGE_CONTROL(stages,[num2str(val) ' ' axis_in ' ' stages.commands.setVoltage]);
    [voltage_axis] = STAGE_getVoltageAxis(stages,axis_in);
    if (voltage_axis == val)
        loopenable = 0;
    else
        pause(0.1);
    end
end



    
