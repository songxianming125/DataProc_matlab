function channelNames = getChannelsInTree(tree,shot,varargin)


%% isSpecial=1, with AD data and layer 3
if nargin<3
    isSpecial=0;
else
    isSpecial=varargin{1};
end

channelNames={};
mdsopen(tree,shot);


mds_all= char([]);           % storage of all mds path names below TOP
Level_0= ['\' tree '::TOP']; % Top tree name
Level_1=   ['getnci("\' Level_0 '.*","FULLPATH")'];
level1s=char(mdsvalue(Level_1));

Levels=strvcat(char(Level_0),level1s); % get variable names from mds
level2s=[];  % this is layer 3, it is for layer 4


%% no 3 layer for general person
if isSpecial
    
    for kk=1:size(level1s,1)
        mds_nam=   deblank(level1s(kk,:));
        Level_2=   ['getnci("\' mds_nam '.*","FULLPATH")'];
        level2s=strvcat(level2s,char(mdsvalue(Level_2)));
        Levels=strvcat(Levels,char(mdsvalue(Level_2))); % get variable names from mds
    end
end



for kk=1:size(Levels,1)
    mds_nam=   deblank(Levels(kk,:));
    mdscmd=    ['getnci("\' mds_nam ':*","FULLPATH")'];
    channelNames=[channelNames;mdsvalue(mdscmd)]; % get variable names from mds
end
% 

% channelNames=[mdsvalue('getnci("\\pcs_east::TOP:*","FULLPATH")');mdsvalue('getnci("\\pcs_east::TOP.*:*","FULLPATH")')];


%% SELECT THE STRING
patternname='[^\s\o0]*';
channelNames = regexpi(channelNames, patternname, 'match','once');

%% ADD ad prefix to some subtree

% adTreeNames={'TOP.AI','TOP.MNT'};

if isSpecial
    patternname='(?<=EXL50\:\:TOP\.AI\:)([\w]*)';
    channelNames = regexprep(channelNames, patternname, 'AD$1');
    
    patternname='(?<=EXL50\:\:TOP\.MNT\:)([\w]*)';
    channelNames = regexprep(channelNames, patternname, 'AD$1');
    
    
    patternname='(?<=EXL50\:\:TOP\.AI\.[\w]*\:)([\w]*)';
    channelNames = regexprep(channelNames, patternname, 'AD$1');
end

patternname='[\w]*$';
channelNames = regexpi(channelNames, patternname, 'match','once');

index=~cellfun(@isempty,channelNames);
channelNames=channelNames(index);
mdsclose;
