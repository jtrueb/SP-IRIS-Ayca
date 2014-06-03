function GUI_Callback_popupSelectPostscan(hObject, eventdata)
%callback function - Populated when the CurrentFileGroup is selected
%Default value is none. If user selects a file, SingleParticleGUI is launched
%for image cropping then displayed in main figure
[handles] = guidata(hObject);
[handles] = GUI_clearMsg(handles);

currentIndex = get(handles.popupSelectPostscan,'Value');
[handles] = setParams(handles,'PostscanFile',currentIndex);

guidata(hObject,handles);