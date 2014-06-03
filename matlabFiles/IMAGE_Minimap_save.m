function [handles] = IMAGE_Minimap_save(handles)
%Saves the acquired minimap into the proper location assuming it has been
%populated

folder = get(handles.txtValueSaveFolder,'String');
chipID = get(handles.editChipID,'String');

minimap = handles.Minimap.data;
f_name = [folder '\' chipID handles.const.MinimapString handles.const.MatFileExtension];
save(f_name, 'minimap');

msg = f_name;
[handles] = GUI_logMsg(handles,msg,handles.const.log.save,handles.txtLog);
end