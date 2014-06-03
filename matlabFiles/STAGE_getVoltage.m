function [Vx, Vy, Vz] = STAGE_getVoltage(stages)

[Vx] = STAGE_getVoltageAxis(stages,stages.axis.x);
[Vy] = STAGE_getVoltageAxis(stages,stages.axis.y);
[Vz] = STAGE_getVoltageAxis(stages,stages.axis.z);