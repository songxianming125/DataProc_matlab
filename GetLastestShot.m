function LastestShot=GetLastestShot

global  newServer  % for hl2a and hl2m

%get the Latest shot number
machine=getappdata(0,'machine');

if isempty(machine)
    machine=getOptionParameter('machine');
    changeDriver(machine);
end

switch machine
    case {'exl50','east','ehl'}
        
        [IpAddress,~] = getIpTree4Machine(machine);
        mdsconnect(IpAddress);
        switch machine
            case 'exl50'
                LastestShot=mdsvalue(['current_shot("exl50")']);
            case 'ehl'
                
               LastestShot=mdsvalue(['current_shot("ehl")']);
%                 LastestShot=0;
            case 'east'
                LastestShot=mdsvalue(['current_shot("pcs_east")']);
        end
        mdsdisconnect
    case {'hl2a','hl2m'}
        
        LastestShot=0;
        sxDriver=newServer;
        if exist(sxDriver,'dir')~=7
            sxDriver=getDriver;
        end
        
        dpf=fullfile(sxDriver, 'dpf','hl2a.dpf');
        fid = fopen(dpf,'r');
        if fid==-1
            warnstr=['File/',dpf,' does not exist!'];
            setappdata(0,'MyErr',warnstr);
            
            return
        else
            setappdata(0,'MyErr',[]);
        end
        %      temp=fread(fid,454,'int16');
        
        status = fseek(fid, 982, 'bof');
        LastestShot=fread(fid,1,'uint32');
        status = fclose('all');
    case 'localdas'
        newServer='C:\das';
        
        LastestShot=13400;
        
end
return



% if exist('z:')
%     dpf='z:\dpf\hl2a.dpf';
%     fid = fopen(dpf,'r');
%     if fid==-1
%         WarningString=strcat('File/',dpf,' does not exist!');%promt the need to update configuration
%         set(handles.lbWarning,'String',WarningString);
%         return
%     end
%
%     temp=fread(fid,454,'int16');
%     LastestShot=fread(fid,1,'uint16');
%     status = fclose('all');
%
% end
%


