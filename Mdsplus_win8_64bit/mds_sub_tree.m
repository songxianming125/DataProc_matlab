function  mds_ot= mds_sub_tree(mds_in)
%
%  SYNTAX:
%          mds_ot= mds_sub_tree(mds_in)
%
%  PURPOSE:gets mds subtrees for next level down. 
%
%  INPUT: <default>
%    mds_in    = Input mds tree
%
%  OUTPUT:
%    mds_ot   = Output mds subtree names

%  WRITTEN BY:  Jim Leuer    ON      3/3/05
% ==========================================================================
% @(#)mds_sub_tree.m	1.3 07/09/09 

  mds_ot= char([]);
  for ii= 1:size(mds_in,1)
    mds_inn= deblank(mds_in(ii,:));
    mdscmd=   ['getnci("\' mds_inn '.*","FULLPATH")'];
    mds_cel=  mdsvalue(mdscmd); % get variable names from mds
    if(isempty(mds_cel))	% handle different nstx format
       mdscmd=   ['getnci("\\\' mds_inn '.*","FULLPATH")'];
       mds_cel=  mdsvalue(mdscmd); % get variable names from mds
    end
    mds_char= char(mds_cel);
    id= strmatch(upper(mds_inn), upper(mds_char));
    if ~isempty(id)
      mds_ot=   strvcat(mds_ot,mds_char(id,:));
    end
  end
  return

% testing

 mds_in= '\EFIT01::TOP';
 mds_ot= mds_sub_tree(mds_in)
 mds_in= mds_ot
 mds_ot= mds_sub_tree(mds_in)
 mds_in= mds_ot
 mds_ot= mds_sub_tree(mds_in)
 mds_in= mds_ot
 