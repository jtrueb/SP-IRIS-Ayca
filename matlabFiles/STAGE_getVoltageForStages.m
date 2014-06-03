function [stages] = STAGE_getVoltageForStages(stages)

[Vx, Vy, Vz] = STAGE_getVoltage(stages);

stages.axis.Vx = Vx;
stages.axis.Vy = Vy;
stages.axis.Vz = Vz;