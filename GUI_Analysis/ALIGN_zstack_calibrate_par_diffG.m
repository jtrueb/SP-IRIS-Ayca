function [ output ] = ALIGN_zstack_calibrate_par_diffG(zStack,figure_name,mir_temp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Fraction of smallest image dim to crop a center square from
a=tic;

display_figures_flag=1;

screw_span=1.18; %inches
tpi=100; %threads per inch
eff_pixel=.1172;  %%eff_pixel = physical pixel size / magnification



handles.empty=[];
% pdata_kde_limits=handles.limits_display;

if nargin <3
    mirror_flag=0;
    mir_temp=[];
else
    mirror_flag=1;
end

% 
% 
% mir_temp=[];
% if ~isempty(handles.mirname) && ~isempty(handles.mirdir)
%     clear data;
%     clear frame;
%     clear data_mir;
%     
% 
%         
%     load([handles.mirdir,handles.mirname]);
%     
%     if exist('data_mir')==1
%         mirror_flag=1;
%         mir_temp=data_mir;
%         clear data_mir;
%     elseif exist('data')==1
%         mirror_flag=1;
%         mir_temp=data;
%         clear data;
%     elseif exist('frame')==1
%         mirror_flag=1;
%         mir_temp=frame;
%         clear frame;
%     else
%         disp('Error: not a mirror file');
%     mirror_flag=0;
%     
%     end
% else
%     mirror_flag=0;
%       
% end

im_temp=zStack.slice(1).image;
    res=[size(im_temp,1),size(im_temp,2)];  %# pixels in [Y,X]
    [min_res,min_dim]=min(res); %min_dim=1 if y is min, =2 if x is min
    
   
        

%increase ROI to full smallest dim
ROI_scale=1;
rect_length=min_res*ROI_scale;
    y_offset=(size(im_temp,1)-rect_length)/2;
    x_offset=(size(im_temp,2)-rect_length)/2;
    
    im_crop_indices=[y_offset+1:rect_length+y_offset;x_offset+1:rect_length+x_offset];
    
%     kde_pixel_size=(rect_length+2*kde_offset)/kde_bins;
    
 
    output.im_crop_indices=im_crop_indices;


    analysis_range=1:length(zStack.slice);
scanlength=length(analysis_range);


% kde_binlength=length(kde_indices);
kde_binlength=size(zStack.slice(1).image);

% kde_indices=[1+kde_offset/kde_pixel_size:kde_bins-kde_offset/kde_pixel_size];


output.analysis_range=analysis_range;

sigma_1=1.5;
sigma_2 = 3;
sigma_blur=100;


    
    kernel_1=15;
kernel_2=300;

    G1 = fspecial('gaussian',[kernel_1,kernel_1],sigma_1);
    G2 = fspecial('gaussian',[kernel_1,kernel_1],sigma_2);
    G_blur = fspecial('gaussian',[kernel_2,kernel_2],sigma_blur);
    

disp('ALIGN - Generating Edge Responses...');   
    %quantify difference of gaussians  
for x=1:length(analysis_range)
 
    
    I=zStack.slice(x).image;
    
    if mirror_flag
        I=I.*median(mir_temp(:))./mir_temp;
    end
    

    %# Filter it
    Ig = imfilter(I,G1,'same');
    Ig2=imfilter(I,G2,'same');
    
    
    
    IgDiff=Ig-Ig2;
    IgDiffPos=IgDiff;
    IgDiffPos(IgDiffPos(:)<0)=0;
    
    IgDiffNeg=IgDiff;
    IgDiffNeg(IgDiffNeg(:)>0)=0;
    IgDiffAbs=abs(IgDiff);
    
    
    Ig_blur=imfilter(IgDiffAbs(1+kernel_1:kde_binlength(1)-kernel_1,1+kernel_1:kde_binlength(2)-kernel_1),G_blur,'same');
    
  

    temp_pdf{x}=Ig_blur;
    
end
    
    
    
 skip=0;   
    

pdf_abs=zeros(size(Ig_blur,1),size(Ig_blur,2),1,scanlength);
for m=1:length(analysis_range)
    pdf_abs(:,:,1,m)=temp_pdf{m};
end


output.max_dens_abs=0;
output.max_pdata_abs=max(pdf_abs(:));
output.pdf_abs=pdf_abs;
% output.kde_marginal_difference=kde_marginal_difference;

density_map=zeros(size(Ig_blur,1),size(Ig_blur,2));
focus_map=zeros(size(Ig_blur,1),size(Ig_blur,2));
% density_map=zeros(kde_binlength(1),kde_binlength(2));
% focus_map=zeros(kde_binlength(1),kde_binlength(2));

disp('ALIGN - Calculating Pixel Focus Extrema...');

for i=1:size(pdf_abs,1)
    for j=1:size(pdf_abs,2)
        [max_density,max_plane]=max(pdf_abs(i,j,1,:));
        density_map(i,j)=max_density;
        focus_map(i,j)=zStack.slice(analysis_range(max_plane)).z_pos;
        if max_density>output.max_dens_abs
            output.max_dens_abs=max_density;
        end
    end
end


disp('ALIGN - Fitting Alignment Plane...');



% [planefit, goodnessoffit] = focus_planefit((x_allpix(density_mask(:)))*eff_pixel, (y_allpix(density_mask(:)))*eff_pixel, focus_map(density_mask(:)));

x_pix_array=[(1+kernel_1):(kde_binlength(2)-kernel_1)];
y_pix_array=[(1+kernel_1):(kde_binlength(1)-kernel_1)].';

x_pix_array=repmat(x_pix_array,size(y_pix_array,1),1);
y_pix_array=repmat(y_pix_array,1,size(x_pix_array,2));

[planefit, goodnessoffit] = focus_planefit(x_pix_array*eff_pixel, y_pix_array*eff_pixel, focus_map);

cvals=coeffvalues(planefit);
alignment.planefit=planefit;
alignment.plane_dcoffset=cvals(1);
alignment.plane_xslope=cvals(2);%in microns z-shift per micron x
alignment.plane_yslope=cvals(3);%in microns z-shift per micron y

alignment.x_plane_angle=atan(alignment.plane_xslope)*180/pi;  %in degrees
alignment.y_plane_angle=atan(alignment.plane_yslope)*180/pi;  %in degrees

alignment.x_screw_turns=alignment.plane_xslope*screw_span*tpi*(1); %in turns
alignment.y_screw_turns=alignment.plane_yslope*screw_span*(1)*tpi;%in turns, reverse screw direction for y

alignment.x_screw_dtheta=alignment.x_screw_turns*360; %in degrees
alignment.y_screw_dtheta=alignment.y_screw_turns*360; %in degrees


output.alignment=alignment;

output.focus_map=focus_map;



if display_figures_flag
    
        figure_name = [figure_name ' - dX: ' num2str(alignment.x_screw_dtheta) ', dY: ' num2str(alignment.y_screw_dtheta) ];
    
       figure;
        set(gcf,'Name',figure_name);
%        subplot(121);
%    imagesc(focus_map);
       
       
%    subplot(122);
    surf(focus_map);
    shading flat;
%     view(3);
        title(['X Adjust: ' num2str(alignment.x_screw_dtheta) ',  Y Adjust: ' num2str(alignment.y_screw_dtheta)]);
        colormap(jet);
    
end



  

 
 
 



toc(a);
% matlabpool close;
beep; pause(.25);beep;



