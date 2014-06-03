function [VoltageStage] = STAGE_getVoltageAxis(stages,axis_in)
%Gets the stage movement velocity
VoltageStage = loopAndCheck(stages, axis_in);

function [data] = loopAndCheck(stages, axis_in)
loopenable = 1;
while (loopenable)
    [data] = str2double(STAGE_CONTROL_RESPONSE(stages,[axis_in ' ' stages.commands.getVoltage]));
    if ((data >= 0) & ~isnan(data))
        loopenable = 0;
    end
end
