function CAMERA = CAMERA_disconnect(handles)
instrument = getParams(handles,'Instrument');

if strcmpi(instrument,'Prototype')
    CAMERA = getParams(handles,'CameraPointers');
    CAMERA.sw.WriteLine('camdisconnect');
    CAMERA.sr.ReadLine();
    CAMERA.sw.WriteLine('exit');
    CAMERA.sr.ReadLine();
    CAMERA.s.Close();
    CAMERA.client.Close();
else
    client = handles.Stage.portnumber;
    flushinput(client);
    fclose(client);
    
    delete(client);
    clear client
end

if (getParams(instrument,'LEDControl') == 'Arduino')
    fclose(handles.LEDs.portnumber);
end