function output = FOCUS_FitCoarse(Q,usePeak)
%This funcion uses a low pass filter to determine where the focal point is

filt = fir1(2,.95,'low');
a = filter(filt,1,Q.y);

filtered = Q.y - a;

filtered(1) = -10;
 
new = filtered; 
new(1) = [];
new = [new 0];
filtered = filtered - new; 

for i = 1:usePeak
    max_x = max(filtered)==filtered;
    
    if i == usePeak
        output = Q.x(max_x);
    else
        ind = find(max_x == 1)+5;
        filtered = filtered(ind:end);
        Q.x = Q.x(ind:end);
    end
end
    
% max_x = max(filtered)==filtered;    
% output = Q.x(max_x); 