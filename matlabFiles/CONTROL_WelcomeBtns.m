function handles = CONTROL_WelcomeBtns(handles, state)
%callback function - Disables/Enables the acquisition btns based on the
%instrument state
if nargin < 2
    state = 0;
end

[handles] = setParams(handles,'BtnState',state);

if state == 0 %Enables ChipInfo btn
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','off');
    set(handles.btnWelcomeFocus,'Enable','off');
%     set(handles.btnWelcomeMinimap,'Enable','off');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 1 %Enables ChipInfo & LoadChip
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','on');
    set(handles.btnWelcomeFocus,'Enable','off');
%     set(handles.btnWelcomeMinimap,'Enable','off');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 2 %Enables ChipInfo, LoadChip, & Focus
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','on');
    set(handles.btnWelcomeFocus,'Enable','on');
%     set(handles.btnWelcomeMinimap,'Enable','off');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 3 %Enables ChipInfo, LoadChip, Focus, % Minimap
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','on');
    set(handles.btnWelcomeFocus,'Enable','on');
%     set(handles.btnWelcomeMinimap,'Enable','on');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 4 %Enables ChipInfo, LoadChip, Focus, Minimap, Acquire
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','on');
    set(handles.btnWelcomeFocus,'Enable','on');
%     set(handles.btnWelcomeMinimap,'Enable','on');
    set(handles.btnWelcomeAcquire,'Enable','on');
    set(handles.btnWelcomeAutoAcquire,'Enable','on');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 5 %Enables ChipInfo, LoadChips, Focus, Minimap, Acquire, Unload
    set(handles.btnWelcomeChipInfo,'Enable','on');
    set(handles.btnWelcomeLoadChip,'Enable','on');
    set(handles.btnWelcomeFocus,'Enable','on');
%     set(handles.btnWelcomeMinimap,'Enable','on');
    set(handles.btnWelcomeAcquire,'Enable','on');
    set(handles.btnWelcomeAutoAcquire,'Enable','on');
    set(handles.btnWelcomeUnloadChip,'Enable','on');
    set(handles.btnWelcomeStop,'Enable','off');

elseif state == 10 %Disables all btns & except btnStop & welcome tab
    set(handles.btnWelcomeChipInfo,'Enable','off');
    set(handles.btnWelcomeLoadChip,'Enable','off');
    set(handles.btnWelcomeFocus,'Enable','off');
%     set(handles.btnWelcomeMinimap,'Enable','off');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','on');
    
elseif state >= 11 %Disables all btns
    set(handles.btnWelcomeChipInfo,'Enable','off');
    set(handles.btnWelcomeLoadChip,'Enable','off');
    set(handles.btnWelcomeFocus,'Enable','off');
%     set(handles.btnWelcomeMinimap,'Enable','off');
    set(handles.btnWelcomeAcquire,'Enable','off');
    set(handles.btnWelcomeAutoAcquire,'Enable','off');
    set(handles.btnWelcomeUnloadChip,'Enable','off');
    set(handles.btnWelcomeStop,'Enable','off');
end