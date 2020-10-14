function h5save_z(list_save,h5_file)
% H5SAVE_Z saves a structure %list_save% with the
% hdf5 file name specified by %h5_file%
%
% Syntax:
%       h5save_z(list_save,h5_file);  %% tested on MATLAB 7.12.0 (R2011a)
%
% Description:
%   Please note the hdf5 file saved is not structured, i.e. all the structure fields are under '/'.
%
% Programmed and Copyrighted by J. Zhang: xyzhangj@physics.ucla.edu
%
% $Version=0.2 $Date=20120418
%   modified accordingly with the IDL version change
%       --Semi
%
% $Version=0.1 $Date=20120117
%   
% 

fid = H5F.create(h5_file,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

fields_list = fieldnames(list_save);

for id_field = 1:length(fields_list)
    var = eval(['list_save.',fields_list{id_field}]);
    
    if ischar(var)
        var_tid = H5T.copy('H5T_C_S1'); % instead of 'H5T_NATIVE_CHAR'
        var_sid = H5S.create('H5S_SCALAR');
        size_var = numel(var);
        H5T.set_size(var_tid,size_var);
        var_did = H5D.create(fid,fields_list{id_field},var_tid,var_sid,'H5P_DEFAULT');
        H5D.write(var_did,var_tid,'H5S_ALL','H5S_ALL','H5P_DEFAULT',var);
    else
        % datatype
        var_tid = H5T.copy('H5T_NATIVE_DOUBLE');
        % dataspace
        size_var = size(var);
        rank = length(size_var);
        var_sid = H5S.create_simple(rank,fliplr(size_var),[]);
        % dataset
        var_did = H5D.create(fid,fields_list{id_field},var_tid,var_sid,'H5P_DEFAULT');
        % write data into file
        H5D.write(var_did,'H5ML_DEFAULT','H5S_ALL','H5S_ALL','H5P_DEFAULT',var);
        
    end
    
    H5D.close(var_did);
    H5S.close(var_sid);
    H5T.close(var_tid);
end

H5F.close(fid);

end