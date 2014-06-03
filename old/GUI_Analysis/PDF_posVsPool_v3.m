function [ output] = PDF_posVsPool_v3(handles,calc_xypdata,ref_xypdata,grid_dim,blank_flag)
% output = PdfVsPool_v3(limits,calc_chip,calc_ind,ref_chip,ref_ind,h_force,unit_area)
%

if nargin<5
    blank_flag=0;
    grid_dim=50;
elseif nargin < 4
    
grid_dim=50;
end;
limits_display=handles.limits_display;
%transcribe limits to[xmin ymin xmax ymax]
kde_limits=[limits_display(1),limits_display(3),limits_display(2),limits_display(4)];
limits_display=kde_limits;
limits_signal=handles.limits_signal;
% limits_display=handles.limits_display;
unit_area=((limits_display(3)-limits_display(1))/grid_dim)*((limits_display(4)-limits_display(2))/grid_dim);

% pdata_limits=varargin{1};
% calc_chip=varargin{2};
% calc_ind=varargin{3};
% ref_chip=varargin{4};
% ref_ind=varargin{5};
% h_force=varargin{6};
% unit_area=varargin{7};





%Genderate kde plots for calc_xypdata
calc_kde_filter=gkde2_bounded_v2(calc_xypdata.XY_filter,limits_display,grid_dim);


%Generate kde plots for unfiltered calc_xypdata for user reference
calc_kde_raw=gkde2_bounded_v2(calc_xypdata.XY_raw,limits_display,grid_dim);


if blank_flag
    ref_kde_filter.pdf=zeros(grid_dim,grid_dim);
    ref_kde_filter.npart=0;
    ref_kde_raw.pdf=zeros(grid_dim,grid_dim);
    ref_kde_raw.npart=0;
    
    ref_pool_number=1;
    
    
else

ref_pool_number=ref_xypdata.pool_number;
%Generate kde plots for pooled reference pdata at the measured calc
%bandwidth
ref_kde_filter=gkde2_bounded_v2(ref_xypdata.XY_filter,limits_display,grid_dim,calc_kde_filter.h);
ref_kde_raw=gkde2_bounded_v2(ref_xypdata.XY_raw,limits_display,grid_dim,calc_kde_filter.h);
end


%calculate error by integrating normalized pdfs (will be a fraction
%of 1)
sum_calc_norm_raw=sum(calc_kde_raw.pdf(:))*unit_area;
sum_calc_norm=sum(calc_kde_filter.pdf(:))*unit_area;
sum_ref_norm_raw=sum(ref_kde_raw.pdf(:))*unit_area;
sum_ref_norm=sum(ref_kde_filter.pdf(:))*unit_area;

%generate absolute kde plots by multiplying normalized plots by particle
%count and upscaling by integration error.

if sum_calc_norm_raw>0
    calc_pdf_abs_raw=calc_kde_raw.pdf.*calc_kde_raw.npart/sum_calc_norm_raw;
end

if sum_calc_norm>0
    calc_pdf_abs=calc_kde_filter.pdf.*calc_kde_filter.npart/sum_calc_norm;
end

if blank_flag
    ref_pdf_abs_raw=ref_kde_raw.pdf;
    ref_pdf_abs=ref_kde_filter.pdf;
else
    
    if sum_ref_norm_raw>0
        ref_pdf_abs_raw=ref_kde_raw.pdf.*ref_kde_raw.npart/(sum_ref_norm_raw*ref_pool_number);
    end
    
    if sum_ref_norm>0
        ref_pdf_abs=ref_kde_filter.pdf.*ref_kde_filter.npart/(sum_ref_norm*ref_pool_number);
    end
end


%integral of absolute surface should = particle count
% sum_calc_abs=sum(calc_pdf_abs(:))*unit_area;
% sum_ref_abs=sum(ref_pdf_abs(:))*unit_area;

%generate reference normalized surface;
signal_pdf_raw=calc_pdf_abs-ref_pdf_abs;

%generate surface of positive signal
signal_pdf_pos=signal_pdf_raw;
signal_pdf_pos(signal_pdf_pos(:)<0)=0;

%generate surface of negative signal
% signal_pdf_neg=signal_pdf_raw;
% signal_pdf_neg(signal_pdf_neg(:)>0)=0;

%Integrate signal pdfs for output sum
sum_signal_pos=sum(signal_pdf_pos(:))*unit_area;
% sum_signal_neg=sum(signal_pdf_neg(:))*unit_area;

%Calculate highest point on calc_pdf_abs_raw, for display caxis
[val,ind]=max(calc_pdf_abs(:));

output.color_max=val;

% output.count_raw=calc_kde_raw.npart;


output.kde_xticks=calc_kde_filter.x(1,:);
output.kde_yticks=calc_kde_filter.y(:,1).';

output.count_signal_raw=calc_kde_filter.npart;
output.count_reference=ref_kde_filter.npart;
output.count_signal_normalized=sum_signal_pos;
output.signal_pdf_pos=signal_pdf_pos;
% output.signal_pdf_neg=signal_pdf_neg;
% output.sum_signal_pos=sum_signal_pos;
% output.sum_signal_neg=sum_signal_neg;
output.calc_pdf_filtered=calc_pdf_abs;
output.calc_pdf_displaylimits=calc_pdf_abs_raw;
output.ref_pdf_filtered=ref_pdf_abs;
output.ref_pdf_displaylimits=ref_pdf_abs_raw;
% output.calc_pdf_abs_raw=calc_pdf_abs_raw;
output.unit_area=unit_area;
output.grid_dim=grid_dim;
output.limits_signal=limits_signal;
output.limits_window=limits_display;




 
end








