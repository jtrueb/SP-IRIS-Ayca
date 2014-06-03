function STAGE_setVelocityAxis(stages,axis_in,val)

val=val*stages.convert;
valString=num2str(val);
if(isempty(find(valString=='.',1)))
    valString=[valString '.0'];
end

loopAndCheck(stages, axis_in, valString);
    






function loopAndCheck(stages, axis_in, val)
loopenable = 1;
while(loopenable)
    [data] = STAGE_CONTROL(stages,[val ' ' axis_in ' ' stages.commands.setVelocity]);
    [velocity_axis] = STAGE_getVelocityAxis(stages,axis_in);
    if (velocity_axis == str2double(val)/stages.convert)
        loopenable = 0;
    else
        pause(0.1);
    end
end