function  UDPserver(varargin)
myHost='192.168.20.199';
myRemotePort=12300;

if nargin>=3
    myLocalPort=varargin{1};
else
    myLocalPort=12301;
end


retry=0;
ntry=1;
while true
    retry = retry + 1;
    
    %try
    
    t = udp(myHost,myRemotePort,'LocalPort',myLocalPort);
    
    % Set size of receiving buffer, if needed.
    set(t, 'InputBufferSize', 30000);
      pause(1.5);
    % Open connection to the server.
    fopen(t);
    set(t,'Timeout',6000);
    while true
              pause(1.5);

        while (get(t, 'BytesAvailable') > 0)
            myMessage=fscanf(t);
            patternname='\d*$';
            strShot = regexpi(myMessage, patternname, 'match','once');
            if isempty(strShot)
                fclose(t);
                delete(t);
                clear t                
                return
            end
            UpdateScreens(str2double(strShot))
            ntry=ntry+1;
        end
        if ntry>10000
            break;
        end
        
    end
    
    % Disconnect and clean up the server connection.
    fclose(t);
    delete(t);
    clear t
    
    %catch
    
    % Disconnect and clean up the server connection.
    fclose(t);
    delete(t);
    clear t
    
    pause(1);
    %end
    if retry>32767
        retry=1;
    end
end

return