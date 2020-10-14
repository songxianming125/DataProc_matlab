function [y,t]=hl2aweb(CurrentShot,CurrentChannel,varargin)
tic
myPath= which('DP');
myPath=[myPath(1:end-4) 'data'];
passArguments=[num2str(CurrentShot) '/' CurrentChannel];



if nargin>=4
    if isnumeric(varargin{1})
        Tstart1=varargin{1};
        Tend1=varargin{2};
        if  ~isempty(Tstart1) && ~isempty(Tend1)
            if Tstart1<=Tend1
                Tstart=Tstart1;
                Tend=Tend1;
            elseif Tstart1>Tend1
                Tstart=Tend1;
                Tend=Tstart1;
            end
        end
        passArguments=[passArguments '/' num2str(Tstart) '/' num2str(Tend)];
    end
end


if nargin>=5
    sInterpPeriod=varargin{3};
    
    if isnumeric(sInterpPeriod)
                passArguments=[passArguments '/' num2str(sInterpPeriod)];
    elseif  ischar(sInterpPeriod)
                passArguments=[passArguments '/' sInterpPeriod];
    end
end

fullURL = ['http://dp.swip.ac.cn/' passArguments];
 
 
outFileName=[myPath filesep 'outFile.html'];
[filestr,status] = urlwrite(fullURL,outFileName);  % run and prepare the data

fileName=[CurrentChannel num2str(CurrentShot)];

fullURL = ['http://dp.swip.ac.cn/tempimg/songxm' '/' fileName '.zip'];

% tic
% filenames = unzip(fullURL,myPath);
% toc
% 

% tic
filename=[myPath fileName '.zip'];
[filestr,status] = urlwrite(fullURL,filename);
filenames = unzip(filestr,myPath);
% toc


load(filenames{:})

myCmd=['y=' CurrentChannel '(:,2);'];
eval(myCmd)
myCmd=['t=' CurrentChannel '(:,1);'];
eval(myCmd)
toc
 
 
%  
%  
% [filestr,status] = urlwrite(fullURL,filename);
%  unzip('filestr')