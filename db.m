function [y,x,varargout]=db(CurrentChannel,varargin)
%% single channel
%% get data from MDSplus database for exl50 and east
verbose=getappdata(0,'verbose');
if isempty(verbose)
    verbose=0;
end


   
%% full path 
isFullPath=0;
if isFullPath
    machine=getappdata(0,'machine');
    if strcmpi(machine, 'exl50')
        % fPath=[machine '::TOP:PID:'];
        fPath=[machine '::TOP:FBC:'];
        CurrentChannel=[fPath CurrentChannel];
    end
end

if nargin>=2
    timeWindow=varargin{1};
    pattern =':'; % '[-\d\.]+';
    timeResults = regexpi(timeWindow,pattern,'split'); 
    if strcmpi(timeResults{3},'nan')
        timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2}  ',0.001)'];
    elseif isnumeric(str2double(timeResults{3})) &&  str2double(timeResults{3})>0
        timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2}  ','  timeResults{3} ')'];
    else
        timeContext=['SetTimeContext('  timeResults{1}   ','  timeResults{2} ')'];
    end
    
    mdsvalue(timeContext);
    
    
   %% SetTimeContext sometimes does not work, I don't know why. 

end

try
    x=mdsvalue(['dim_of(\' CurrentChannel ')']);
    y=mdsvalue(['\' CurrentChannel]);
    Unit=mdsvalue(['units_of(\' CurrentChannel ')']);
    %% set the default unit
    if strcmpi(CurrentChannel,'mwi_ne001')
        Unit='10^1^7m^-^2';
    elseif  strcmpi(CurrentChannel,'ne')
         Unit='10^1^7m^-^2';
    elseif  strcmpi(CurrentChannel,'ip')
        Unit='kA';
    elseif  strcmpi(CurrentChannel,'itf')
        Unit='kA';
    elseif  strcmpi(CurrentChannel,'ipf1')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'ipf2')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'ipf3')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'ipf4')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'ipf5')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'ipf6')
        Unit='A';
    elseif  strcmpi(CurrentChannel,'LoopV')
        Unit='V';
    elseif  strcmpi(CurrentChannel,'sxr005p') || strcmpi(CurrentChannel,'sxr006p')
         y=smooth(y,11,'lowess');
        Unit='kA';
    end
    
    
               

    
    %% adjust the unit
    if  verbose==2
        if max(abs(y))>1.0e4
            y=y/1000;
            Unit=['k' Unit];
        elseif max(abs(y))<1.0e-4
            y=y*1000;
            Unit=['m' Unit];
        end
    end
catch
    setappdata(0,'MyErr','db, wrong when get data');
end



%% get the data
%x(end)=[];

if verbose==1
    if length(x)>1
        if isnumeric(x)
            title(CurrentChannel)
            figure
            plot(x,y)
        else
            msgbox('wrong when getting data')
        end
    else
        setappdata(0,'MyErr','db, wrong when get data');
    end
end

%% when error set x and y for display
if ~isnumeric(x) || length(x)<1
    x=0;
    y=0;
    Unit='au';
end
% 
% if length(x)<2
%     timeContext=['SetTimeContext()'];
%     %timeContext=['SetTimeContext(0,2,0.01)'];
%     mdsvalue(timeContext);
%     x=mdsvalue(['dim_of(\' CurrentChannel ')']);
%     y=mdsvalue(['\' CurrentChannel]);
%     Unit=mdsvalue(['units_of(\' CurrentChannel ')']);
% end
% 

if nargout>=3
    varargout{1}=Unit;
end
return
