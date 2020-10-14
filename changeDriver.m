%% change the data source
% change the server or local driver for database source
%%
function machine=changeDriver(machine)
global  newServer  % for hl2a and hl2m
if nargin>0
    [IpAddress,strTreeName] = getIpTree4Machine(machine);
    newServer=['\\' IpAddress '\' strTreeName{1}];
    setappdata(0,'newServer',newServer);
    setappdata(0,'machine',machine);
else
    [user, ~]=getPSW;
    if isempty(user)
        MyMachines={'localdas'};
    else
        %     msgbox(['Welcome to use DP Mr. or Madam ' user],'notify');
        MyMachines={'hl2a', 'localdas', 'east', 'exl50','hl2m'};
    end
    
    fontsize=12;
    NumChannels=length(MyMachines);
    Rows=NumChannels+2;
    
    hChannelSelect=figure('MenuBar','none','Tag','ChannelSelect','Resize','off','HitTest','off');%,...
    scrsz = get(0,'ScreenSize');
    scrsz=[10 40 (scrsz(3)-scrsz(1))*0.2 scrsz(4)-scrsz(2)-30];
    scrsz=[10 40 fontsize*20 fontsize*Rows*2];
    set(hChannelSelect,'Units','points','Position',scrsz);
    
    
    Cols=2;
    wstep=scrsz(3)/Cols;
    hstep=scrsz(4)/Rows;
    w=wstep/3;
    h=hstep*0.85;
    b=scrsz(2)-26;
    l=6;
    
    
    
    
    for i=1:NumChannels
        hCheckBox(i) = uicontrol('parent',                   hChannelSelect,...
            'Units',                    'points', ...
            'String',                  '', ...
            'BackgroundColor',                  'b', ...
            'Position',                 [l,b,w/2,h],...
            'HorizontalAlignment',      'left', ...
            'FontWeight',               'bold', ...
            'FontSize',                 fontsize,...
            'Style',                    'pushbutton', ...
            'Enable',                   'on', ...
            'visible',                   'on', ...
            'callback',                 {@mySelect,i},...
            'Tooltipstring',            'channels OK');
        l2=l+w/2;
        hChannel(i) = uicontrol('parent',                   hChannelSelect,...
            'Units',                    'points', ...
            'String',                   MyMachines{i}, ...
            'Position',                 [l2,b,3*w,h],...
            'HorizontalAlignment',      'left', ...
            'FontWeight',               'bold', ...
            'FontSize',                 fontsize,...
            'Style',                    'edit', ...
            'Enable',                   'on', ...
            'Tooltipstring',            'channels OK');
        b=b+hstep;
    end
    
    machine=getappdata(0,'machine');
    hServer = uicontrol('parent',                   hChannelSelect,...
        'Units',                    'points', ...
        'String',                   machine, ...
        'Position',                 [l2,b,3*w,h],...
        'HorizontalAlignment',      'left', ...
        'FontWeight',               'bold', ...
        'FontSize',                 fontsize,...
        'Style',                    'edit', ...
        'Enable',                   'on', ...
        'Tooltipstring',            'current Server');
    b=b+hstep;
    
    
    
    % setappdata(0,'hCheckBox',hCheckBox)
    setappdata(0,'hChannel',hChannel)
    uiwait(hChannelSelect)
    
    % get and set the machine
    machine=getappdata(0,'machine');
    
    
    [IpAddress,strTreeName] = getIpTree4Machine(machine);
    setappdata(0,'IpAddress',IpAddress);
    setappdata(0,'strTreeName',strTreeName);
    %% set the driver for hl2a and hl2m

    switch lower(machine)
        case 'exl50'
        case 'east'
        case {'hl2a','hl2m'}
            newServer=['\\' IpAddress '\' strTreeName{1}];
        case 'localdas'
            
            newServer=IpAddress;
            %%
    end
   
    
    
    
    if isempty(machine)
        h = msgbox('Please use the licensed DP!','Registered Information','error');
    end
end


function mySelect(hObject, eventdata, index)


hChannel=getappdata(0,'hChannel');
machine=get(hChannel(index),'string');
setappdata(0,'machine',machine);




delete(get(hObject,'parent'))



