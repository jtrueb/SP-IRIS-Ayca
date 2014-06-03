function [correlations,NA_output]=airyTemplate_measureNA(Image, KeyPoints, KernelSize, NA, backradius,pixel_image,Contrasts,showcrop_flag)
% 




NA_min=.6;
NA_max=1;
NA_step=.01;

NA_scan=[NA_min:NA_step:NA_max];

num_templates=length(NA_scan);



if nargin <3
    KernelSize=[11 11];
end

if nargin <2
    error('Function:Input:Issue','Keypoints vector is missing!');
end


NumKeyPoints=size(KeyPoints,2);
correlations=zeros(NumKeyPoints,1);
halfkernelsize=(KernelSize(1)-1)/2;

NA_output=zeros(NumKeyPoints,3);  %column1=contrast, column2 = best NA, column3=max corr, column 4=force NA, column5=force corr

% tic;
patch_array=cell(11,11);

for m=1:11;
    for n=1:11;
        patch_array{n,m}=(filtergen_AIRY_v2(KernelSize(1),[(n-6)/10 (m-6)/10],NA,backradius,pixel_image));
    end
end
% disp(['Patch Allocation time: ' num2str(toc)]);


% tic;
for keypoint=1:NumKeyPoints
    RawXLoc=KeyPoints(1,keypoint);
    TempXLoc =round(KeyPoints(1,keypoint));
    dx=RawXLoc-TempXLoc;
    RawYLoc=KeyPoints(2,keypoint);
    TempYLoc =round(KeyPoints(2,keypoint));
    dy = RawYLoc-TempYLoc;
    
    
%    GaussianPatch=GaussianPatch-mean(GaussianPatch(:));
    
    
    XLocStart=TempXLoc-halfkernelsize;
    XLocEnd=TempXLoc+halfkernelsize;
    YLocStart=TempYLoc-halfkernelsize;
    YLocEnd=TempYLoc+halfkernelsize;
    %Check for boundaries:
    if XLocStart > 0 && YLocStart >0
        if XLocEnd <size(Image,2) && YLocEnd <size(Image,1)
%             scaling is done in aiFit
%             airyPatch = (filtergen_AIRY_v2(KernelSize(1),[dx dy],NA,backradius,pixel_image));
            X_ind=round(dx*10)+6;
            Y_ind=round(dy*10)+6;
            
            
            TempImagePatch=Image(YLocStart:YLocEnd,XLocStart:XLocEnd);
            
            
            
            correlations(keypoint)=aiFit(TempImagePatch,patch_array{X_ind,Y_ind});
            
            temp_PSF=[];
            NA_fit_data=zeros(num_templates,2);
            for m=1:num_templates
                temp_PSF=(filtergen_AIRY_v2(KernelSize(1),[dx,dy],NA_scan(m),backradius,pixel_image));
                NA_fit_data(m,1)=NA_scan(m);
                NA_fit_data(m,2)=aiFit(TempImagePatch,temp_PSF);
            end
            [~,ind]=max(NA_fit_data(:,2));
            
            NA_output(keypoint,1)=Contrasts(keypoint);
            NA_output(keypoint,2)=NA_fit_data(ind,1); %best NA value
            NA_output(keypoint,3)=NA_fit_data(ind,2);
            NA_output(keypoint,4)=NA;
            NA_output(keypoint,5)=correlations(keypoint);
            
            
            
%             showcrop_flag=0;
            if showcrop_flag
                
                
                
                showpatch_flag=0;
                if showpatch_flag
                    if (correlations(keypoint)>.8)&&((Contrasts(keypoint)>1.05)&&(Contrasts(keypoint)<1.1))
                        
                        [maxIm,~]=max(TempImagePatch(:));
                        [minIm,~]=min(TempImagePatch(:));
                        tempRange=maxIm-minIm;
                        
                        
                        templateScale=airyPatch.aiMask;
                        [minTemplate,~]=min(templateScale(:));
                        templateScale=templateScale-minTemplate;
                        templateScale=templateScale*tempRange;
                        
                        
                        templateScale=templateScale+minIm;
                        
                        
                        
                        tempf=figure;
                        subplot(221);
                        surf(TempImagePatch);
                        title(['Particle - Contrast: ' num2str(Contrasts(keypoint))]);
                        view(2);
                        
                        subplot(223);
                        surf(TempImagePatch);
                        title(['Particle - Contrast: ' num2str(Contrasts(keypoint))]);
                        view(0,0);
                        
                        subplot(222);
                        surf(templateScale);
                        title(['Template: - Correlation: ' num2str(correlations(keypoint))]);
                        view(2);
                        
                        subplot(224);
                        surf(templateScale);
                        title(['Template: - Correlation: ' num2str(correlations(keypoint))]);
                        view(0,0);
                        
                        close(tempf);
                        
                    end
                end
            end
                        
            
%        
        else
            correlations(keypoint)=0;
             NA_output(keypoint,1)=-1;
            NA_output(keypoint,2)=-1; %best NA value
            NA_output(keypoint,3)=-1;
            NA_output(keypoint,4)=-1;
            NA_output(keypoint,5)=-1;
            continue;
        end
    else
        correlations(keypoint)=0;
         NA_output(keypoint,1)=-1;%contrast
            NA_output(keypoint,2)=-1; %best NA value
            NA_output(keypoint,3)=-1;
            NA_output(keypoint,4)=-1;
            NA_output(keypoint,5)=-1;
        continue;
    end
    
    
end

boundary_mask=correlations(:)>0;

mean_contrast=mean(NA_output(boundary_mask(:),1));
std_contrast=std(NA_output(boundary_mask(:),1));
mean_bestNA=mean(NA_output(boundary_mask(:),2));
std_bestNA=std(NA_output(boundary_mask(:),2));
mean_bestCorr=mean(NA_output(boundary_mask(:),3));
std_bestCorr=std(NA_output(:,3));

mean_forceCorr=mean(correlations(:));
std_forceCorr=std(correlations(:));

disp(['Total Particles: ' num2str(sum(boundary_mask(:)))]);
disp(['Contrast - Mean: ' num2str(mean_contrast) ',  Std: ' num2str(std_contrast)]);
disp(['Best NA - Mean: ' num2str(mean_bestNA) ',  Std: ' num2str(std_bestNA)]);
disp(['Best Corr - Mean: ' num2str(mean_bestCorr) ',  Std: ' num2str(std_bestCorr)]);
disp(['Force NA = ' num2str(NA) ' - Corr Mean: ' num2str(mean_forceCorr) ', - Corr Std: ' num2str(std_forceCorr)]);
 
% disp(['PSF preallocated time for ' num2str(NumKeyPoints) ': ' num2str(toc)]);