function list = h5read_z(h5file)
% H5READ_Z reads the variables into a structure %list% from hdf5 file specified by %h5file% (full path pointer)
%
% Syntax:
%       h5read_z(h5file);  %% tested on MATLAB 7.12.0 (R2011a)
%
% Description:
%   N/A 
%
% Programmed and Copyrighted by J. Zhang: xyzhangj@physics.ucla.edu
%
% $Version=0.1 $Date=20120117
%  
% 
% example: 
% b.vf=Result.vf; b.te=Result.te; %% creat a data structure
% b.id='temp'; %% specify the structure name
% h5save_z(b, 'D:\desktop\temp'); %% compatible with MATLAB 2011 or higher
% versions

% 

% %% High-level hdf5 access functions--does not handle string well
% % list.file = ['~/DATA/',id,'.h5'];
% % 
% % info_h5 = hdf5info(list.file);
% % 
% % tags_list =cell(numel(info_h5.GroupHierarchy.Datasets),1);
% % for id_tag=1:numel(info_h5.GroupHierarchy.Datasets)
% %     tags_list(id_tag)={info_h5.GroupHierarchy.Datasets(id_tag).Name};
% %     eval(['list.', lower(strrep(tags_list{id_tag},'/','')),' = hdf5read(list.file,''',strrep(tags_list{id_tag},'/',''),''');']);
% %     
% % end


% filename = [getenv('DATA_DIR'),'/D3D','/Data/hdf5/',id,'.h5'];
fid = H5F.open(h5file,'H5F_ACC_RDONLY','H5P_DEFAULT');

N_field = H5G.get_num_objs(fid);

fields_list = cell(N_field,1);
for id_field = 1:N_field
    fields_list(id_field) = {H5G.get_objname_by_idx(fid,id_field-1)};
    var_did = H5D.open(fid,fields_list{id_field});
    eval(['list.',lower(fields_list{id_field}), ' = H5D.read(var_did,''H5ML_DEFAULT'',''H5S_ALL'',''H5S_ALL'',''H5P_DEFAULT'');']);
    H5D.close(var_did);
end

H5F.close(fid);

end


