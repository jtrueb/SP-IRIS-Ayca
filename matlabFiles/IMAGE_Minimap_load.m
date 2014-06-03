function [handles] = IMAGE_Minimap_load(handles,miniName)

temp = load(miniName);
[handles] = setParams(handles,'Minimap',temp.minimap);