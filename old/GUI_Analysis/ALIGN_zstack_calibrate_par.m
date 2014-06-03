function [ output ] = ALIGN_zstack_calibrate_par(handles,fullpath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Fraction of smallest image dim to crop a center square from

density_cutoff=.5;

display_figures_flag=1;

if nargin <2
[filename,pathname]=uigetfile;

temp_file=load([pathname,filename]);
figure_name=filename(7:end-11);
else
   temp_file= load(fullpath);
    
% figure_name='test';

figure_name=fullpath(end-17:end-11);
end

zStack=temp_file.zStack;


if matlabpool('size')==0;
    matlabpool;
% else
%     matlabpool close;
%     matlabpool;
end

totaltime=tic;

IntTh=handles.IntTh;


eff_pixel=handles.pixelsize;






ROI_scale=1/4;
kde_offset=300;
kde_bins=108;

bandwidth=[50,50];

pdata_kde_limits=handles.limits_display;

output.pdata_kde_limits=pdata_kde_limits;

if isfield(zStack,'mirror')
    mirrorflag=1;
    mirror=zStack.mirror;
mirror_scale=(mirror-median(mirror(:)))/median(mirror(:))+1;
else
    mirrorflag=0;
end

im_temp=zStack.slice(1).image;
    res=[size(im_temp,1),size(im_temp,2)];  %# pixels in [Y,X]
    [min_res,min_dim]=min(res); %min_dim=1 if y is min, =2 if x is min
    
   
        

%increase ROI to full smallest dim
ROI_scale=1;
rect_length=min_res*ROI_scale;
    y_offset=(size(im_temp,1)-rect_length)/2;
    x_offset=(size(im_temp,2)-rect_length)/2;
    
    im_crop_indices=[y_offset+1:rect_length+y_offset;x_offset+1:rect_length+x_offset];
    
    kde_pixel_size=(rect_length+2*kde_offset)/kde_bins;
    kde_indices=[1+kde_offset/kde_pixel_size:kde_bins-kde_offset/kde_pixel_size];
 
    output.im_crop_indices=im_crop_indices;


    analysis_range=1:length(zStack.slice);
scanlength=length(analysis_range);
kde_binlength=length(kde_indices);

output.analysis_range=analysis_range;

 count_full_morph=zeros(1,scanlength);
    count_full_large=zeros(1,scanlength);
    count_full_neg=zeros(1,scanlength);
    count_full_allpos=zeros(1,scanlength);

    pdf_abs=zeros(kde_binlength,kde_binlength,1,scanlength);
parfor m=1:length(analysis_range)
    tic;
    im_crop=zStack.slice(analysis_range(m)).image(im_crop_indices(1,:),im_crop_indices(2,:)); 
    

        %%%%%
        particledata_quick=ZSTACK_generate_particles_NoPSF(im_crop,handles);
   
        %%%%%
        
    pos_mask_morph=(particledata_quick.Contrasts>1)&(particledata_quick.Contrasts<1.05);
    pos_mask_large = (particledata_quick.Contrasts>=1.05);
    neg_mask=particledata_quick.Contrasts<1;
    count_full_morph(m)=sum(pos_mask_morph(:));
    count_full_large(m)=sum(pos_mask_large(:));
    count_full_neg(m)=sum(neg_mask(:));
    count_full_allpos(m)=count_full_morph(m)+count_full_large(m);
    
%     kde=gkde2_bounded_v2(setdiff_xylocs,[-kde_offset -kde_offset rect_length+kde_offset rect_length+kde_offset],bandwidth,kde_bins);
    kde=gkde2_bounded_v2(particledata_quick.xylocs((pos_mask_morph(:)|pos_mask_large(:)|neg_mask(:)),:),[-kde_offset -kde_offset rect_length+kde_offset rect_length+kde_offset],kde_bins,bandwidth);
    
%     kde_pdata_focus(m)=kde;
    
%     [nelements,bincenters]=hist(im_crop(:),500);
%             [~,bin_ind]=max(nelements(1:end-1));
%             output.intPeak_detected(analysis_range(m)) = bincenters(bin_ind);
          
%             exposure_current = getParams(handles,'Exposure');
%             exposure_calibrated=exposure_current*(.65/intPeak_detected);
            
    
    
        tempvars(m).xpix=kde.x(1,kde_indices);
        tempvars(m).x_allpix=kde.x(kde_indices,kde_indices);
        tempvars(m).y_allpix=kde.y(kde_indices,kde_indices);
        tempvars(m).ypix=kde.y(kde_indices,1);
        
   
   
    
    %3d particle density array
%     pdf_abs(:,:,1,m)=kde.pdf(kde_indices,kde_indices).*kde.npart;
    temp_pdf{m}=kde.pdf(kde_indices,kde_indices).*kde.npart;


    
    disp(['Full Analysis of Slice ' num2str(analysis_range(m)) ' complete.  ZPos: ' num2str(zStack.slice(analysis_range(m)).z_pos) ', Pos Count: ' num2str(count_full_morph(m)) ', Time: ' num2str(toc)]);
    
end

for m=1:length(analysis_range)
    pdf_abs(:,:,1,m)=temp_pdf{m};
end


output.max_dens_abs=0;
output.max_pdata_abs=max(pdf_abs(:));
output.pdf_abs=pdf_abs;
% output.kde_marginal_difference=kde_marginal_difference;

density_map=zeros(kde_binlength,kde_binlength);
focus_map=zeros(kde_binlength,kde_binlength);

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





% output.pdf_pdata=pdf_pdata;
density_mask=density_map>(max(density_map(:))*density_cutoff);
output.density_mask=density_mask;
output.density_map=density_map;

output.x_vector=tempvars(1).xpix;
output.y_vector=tempvars(2).ypix;

 x_allpix=tempvars(m).x_allpix;
  y_allpix=tempvars(m).y_allpix;

output.x_full=x_allpix;
output.y_full=y_allpix;

screw_span=1.2; %inches, 1.2 for Dave's system, 1.25 for spiris2
tpi=100; %threads per inch

[planefit, goodnessoffit] = focus_planefit((x_allpix(density_mask(:)))*eff_pixel, (y_allpix(density_mask(:)))*eff_pixel, focus_map(density_mask(:)));
cvals=coeffvalues(planefit);
alignment.planefit=planefit;
alignment.plane_dcoffset=cvals(1);
alignment.plane_xslope=cvals(2);%in microns z-shift per micron x
alignment.plane_yslope=cvals(3);%in microns z-shift per micron y

alignment.x_plane_angle=atan(alignment.plane_xslope)*180/pi;  %in degrees
alignment.y_plane_angle=atan(alignment.plane_yslope)*180/pi;  %in degrees

alignment.x_screw_turns=alignment.plane_xslope*screw_span*(-1)*tpi; %in turns
alignment.y_screw_turns=atan(alignment.plane_yslope)*screw_span*(1)*tpi;%in turns, reverse screw direction for y

alignment.x_screw_dtheta=alignment.x_screw_turns*360; %in degrees
alignment.y_screw_dtheta=alignment.y_screw_turns*360; %in degrees


output.alignment=alignment;

output.focus_map=focus_map;

[focus_count,focus_slice]=max(count_full_allpos(:));


%Particle Population kde, must rescan in focus image w/ correlations
 im_crop=zStack.slice(analysis_range(focus_slice)).image(im_crop_indices(1,:),im_crop_indices(2,:)); 
    

        %%%%%
     
        particledata_full=ZSTACK_generate_particles_PSF(im_crop,handles);
%%%%%


 [xypdata_focus]=pdata_toXY(particledata_full,'contrast',pdata_kde_limits,pdata_kde_limits);
    kde_pdata_focus=gkde2_bounded_v2(xypdata_focus.XY_raw,[pdata_kde_limits(1),pdata_kde_limits(3),pdata_kde_limits(2),pdata_kde_limits(4)]);


output.focus_slice=analysis_range(focus_slice);
output.focus_zpos=zStack.slice(analysis_range(focus_slice)).z_pos;
output.focus_count=focus_count;
output.x_pos=zStack.x_pos;
output.y_pos=zStack.y_pos;

output.pdata_x=kde_pdata_focus(1).x(1,:);
output.pdata_y=kde_pdata_focus(1).y(:,1);

if display_figures_flag

    
    figure_name = [figure_name ' - IntTh: ' num2str(IntTh) ' - dX: ' num2str(alignment.x_screw_dtheta) ', dY: ' num2str(alignment.y_screw_dtheta) ];
    
    figure;
    set(gcf,'Name',figure_name);
    subplot(231);
    surf(output.x_vector,output.y_vector,focus_map);
    shading faceted;
    axis tight
    view(2);
    
    
    title('Pixel Space')
    subplot(232);
    % surf(output.x_vector.*eff_pixel,output.y_vector.*eff_pixel,focus_map);
    scatter3((x_allpix(density_mask(:)))*eff_pixel, (y_allpix(density_mask(:)))*eff_pixel, focus_map(density_mask(:)),10,'d','MarkerFaceColor',[1,1,.1]);
    % shading faceted
    axis tight
    hold on
%     plot(planefit)
%     alpha(.3);
    title(['X Adjust: ' num2str(alignment.x_screw_dtheta) ',  Y Adjust: ' num2str(alignment.y_screw_dtheta)]);
    view(3);
    
    subplot(233);
    imagesc([0 1200],[0 1200],pdf_abs(:,:,1,focus_slice));
    title(['Image at slice ' num2str(output.focus_slice) ', Count: ' num2str(output.focus_count)]);
    
    subplot(234);
    im_temp=zStack.slice(analysis_range(focus_slice)).image(im_crop_indices(1,:),im_crop_indices(2,:));
    imagesc(im_temp,[mean(im_temp(:))-std(im_temp(:)),mean(im_temp(:))+std(im_temp(:))]);
    title(['Particle Density for IntTh: ' num2str(IntTh)]);
    
    subplot(235);
    
    set(gcf,'Renderer','zBuffer')
    surf(kde_pdata_focus.x(1,:),kde_pdata_focus.y(:,1),kde_pdata_focus.pdf);
    shading interp
    axis(pdata_kde_limits); %[xmin xmax ymin ymax]
    title(['Focus @ Slice ' num2str(output.focus_slice) ' - Count: ' num2str(focus_count)]);
    view(2);
    
    subplot(236);
    plot(count_full_morph(:),'b');
    hold on;
    plot(count_full_neg(:),'r');
    plot(count_full_large(:),'g');
    plot(count_full_allpos(:),'m');
    title('Morph(Blue) - Neg(Red) - Large(green) - Pos Total(magenta)');
    
    
    %  subplot(224);
    %  surf(density_map);
    %  view(2);
    % %  imagesc(zStack.slice(analysis_range(focus_slice)).image(im_crop_indices(1,:),im_crop_indices(2,:)),[2400 3000]);
    %  title(['Max Density map for IntTh: ' num2str(IntTh)]);
    %  shading interp;
end

disp(['Total Analysis Time: ' num2str(toc(totaltime))]);

matlabpool close;
end

