function [handles focus] = FOCUS_Image(handles,doCoarseFocus,doMedFocus,doFineFocus,doCrop)
focusAlgorithm = 1; %1 is jtg

stages = getParams(handles,'StagePointers');

if doCrop
    %Store current ROI
    curROI = getParams(handles,'ROI');
    %Calculate and store new ROI
    [handles,newROI] = FOCUS_CropRefSquare(handles);
    [handles] = setParams(handles,'ROI',newROI);
end

if focusAlgorithm == 1 % jtg
    range = 4;
    if(doCoarseFocus == 1)
        if FLAG_StopBtn('check')
            focus = 0;
            if doCrop
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
            end
            return
        end
        
        [handles,Q] = FOCUS_Coarse(handles,range,doCoarseFocus);
        focus = FOCUS_FitCoarse(Q,1);
        %add in 15 micron y translational offset
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},focus + 15);
        [handles,data] = ACQUIRE_scan(handles,'ROI');
        
    elseif(doCoarseFocus == 2)
        if FLAG_StopBtn('check')
            focus = 0;
            if doCrop
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
            end
            return
        end
        
        ZPos = getParams(handles,'ZPos');
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},ZPos-50);
        
        [handles Q] = FOCUS_Coarse(handles,range,doCoarseFocus);
        focus = FOCUS_FitCoarse(Q,1);
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},focus);
        [handles,data] = ACQUIRE_scan(handles,'ROI');
    end
    
    if doMedFocus == 1
        if FLAG_StopBtn('check')
            focus = 0;
            if doCrop
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
            end
            return
        end
        [handles,Q] = FOCUS_Medium(handles,range);
        focus = FOCUS_FitMedium(Q,range);
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},focus);
        [handles,data] = ACQUIRE_scan(handles,'ROI');
    end
       
    if doFineFocus == 1
        if FLAG_StopBtn('check')
            focus = 0;
            if doCrop
                %Revert ROI
                [handles] = setParams(handles,'ROI',curROI);
            end
            return
        end
        [handles,Q] = FOCUS_Fine(handles,6);
        focus = FOCUS_FitFine(Q,6);
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},focus);
        [handles,data] = ACQUIRE_scan(handles,'ROI');
    end
end

if doCrop
    %Revert ROI
    [handles] = setParams(handles,'ROI',curROI);
end