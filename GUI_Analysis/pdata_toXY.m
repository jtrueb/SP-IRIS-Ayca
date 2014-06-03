function [output]=pdata_toXY(particledata,kde_options,limits_display,limits_signal)
%pdata_limit: [xmin ymin xmax ymax]


x_kde=particledata.correlations(:);

if strcmpi(kde_options,'size')
    y_kde=particledata.Size(:);
else
    y_kde=particledata.Contrasts(:);
end




XY_temp=[x_kde,y_kde];
XY_raw=XY_temp;
XY_raw=XY_raw(XY_raw(:,1)>limits_display(1),:);
XY_raw=XY_raw(XY_raw(:,1)<limits_display(2),:);
XY_raw=XY_raw(XY_raw(:,2)>limits_display(3),:);
XY_raw=XY_raw(XY_raw(:,2)<limits_display(4),:);


XY_filter=XY_raw;
XY_filter=XY_filter(XY_filter(:,1)>limits_signal(1),:);
XY_filter=XY_filter(XY_filter(:,1)<limits_signal(2),:);
XY_filter=XY_filter(XY_filter(:,2)>limits_signal(3),:);
XY_filter=XY_filter(XY_filter(:,2)<limits_signal(4),:);

output.pdata_limits=limits_signal;
output.pdata_options=kde_options;
output.XY_filter=XY_filter;
output.XY_raw=XY_raw;
output.count_raw=size(XY_raw,1);
output.count_filter=size(XY_filter,1);