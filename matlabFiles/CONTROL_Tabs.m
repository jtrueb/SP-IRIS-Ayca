function [handles] = CONTROL_Tabs(handles,state)
%callback function - Disables/Enables the tabs
%setEnabledAt supersedes setEnabled

if nargin < 2
    state = 0;
end

state = 0;

% A direct alternative for getting jTabGroup
jTabGroup = getappdata(handle(handles.panels.left),'JTabbedPane');

if state == 0 %Enables all tabs
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,1);  % Enable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,1);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,1);  % Enable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,1);  % Enable only #6 (=7th tab)
    
elseif state == 1 %Enables only welcome tab
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,0);  % Disable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,0);  % Disable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,0);  % Disable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)
    
elseif state == 2 %Enables welcome & chip info
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,0);  % Disable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,0);  % Disable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)
    
elseif state == 3 %Enables all tabs except process & option
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,1);  % Enable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,0);  % Disable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)
    
elseif state == 4 %Enables all tabs except options
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,1);  % Enable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,1);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)
    
elseif state == 5 %Enables all tabs except options
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,1);  % Enable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,1);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,1);  % Enable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)

elseif state == 6 %Enables ChipInfo & Process tab
    jTabGroup.setEnabledAt(0,0);  % Disable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,0);  % Disable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,1);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)
    
elseif state == 7 %Disables instrument & acquisition tab
    jTabGroup.setEnabledAt(0,1);  % Enable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,0);  % Disable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,0);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,1);  % Enable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,1);  % Enable only #6 (=7th tab)
    
elseif state == 8 %Disables only welcome tab
    jTabGroup.setEnabledAt(0,0);  % Disable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,1);  % Enable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,1);  % Enable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,1);  % Enable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,1);  % Enable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,1);  % Enable only #6 (=7th tab)
    
elseif state >= 10 %Disables all tabs
    jTabGroup.setEnabledAt(0,0);  % Disable only #0 (=1th tab)
    jTabGroup.setEnabledAt(1,0);  % Disable only #1 (=2th tab)
    jTabGroup.setEnabledAt(2,0);  % Disable only #2 (=3th tab)
    jTabGroup.setEnabledAt(3,0);  % Disable only #4 (=5th tab)
    jTabGroup.setEnabledAt(4,0);  % Disable only #5 (=6th tab)
    jTabGroup.setEnabledAt(5,0);  % Disable only #6 (=7th tab)

end