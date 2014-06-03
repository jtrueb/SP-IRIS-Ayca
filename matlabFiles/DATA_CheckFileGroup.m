function [handles] = DATA_CheckFileGroup(handles,chipID)

[handles] = DATA_refreshFileList(handles);
[handles] = setParams(handles,'CurrentFileGroup',chipID);