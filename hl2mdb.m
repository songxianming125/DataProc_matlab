function [y,x,varargout]=hl2mdb(CurrentShot,CurrentChannel,varargin)

if nargout==2
    [y,x]=hl2adb(CurrentShot,CurrentChannel,varargin{:});
end
if nargout==3
    [y,x,ou1]=hl2adb(CurrentShot,CurrentChannel,varargin{:});
    varargout{1}=out1;
end
if nargout==4
    [y,x,ou1,out2]=hl2adb(CurrentShot,CurrentChannel,varargin{:});
    varargout{1}=out1;
    varargout{2}=out2;
end
if nargout==5
    [y,x,ou1,out2,out3]=hl2adb(CurrentShot,CurrentChannel,varargin{:});
    varargout{1}=out1;
    varargout{2}=out2;
    varargout{3}=out3;
end

end

