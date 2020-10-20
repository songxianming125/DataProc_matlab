function  data = get_mds_tree(shot, tree, server, toupper, verbose)
%
%  SYNTAX:
%         data= get_mds_tree(shot, tree, server, toupper,verbose); % full call
%         data= get_mds_tree(shot);                        % defaults to DIII-D
%         data= get_mds_tree(shot, 'EFIT01', 'NSTX');      % for NSTX
%         data= get_mds_tree(shot, 'NB', 'DIII-D');        % example other tree
%
%  PURPOSE: Get entire selected mds tree from mdsplus database.
%
%  INPUT: <default>
%    shot   = shot number
%    tree   = tree to use <'EFIT01'>
%    server = MDS+ database to use: 'DIII-D'(default),'NSTX','EAST',
%		'THOR', 'OPEN'(assumes mdsconnect already called).  Other
%		inputs invoke mdsconnect(server) to connect to server.
%    toupper= 1= all variables made upper case, =-1 all var. made lower case
%             [0]= no change, variables made depending on mds case (typical UC)
%    verbose = set to 1 to get diagnostic prints during execution
%              <1> server= 'NSTX' or 'EAST'; (since can take some time to get)
%              <0> server= 'DIII-D' & all others;
%
%  OUTPUT:
%    data  = structure containing all data in MDS+ tree, with same tree
%	     structure except that 'TOP' replaced by 'tree'
%            See: data.allnames for list of all variables in full structure
%    Some Extra items added to structure (all lower case)
%      data.id    =   sting array of important data identifyer enf
%      data.shot  =   shot number
%      data.server=   MDS+ server
%      data.allnames= list of variables in structure with path relative to "TOP"
%      data.mdsnames= list of variables in structure with full mds path

