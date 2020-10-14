function [sShot,myPath,mylist] = GetShotPath(CurrentShot,varargin)
global strShotDate  %for display in View
global  newServer

sShot=num2str(CurrentShot);


%% selecting the system for 200 shot
if isempty(str2num(sShot))  %sShot is a string, not shot number,no regexpress
    %because the dir structure, should have one number at least for get dir
    n=length(sShot);
    i=1;
    strShot=[];
    sSYS=[];
    % get the number, cancel the nan.
    while ~isempty(str2num(sShot(i)))
        strShot=[strShot sShot(i)];
        i=i+1;
    end
    
    % selecting the system for 200 shot
    m=length(strShot);
    if m>0
        if m<n
            sSYS=sShot(m+1:n);
        end
        % selecting the system for 200 shot
        if m==5
            sShot=strShot;  %first 3 letter is shot*100 % selecting the system for 200 shot
        elseif m==4
            sShot=[strShot '0'];  %first 4 letter is shot*100 % selecting the system for 200 shot
        elseif m==3
            sShot=[strShot '00'];  %first 3 letter is shot*100
        elseif m==2
            sShot=[strShot '000'];  %first 2 letter is shot*100
        elseif m==1
            sShot=[strShot '0000'];  %first 1 letter is shot*100
        end
    end
    
    %     myFile=strcat(num2str(CurrentShot),'*'); %linux
    myFile=strcat(strShot,'*',sSYS,'*.INF');
    myShot=str2num(sShot); % for dir finding
else % exact match
    L=length(sShot);
    patternShot=[sShot(1:end)];
    
    if L<5
        strZeros='00000';
        patternShot=[strZeros(1:(5-L)) patternShot];
    end
    myFile=strcat(patternShot,'*.INF'); %linux
    myShot=str2num(sShot);

    
end




if nargin==1
    sxDriver=newServer;
    if exist(sxDriver,'dir')~=7
        sxDriver=getDriver;
    end
    
    myDir = GetDir(myShot);
    myPathFile=fullfile(sxDriver,myDir,'inf',myFile);
elseif nargin==2
    myPathFile=fullfile(varargin{1},myFile);
elseif nargin==3
    sxDriver=newServer;
    if exist(sxDriver,'dir')~=7
        sxDriver=getDriver;
    end
    
    myDir = GetDir(myShot);
    myPathFile=fullfile(varargin{1},myDir,varargin{2},myFile); %varargin{2}='inftim'
end


%--------------------------------------------------------------------
[myPath, myFile, ext] = fileparts(myPathFile);
dir_struct = dir(myPathFile);



%% for mac which is case sensitive
% myPathFile = regexprep(myPathFile, '.INF', '.inf');
% [myPath, myFile, ext] = fileparts(myPathFile);
% dir_struct1 = dir(myPathFile);
% dir_struct = [dir_struct; dir_struct1];




[n,m]=size(dir_struct);

if n<1  % exchange the server
    if ~isempty(strfind(newServer,'2adas'))
        LastestShot=GetLastestShot;
        latestShotNumber=1000;
        if CurrentShot<LastestShot-latestShotNumber
            temp=oldServer;
            oldServer=newServer;
            newServer=temp;
            [sShot,myPath,mylist] = GetShotPath(CurrentShot,varargin{:});
            % restore the server
            temp=oldServer;
            oldServer=newServer;
            newServer=temp;
            return
        end
    end
elseif n<2% fuzzy match for many shot, default=10 shots
    L=length(sShot);
    if L>1
        patternShot=[sShot(1:end-1)];
    else
        patternShot=[];
    end
    if L<5
        strZeros='00000';
        patternShot=[strZeros(1:(5-L)) patternShot];
    end
    
    myFile=strcat(patternShot,'*.INF'); %linux
    myShot=str2num(sShot);
    
    
    
    
    if nargin==1
        sxDriver=newServer;
        if exist(sxDriver,'dir')~=7
            sxDriver=getDriver;
        end
        
        myDir = GetDir(myShot);
        myPathFile=fullfile(sxDriver,myDir,'inf',myFile);
    elseif nargin==2
        myPathFile=fullfile(varargin{1},myFile);
    elseif nargin==3
        sxDriver=newServer;
        if exist(sxDriver,'dir')~=7
            sxDriver=getDriver;
        end
        
        myDir = GetDir(myShot);
        myPathFile=fullfile(varargin{1},myDir,varargin{2},myFile); %varargin{2}='inftim'
    end
    
    
    %--------------------------------------------------------------------
    [myPath, myFile, ext] = fileparts(myPathFile);
    dir_struct = dir(myPathFile);
end



%% show the time for the shot 
% [sorted_names,sorted_index] = sortrows({dir_struct.name}');
mylist={dir_struct.name};
if ~isempty(dir_struct)
    % show the date of ccs file first
    k = strfind({dir_struct(:).name}, 'CCS');
    nn=~cellfun('isempty',k);
    if ~isempty(dir_struct(nn))
        strShotDate=[newServer ':' dir_struct(nn).name ':' dir_struct(nn).date];
    else
        strShotDate=[newServer ':' dir_struct(1).name ':' dir_struct(1).date];
    end
else
    strShotDate=[newServer ': No data file for shot:' num2str(CurrentShot)];
end
% if isempty(mylist)
