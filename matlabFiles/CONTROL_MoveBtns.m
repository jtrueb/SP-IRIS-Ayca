function handles = CONTROL_MoveBtns(handles, state)
%callback function - Disables/Enables the edit boxs and btns associated
%with moving

if nargin < 2
    state = 0;
end

if state == 0 %Disables all movement edits & btns
    set(handles.editZPos,'Enable','off');
    set(handles.btnZUp,'Enable','off');
    set(handles.editZStep,'Enable','off');
    set(handles.btnZDown,'Enable','off');
    set(handles.editXPos,'Enable','off');
    set(handles.editYPos,'Enable','off');
    set(handles.btnMoveYUp,'Enable','off');
    set(handles.btnMoveYDown,'Enable','off');
    set(handles.btnMoveXRight,'Enable','off');
    set(handles.btnMoveXLeft,'Enable','off');
    
elseif state == 1 %Enables all movement edits & btns
    set(handles.editZPos,'Enable','on');
    set(handles.btnZUp,'Enable','on');
    set(handles.editZStep,'Enable','on');
    set(handles.btnZDown,'Enable','on');
    set(handles.editXPos,'Enable','on');
    set(handles.editYPos,'Enable','on');
    set(handles.btnMoveYUp,'Enable','on');
    set(handles.btnMoveYDown,'Enable','on');
    set(handles.btnMoveXRight,'Enable','on');
    set(handles.btnMoveXLeft,'Enable','on');
    
end