%  WRITTEN BY:  Jim Leuer    ON      3/1/05 (original name get_mds_tree)
%  taken from get_mds_tree.m uses sub-structure to store
%  USES:   eq_mod
% To see MDS structure on HYDRA run traverser
% tested on DIII-D and NSTX data and should work for JET data but not tested
% ==========================================================================
%  @(#)get_mds_tree.m	1.11 11/22/11

if nargin==0
    disp('% get_mds_tree needs at least a "shot" argument')
    help get_mds_tree
    return
end
if nargin < 4
    toupper=0;
end
if nargin < 3
    server='DIII-D';
end
if nargin < 2
    tree= 'EFIT01';
end
if nargin < 5
    if strcmp(server,'NSTX') | strcmp(server,'EAST')
        verbose=1;
    else
        verbose=0;
    end
end
server = upper(server);

if isempty(toupper)  toupper= 0;       end
if isempty(server)   server= 'DIII-D'; end
if isempty(tree)     tree= 'EFIT01';   end
if isempty(verbose)
    if strcmp(server,'NSTX') | strcmp(server,'EAST')
        verbose=1;
    else
        verbose=0;
    end
end


% -----------------------------------------------
% Open and check conneciton to MDSPLUS data base:
tic
ier= 0; status=1;
mdsisopen=0;
% [shoto,status]=mdsopen('atlas.gat.com::EFIT01',shot)
if strcmp(server,'DIII-D') | strcmp(server,'DIIID') | strcmp(server,'D3D')
    status = mdsconnect('atlas.gat.com');
elseif strcmp(server,'EAST')
    status = mdsconnect('202.127.204.12');	% NOT SURE THIS WORKS
elseif strcmp(server,'NSTX')
    status = mdsconnect('skylark.pppl.gov:8501');
elseif strcmp(server,'KSTAR')
    if strcmp(getenv('HOST'),'datagrid') % On site at NFRI
        mds_server =  '172.17.100.200:8300';
    else % Offsite
        mds_server = '203.230.125.212:8005';
        mds_server = 'gridftp';
    end
    status = mdsconnect(mds_server);
elseif strcmp(server,'THOR')
    status = mdsconnect('thor');
elseif strcmp(server,'OPEN')
    disp(['%CAUTION: Assuming MDSCONNECT already called  and MDS is ',server])
    status = 1;
else
    disp(['WARNING get_mds_tree: Attempting to open server = ',server])
    status = mdsconnect(server);
end

if ~mod(status,2)
    ier=1;
    disp(['%ERROR get_mds_tree: unable to connect to ' server])
    data=[];
    return;
end

% Calling this twice seems to work better for NSTX (who knows why?)
[shoto,status]=mdsopen(tree,shot);
if(~mod(status,2))
    [shoto,status]=mdsopen(tree,shot);
end
if ~mod(status,2)
    ier=1;
    disp(['%ERROR get_mds_tree: unable to open ' tree ' for shot '  ...
        int2str(shot)])
    data=[];
    status=mdsdisconnect;
    return;
else
    if(verbose)
        disp(['% get_mds_tree opened tree, shot: ' tree ' ' int2str(shot)])
    end
end

% add identifier string to structure:
data.id= str2mat('mds_efit ', int2str(shot), tree, date);
data.shot= shot;
data.tree= tree;
data.server= server;
data.creator= 'get_mds_tree';
data.allnames= char([]);
data.mdsnames= char([]);

% ===============================================================
% Get List of tree node names using recursive algorithm & store in mds_all
% ===============================================================
mds_all= char([]);           % storage of all mds path names below TOP
mds_nam0= ['\' tree '::TOP']; % Top tree name
mds_nam= mds_nam0; % starting tree name
top_num= length(mds_nam);
mds_ot=  mds_nam;
while ~isempty(mds_ot)
    mds_all= strvcat(mds_all,mds_ot);
    mds_ot= mds_sub_tree(mds_ot);
end

% ===============================================================
% Process each name in mds_all for all variables present
% ===============================================================
for kk=1:size(mds_all,1)
    %   kk=0; kk=kk+1
    %    kk
    mds_nam=   deblank(mds_all(kk,:));
    mdscmd=    ['getnci("\' mds_nam ':*","FULLPATH")'];
    varnames=  mdsvalue(mdscmd); % get variable names from mds
    if(isempty(varnames))	% handle nstx different format
        mdscmd=    ['getnci("\\\' mds_nam ':*","FULLPATH")'];
        varnames=  mdsvalue(mdscmd); % get variable names from mds
    end
    varnamesc= char(varnames);
    idgood=    strmatch(upper(mds_nam0),upper(varnamesc));
    varnamesc= varnamesc(idgood,:);
    data_namesc= varnamesc(:,top_num+2:end);
    numvar= size(varnamesc,1);
    
    % loop over all variables
    if numvar>=30
        tic
        for ii= 1:numvar
            %         ii=0; ii=ii+1;
            fullnam= deblank(varnamesc(ii,:));
            data.mdsnames= strvcat(data.mdsnames,fullnam);
            %           dat=  mdsvalue(fullnam);  % Actual value of data
            dat=  0;  % Actual value of data
            
            subnam= deblank(data_namesc(ii,:)); %
            id= findstr(subnam,':');
            subnam(id)= '.';
            if toupper==1
                subnam= upper(subnam);
            elseif toupper==-1
                subnam= lower(subnam);
            end
            %          totnam= deblank(['data.' subnam]);
            totnam= deblank(subnam); % now relative address rather than absolute address allow for data name chg
            if toc > 5 | ii==1
                if(verbose)
                    disp(['% get_mds_tree Reading ' int2str(ii) '/', int2str(numvar),' variable: ', totnam]);
                end
                tic
            end  % if toc
            data.allnames= strvcat(data.allnames,totnam);
            str= ['data.' totnam '= dat;'];
            eval(str);
        end   % for ii
        
    elseif numvar>=1 % if numvar >=1
        for ii= 1:numvar
            %         ii=0; ii=ii+1;
            fullnam= deblank(varnamesc(ii,:));
            data.mdsnames= strvcat(data.mdsnames,fullnam);
            
            %           dat=  mdsvalue(fullnam);  % Actual value of data
            dat=  0;  % Actual value of data
            
            subnam= deblank(data_namesc(ii,:)); %
            id= findstr(subnam,':');
            subnam(id)= '.';
            if toupper==1
                subnam= upper(subnam);
            elseif toupper==-1
                subnam= lower(subnam);
            end
            %          totnam= deblank(['data.' subnam]);
            totnam= deblank(subnam);
            if ii==1
                if(verbose)
                    disp(['% get_mds_tree Reading ' int2str(ii) '/',int2str(numvar),' variable: ', totnam]);
                end
            end  % if ii
            data.allnames= strvcat(data.allnames,totnam);
            str= ['data.' totnam '= dat;'];
            eval(str);
        end   % for ii
    end    % if numvar
end      % for kk

if strcmp(server,'NSTX') | strcmp(server,'EAST')
    status=mdsdisconnect;  % Exit MDS+ if conneced to remote server
end

return

% ========================================================
% Testing
% ========================================================

% Testing SEE test_get_mds_tree
% (WATCH OUT 114504 has problems use 98549 Ferron High Performance)

%  data= get_mds_tree(114504);
%  data=  get_mds_tree(98549, 'EFIT01', 'DIII-D');
%  data=  get_mds_tree(98549, 'd3d', 'DIII-D');

data=  get_mds_tree(98549, [], [], -1);
data= eq_mk_time_last(data); % puts time at end (i.e. (130,1) => (1,130)

shot=98549; tree='EFIT01'; server='DIII-D'; toupper=-1; % make all lc variables
%  tree='d3d'; tree='IONS'
data=  get_mds_tree(shot, tree, server, toupper);
data=  get_mds_tree(98549, [], [], -1);
data=  get_mds_tree(shot, tree, 'OPEN', toupper);

filename='/u/leuer/efit/diiid/s98549/g098549.04000' %
read_gfile

shot=98549; tree='IONS'; server='DIII-D'; toupper=-1;
ions=  get_mds_tree(shot, tree, server, toupper);
shot=98549; tree='NB'; server='DIII-D'; toupper=-1;
nb=  get_mds_tree(shot, tree, server, toupper);

% ========================================================
% Check NSTX:
%  shot=110843; tree='EFIT01'; server='NSTX';

data=  get_mds_tree(113363, 'EFIT01','NSTX');
data= eq_mk_time_last(data); % puts time at end (i.e. (130,1) => (1,130)

shot=113363; tree='EFIT01'; server='NSTX';
clear data
data=  get_mds_tree(shot, tree, server);
