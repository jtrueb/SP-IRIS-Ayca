function [handles Q] = FOCUS_Step(handles,curpos,SS,range,numsteps,coarse,moveDir)
%This function steps linearly thourgh a range of values determined by the
%input parameters.

stages = getParams(handles,'StagePointers');

count = 0;
Q.y = [];
Q.x = [];
prev_max = 0;
curr_max = 0;
images = 0;
initial = curpos;



for i = 1:numsteps
    [handles,data] = ACQUIRE_scan(handles,'ROI');
    
    focus = CAMERA_QuantFocus(data);
    
    Q.y = [Q.y focus];
    Q.x = [Q.x curpos];
    
    if moveDir > 0
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},[curpos+SS]);
    else
        [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},[curpos-SS]);
    end
    curpos = getParams(handles,'ZPos'); %[um]
    %[x y curpos] = STAGE_getPositions(stages);
  
    
    if(~coarse)
        curr_max = max(Q.y);
        if(curr_max~=prev_max)
            count = 0;
            prev_max=curr_max;
        else
            count = count + 1;
        end
        
        if(count>=range)
            if((find(max(Q.y)==Q.y)==1)||(find(max(Q.y)==Q.y)==2))
                
                if moveDir > 0 
                    [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},[curpos-(i+2)*SS]);
                else 
                    [handles] = STAGE_MoveAbsolute(handles,{stages.axis.z},[curpos+(i+2)*SS]);
                end
                curpos = getParams(handles,'ZPos');
                count = 0;
                Q.y = [];
                Q.x = [];
                prev_max = 0;
                curr_max = 0;
                i = 1;
%             else
%                 break;
            end
        end 
    end
end