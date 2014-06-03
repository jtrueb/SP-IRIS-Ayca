function [StageVelocity] = STAGE_getVelocityAxis(stages,axis_in)
%Sets the stage movement velocity
StageVelocity = loopAndCheck(stages, axis_in);
StageVelocity=StageVelocity/stages.convert;

function [data] = loopAndCheck(stages, axis_in)
loopenable = 1;
while (loopenable)
    [data] = str2double(STAGE_CONTROL_RESPONSE(stages,[axis_in ' ' stages.commands.getVelocity]));
    if ((data >= 0) & ~isnan(data))
        loopenable = 0;
    end
end