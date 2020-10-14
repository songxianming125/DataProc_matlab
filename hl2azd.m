function zd=hl2azd(CurrentShot,CurrentChannel,varargin)
%get the ZeroDrift offset from the specific time range
%
%zd=hl2azd(iCurrentShot,strCurrentChannel,zdTstart/strCurrentSysName,
%zdTend/strInfFilePath,iInterpPeriod/strFrequency,strCurrentSysName,strCurrentDataFile,structCurrentDasInf,strInfFilePath);
%
% option=1 means the item is necessary, option=0 means the item is optional
% input
% option  VarName             DataType           Meaning
% 1      iCurrentShot:       int                shot number
% 1      strCurrentChannel:  char/cell array     channel name(s)
% 0      zdTstart/strSys:     int/char         starting time/system
% 0      zdTend:              int/double         ending time
% 0      iInterpPeriod:      int/double         interpolation time
% 0      strFrequency:     char              frequency in Hz
% 0      strCurrentSysName:  char        system name which the channel belongs to
% 0      strCurrentDataFile: char        data file name where the channel's data is stored
% 0      strCurrentDasInf:   char        information file name corresponding to the data file
% 0      strInfFilePath:     char        path for the information file other than HL-2A database, such as your local file
%
% output:
% option    VarName             DataType        Meaning
% 1         zd                double array    output zd
%
%       The dependent function
%       1   hl2adb
%
%   Author(s): SONG Xianming 2009\01\06
%   Tested by advanced software engineer LUO Cuiwen.
%   All right reserved. Southwestern Institute of Physic, Chengdu, China.
%   No part of the software can be copied or used without the official approval. Thank you for your cooperation.
global  zdTstart zdTend Tstart Tend handles

%save time range
oldTstart=Tstart;
oldTend=Tend;



if nargin>=2
    if isnumeric(varargin{1})
        zdTstart1=varargin{1};
        zdTend1=varargin{2};
        if  ~isempty(zdTstart1) && ~isempty(zdTend1)
            if zdTstart1<=zdTend1
                zdTstart=zdTstart1;
                zdTend=zdTend1;
            elseif zdTstart1>zdTend1
                zdTstart=zdTend1;
                zdTend=zdTstart1;
            end
        end
    end
end



 if isempty(zdTstart)
    dlg_title = 'Start End';
    prompt = {'Enter the calibration start time in ms','Enter the calibration end time in ms'};
    def   = {'1','9'};
    num_lines= 1;
    answer  = inputdlg(prompt,dlg_title,num_lines,def);
    zdTstart=str2num(answer{1});
    zdTend=str2num(answer{2});
end

Tstart=zdTstart;
Tend=zdTend;


[y,x]=hl2adb(CurrentShot,CurrentChannel,varargin{:});
zd=sum(y,1)/size(y,1);


%  set(handles.Debug1,'string',[CurrentChannel '@' num2str(zdTstart) '/'  num2str(zdTend)])
%  warnmessage=['zd of ' CurrentChannel '@' num2str(zdTstart) '/'  num2str(zdTend) '=' num2str(zd)];
%  if isempty(handles)
%      handles=getappdata(0,'handles');
%  end
%  
% ShowWarning(0,warnmessage,handles); 


%disp(warnmessage)
% set(handles.Debug2,'string',num2str(zd))
%restore time range
Tstart=oldTstart;
Tend=oldTend;

return
