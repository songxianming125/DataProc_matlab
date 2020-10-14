function myDate = getDateTime(CurrentShot,varargin)
%% developed by Dr. SONG Xianming with the help of Mr.LIU Yong in 2019.12.27
%% get the time when the channel is inserted
if nargin>1
    CurrentChannel=varargin{1};
else
    CurrentChannel='ip';
end

machine=getappdata(0,'machine');
strTreeName=getTreeName(machine,CurrentChannel); %
[server,~] = getIpTree4Machine(machine);
initServerTree(server,strTreeName{1},CurrentShot)
try
%     dateNumber=mdsvalue(['getnci("\\' strTreeName{1} '::TOP:FBC:' CurrentChannel '","TIME_INSERTED")']);  % VMS uint64 date format
    % dateNumber=mdsvalue(['getnci("\' CurrentChannel '","TIME_INSERTED")']);  % VMS uint64 date format
%     myDate=mdsvalue(['DATE_TIME(' num2str(dateNumber) ')']);
%     myDate=mdsvalue(['DATE_TIME(' double2str(dateNumber) ')']);
    %% you will lost accuracy when transfer to double
    myDate=mdsvalue(['DATE_TIME(getnci("\\' strTreeName{1} '::TOP:FBC:' CurrentChannel '","TIME_INSERTED"))']);  % VMS uint64 date format
    
catch
    myDate='no time stamp for this shot';
end
initServerTree;

end

