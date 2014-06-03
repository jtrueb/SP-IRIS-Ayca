function [handles] = GUI_logMsg(handles,logmsg,logid,txtLog,feedbackLvl,errorFlag)
% Display log messages
[color] =  GUI_Colors();

if (nargin < 5)
    feedbackLvl =  2;
    errorFlag = 0;
elseif nargin < 6
    errorFlag = 0;
end

if logid == handles.const.log.dataset
    strpre = [ 'Dataset : '];
elseif logid == handles.const.log.particlefinder
    strpre = [ 'ParticleFinder: '];
elseif logid == handles.const.log.moviemaker
    strpre = [ 'Movie: '];    
elseif logid == handles.const.log.instrument
    strpre = [ 'Instrument: ']; 
elseif logid == handles.const.log.stage
    strpre = [ 'Stages: ']; 
elseif logid == handles.const.log.parameter
    strpre = [ 'Parameters: ']; 
elseif logid == handles.const.log.save
    strpre = [ 'Saved: ']; 
elseif logid == handles.const.log.camera
    strpre = [ 'Camera: ']; 
elseif logid == handles.const.log.led
    strpre = [ 'LEDs: ']; 
else
    strpre = [ num2str(logid) ' : '];
end

if feedbackLvl == 1
    %Outputs to status bar and command window
    set(txtLog,'String',[strpre logmsg]);
    disp([strpre logmsg]);
    
    [color] =  GUI_Colors();
    
    if errorFlag
        %If error, the color is red
        bgc = color.bgc{5};
    elseif errorFlag == 2
        bgc = color.bgc{6};
    else
        bgc = color.bgc{1};
    end
    set(txtLog,'Background',bgc);

elseif feedbackLvl == 2
    %Outputs to command window
    disp([strpre logmsg]);
    
elseif feedbackLvl == 3
    %Outputs to status bar
    set(txtLog,'String',[strpre logmsg]);
    bgc = color.bgc{1};
    set(txtLog,'Background',bgc);
end
drawnow;