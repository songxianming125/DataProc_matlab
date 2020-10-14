function [y,x,varargout]=eastdbN(CurrentShot,CurrentChannel,varargin)
%% CurrentChannel should be regexp
machine='east';
setappdata(0,'machine',machine)
if iscell(CurrentChannel)
else
    CurrentChannel = getChannelsFromPattern( CurrentChannel);
end
[y,x,Unit]=dbs(machine,CurrentShot,CurrentChannel,varargin{:});

if nargout>=3
    varargout{1}=Unit;
end
if nargout>=4
    varargout{2}=CurrentChannel;
end
