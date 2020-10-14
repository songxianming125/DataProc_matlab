function [y,x,varargout]=hl2avec(CurrentShot,CurrentChannel,varargin)
%[vecY,vecT,strSys,strUnit]=hl2avec(iCurrentShot,strCurrentChannel,strCurrentDataFile,structCurrentVecInf);
%initialization for shortcut
CurrentDataFile=[];
CurrentVecInf=[];
if nargin>=4
    CurrentDataFile=varargin{1};
    CurrentVecInf=varargin{2};
end %nargin>=4


if isempty(CurrentDataFile) || isempty(CurrentVecInf)
else
    [x,y]=GetVecCurveN(CurrentDataFile,CurrentVecInf);
end



if nargout>=3
    varargout{1}='VEC';
    if nargout>=4
        varargout{2}=CurrentVecInf.YUnit;
    end
end %nargout>=3
