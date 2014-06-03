function [CurveData diameter_interpolated]= getCurveData(color,particle_type)


if strcmp(particle_type, 'AuNP')
    load GoldContrastCurves;
elseif strcmp(particle_type, 'Virus')
    load Poly100ContrastCurves;
elseif strcmp(particle_type, 'AgNP')
%     load GoldContrastCurves; 
end % TODO: add more as necessary


if strcmp(color, 'L1')% it's red
    d = data(:,2);
elseif strcmp(color, 'L2') % it's green
    d = data(:,1);
else %default to green
    d = data(:,1);
end % TODO: add more as necessary

dstep = 0.1;
diameter = data(:,3)*2;
diameter_interpolated = data(1,3)*2-10:dstep:data(end,3)*2;
pp = interp1(diameter,d,'cubic','pp');

CurveData = ppval(pp,diameter_interpolated);
end