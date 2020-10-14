function exl50Upload(t,y,ShotNum,channelName,varargin)
%% upload the curve to database
% developed by Dr SONG Xianming in ENN
% exl50Upload(t,y,ShotNum,channelName,varargin)
% t is the time
% y is the curve
% ShotNum is the shot number
% channelName is the channel Name
% first varargin is the y Unit
% second varargin is the t Unit
% example: upload the ip curve
% exl50Upload(t,ip,ShotNum,channelName,'kA','s')

%% validation
if length(t)~=length(y)
    msgbox('the size of the variables are not the same!')
    return
end

%% machine information
machine='exl50';
[IpAddress,treeNames] = getIpTree4Machine(machine);

%% unit for the channel
if nargin>=5
    Uy=varargin{1};
else
    Uy='au';
end

if nargin>=6
    Ut=varargin{2};
else
    Ut='s';
end
%% connect and open
IpAddress='192.168.10.11';

mdsconnect(IpAddress);  %
mdsvalue('tcl($)',['set tree ' treeNames{1}]);
% mdsconnect('192.168.20.11');  %
% mdsvalue('tcl($)',['set tree exl50']);  %
mdsopen('exl50',ShotNum);

% 	status=mdsvalue('tcl($)',['create pulse ',ShotNum]);
%   keyboard

%% real action for upload
mdsput(['\' channelName],'build_signal(build_with_units($,$),*,build_with_units($,$))',y,Uy,t,Ut);%

%% disconnect and close
mdsclose
mdsdisconnect;




