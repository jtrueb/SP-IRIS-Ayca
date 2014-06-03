function [handles, output] = eval_chip_SPIRIS2_GUI(handles)
%[ output ] = eval_chip_SPIRIS2(dp,'evens','wet',data_mir)
%             eval_chip_SPIRIS2(dp,'odds','dry',data_mir)
 savename_signal_analysis={};
par_mode=1;
ref_pdata=[];
if matlabpool('size')==0;
    matlabpool;
end
% try
%     if matlabpool('size')==0;
%         matlabpool;
%     else
%         matlabpool close;
%         matlabpool;
%     end
%     par_mode = 1;
% catch
%     disp('Matlab License Error for pooled computing, running in single thread mode')
% end
kde_options='contrast';
 temp_length=length(handles.signal_indices);
options=handles.analysis_type;
    
   %generate particle data from selected spot images 
   
   

   
   


 %generate nx2 pdata array of chosen analysis type (contrast or size) for
 %calc spot
 
 if par_mode
     calc_pdata=filescan_SPIRIS2_v4_multithread(handles,handles.signaldir,[handles.chipname_signal,handles.signal_dataID],handles.signal_indices,'signal');
     
     if ~strcmpi(options,'raw')
         ref_pdata=filescan_SPIRIS2_v4_multithread(handles,handles.refdir,[handles.chipname_reference,handles.signal_dataID],handles.reference_indices,'reference');
     end
     
     for i=1:length(handles.signal_indices)
         calc_pdata.xypdata{i}=pdata_toXY(calc_pdata.pdata{i}.particledata,kde_options,handles.limits_display,handles.limits_signal);
         calc_pdata.xypdata{i}.spot_ind=handles.signal_indices(i);
     end
     
 else
     calc_pdata=filescan_SPIRIS2_v4_singlethread(handles,handles.signaldir,[handles.chipname_signal,handles.signal_dataID],handles.signal_indices,'signal');
     
     if ~strcmpi(options,'raw')
         ref_pdata=filescan_SPIRIS2_v4_singlethread(handles,handles.refdir,[handles.chipname_reference,handles.signal_dataID],handles.reference_indices,'reference');
     end
     
     for i=1:length(handles.signal_indices)
         calc_pdata.xypdata{i}=pdata_toXY(calc_pdata.pdata{i}.particledata,kde_options,handles.limits_display,handles.limits_signal);
         calc_pdata.xypdata{i}.spot_ind=handles.signal_indices(i);
     end
     
 end
  
    ref_xypool=[];
     ref_xypdata=cell(1,temp_length);
  if strcmpi(options,'match') || strcmpi(options,'average')
      %generate nx2 pdata array for pooled reference particles (multi spot)
      for i=1:length(handles.reference_indices)
          ref_xypdata{i}=pdata_toXY(ref_pdata.pdata{i}.particledata,kde_options,handles.limits_display,handles.limits_signal);
          ref_xypdata{i}.spot_ind=handles.reference_indices(i);
          ref_xypdata{i}.pool_number=1;
      end
  end

  if strcmpi(options,'average');
      
      for i=1:length(handles.reference_indices)
          if i==1;
              ref_xypool=ref_xypdata{i};
          else
              ref_xypool.XY_raw = [ref_xypool.XY_raw;ref_xypdata{i}.XY_raw];
              ref_xypool.XY_filter = [ref_xypool.XY_filter;ref_xypdata{i}.XY_filter];
              
              ref_xypool.count_raw=size(ref_xypool.XY_raw,1);
              ref_xypool.count_filter=size(ref_xypool.XY_filter,1);
          end
          
      end
      ref_xypool.pool_number=length(handles.reference_indices);
      
  end
  
  
 %generate reference signal normalized kde surfaces of calc spots
 

 temp_signal_rect= calc_pdata.crop_rect_image;
 temp_reference_rect=[];
 if ~strcmpi(options,'raw')
     temp_reference_rect=ref_pdata.crop_rect_image;
 end
 
%  tempsize=size(calc_pdata.xypdata{i}.XY_raw,1);
 temp_calc_xypdata=calc_pdata.xypdata;

 temp_analysis_data={};
skip=zeros(1,length(handles.signal_indices));
 if par_mode
 parfor i=1:temp_length
     
     disp(['Building KDE plots for Index ' num2str(i) ' / ' num2str(temp_length)]);
     tempsize_calc=size(calc_pdata.xypdata{i}.XY_filter,1);
     
   if (tempsize_calc>0)
     %      temp =   PDF_posVsPool_v3(pdata_limits,calc_xypdata{i},ref_xypool);
     if strcmpi(handles.analysis_type,'match')
         tempsize_ref=size(ref_xypdata{i}.XY_filter,1);
         if tempsize_ref>0
             analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},ref_xypdata{i});
         else
             analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},[],50,1);
         end
         
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=temp_reference_rect;
         analysis_data.analysis_type_string = 'Index Matching';
         
     elseif strcmpi(handles.analysis_type,'average')
         analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},ref_xypool);
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=temp_reference_rect;
         analysis_data.analysis_type_string = 'Averaged';
     else
         analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},[],50,1);
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=[];
         analysis_data.analysis_type_string = 'Raw';
     end
     
     analysis_data.software_version=handles.software_version;
     analysis_data.calc_pdata=calc_pdata.pdata{i};
     temp_analysis_data{i}=analysis_data;
     
     savename_signal_analysis{i}=[handles.signaldir handles.chipname_signal '_ANALYSIS_' handles.signal_namelist{handles.signal_indices(i)}(end-9:end-4)];


   else
       skip(i)=1;
       disp('Error: no particles detected');
   end
 end
 
 else
  for i=1:temp_length
     
     disp(['Building KDE plots for Index ' num2str(i) ' / ' num2str(temp_length)]);
      tempsize=size(calc_pdata.xypdata{i}.XY_raw,1);
   if tempsize>=1
     %      temp =   PDF_posVsPool_v3(pdata_limits,calc_xypdata{i},ref_xypool);
     if strcmpi(handles.analysis_type,'match')
         analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},ref_xypdata{i});
         
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=temp_reference_rect;
         analysis_data.analysis_type_string = 'Index Matching';
         
     elseif strcmpi(handles.analysis_type,'average')
         analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},ref_xypool);
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=temp_reference_rect;
         analysis_data.analysis_type_string = 'Averaged';
     else
         analysis_data=PDF_posVsPool_v3(handles,temp_calc_xypdata{i},[],50,1);
         analysis_data.crop_rect_signal=temp_signal_rect;
         analysis_data.crop_rect_reference=[];
         analysis_data.analysis_type_string = 'Raw';
     end
     
     analysis_data.software_version=handles.software_version;
     
     
     temp_analysis_data{i}=analysis_data;
     
     savename_signal_analysis{i}=[handles.signaldir handles.chipname_signal '_ANALYSIS_' handles.signal_namelist{handles.signal_indices(i)}(end-9:end-4)];


   else
       skip(i)=1;
       disp('Error: no particles detected');
   end
 end
     
 end
 
 
 for i=1:length(handles.signal_indices)
     if skip(i)
         disp(['Index: ' num2str(handles.signal_indices(i)) ' has no particles.']);
     else
         analysis_data=temp_analysis_data{i};
     save(savename_signal_analysis{i},'analysis_data');
     end
 end
 disp('Processing Complete');
 
 output=savename_signal_analysis;
 
 if par_mode
%      matlabpool close;
 end
end
    











