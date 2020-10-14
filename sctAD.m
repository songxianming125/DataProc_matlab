function sctAD(varargin)
if nargin==0
    machine=getOptionParameter('machine');
    shot=GetLastestShot-1;
elseif nargin==1
    machine=varargin{1};
    shot=GetLastestShot-1;
elseif nargin==2
    machine=varargin{1};
    shot=varargin{2};
end

if shot<1
    shot=GetLastestShot+shot;
end

[IpAddress,treeNames] = getIpTree4Machine(machine);
mdsconnect(IpAddress);
path=getDProot(machine);     

if ~exist(path, 'dir')
    mkdir(path)
end

%%  mat format
if 1
    file=[machine '.mat'];
    file = fullfile(path,file);
    
    if exist(file, 'file')
        delete(file)
    end
    
    
    myChnlString='';
    
    for i=1:length(treeNames)
        %% isSpecial=1, with AD data and layer 3
        cmd=['Chnl= getChannelsInTree(''' treeNames{i} ''',' num2str(shot) ', 1);'];
        eval(cmd)
        % channelNames = getChannelsInTree(tree,shot);
        
        % unique the channel
        Chnl=unique(Chnl);
        
        myChnlString=[myChnlString ':' treeNames{i} ':;'];
        
        
        cmd='for i=1:length(Chnl); myChnlString=[myChnlString  Chnl{i} '';'' ]; end';
        eval(cmd)
    end
    
    save(file,'myChnlString')
    %% copy to Channels
    copyfile(file,[getDProot('Channels')  filesep machine '.mat'],'f')
    
end
%% copy to Channels


%% txt version
if 1
    file=[machine '.txt'];
    file = fullfile(path,file);
    
    if ~exist(path, 'file')
        delete(path)
    end
    
    
    fileID = fopen(file,'a');
    for i=1:length(treeNames)
        cmd=['Chnl= getChannelsInTree(''' treeNames{i} ''',' num2str(shot) ');'];
        eval(cmd)
        % channelNames = getChannelsInTree(tree,shot);
        Chnl=unique(Chnl);
        
        fprintf(fileID,'%s',[':' treeNames{i} ':;']);
        myChnlString='';
        cmd='for i=1:length(Chnl); myChnlString=[myChnlString  Chnl{i} '';'' ]; end';
        eval(cmd)
        fprintf(fileID,'%s',myChnlString);
    end
    fclose(fileID);
end
mdsdisconnect;


