function newfunction(filename)
% NEWFUNCTION creates a function stub from the template defined in mfiletemplate_lbpp.m
%        The file will be created at current directory.
%
% Syntax:
% newfunction(functionname)
% - functionname : the function name to be created.
%
% Example:
% >> newfunction('bispectrum');  % Create a m-file containing a function
%                                % named 'bispectrum' with its filename
%                                'bispectrum.m'.
%
% See also:
% mfiletemplate_lbpp.m

% Copyright (c) CAS Key Laboratory of Basic Plasma Physics, USTC 1958-2011
% Author: Tao Lan
% Email: lantao@ustc.edu.cn
% All Rights Reserved.
% $Revision: 1.0$ $creationdate$
%            1.1$ Specify the author name and email at first two line.

author_name = 'Dr. Xianming SONG';                 % specified your name here
author_email = 'songxm@swip.ac.cn';    % specified your email here

if nargin == 0
    error('specify file/function name');
elseif filename(end) == 'm' && filename(end-1) == '.'
    error('provide function name without extension')
end

pathname = '';  % initilize the path as current directory.
% if file exist ...
if exist(filename, 'file')
    asw = questdlg('File exist, override it?','Override file', 'Yes', ...
        'No','Save as another','No');
    switch lower(asw)
        case {'no', ''}
            % cancle the operation
            disp('File exist, not override it.');
            return;
        case 'save as another'
            % save as another function
            [filename, pathname] = uiputfile('*.m', 'Save function as');
            if filename == 0
                % user cancle the operation
                disp('Cancled...');
                return
            end
            if strcmpi(filename(end-1:end),'.m')
                filename = filename(1:end-2);
            else
                % the file extension is not '.m', something wrong here
                error('the file extension is not ''.m''.');
            end
        case 'yes'
            % do nothing
        otherwise
            % some thing must be wrong here
            errordlg({'The answer can not be recognized.', ...
                ['answer is ''' asw '''']},'Error!!!')
            error('The answer can not be recognized.');
    end
end
%
% Open template file
templatefullpath = which('mfiletemplate.m');  % locate mfiletemplate.m
fid = fopen(templatefullpath);
% convert file in a stream of characters
funcTemplate = fread(fid, 'uint8=>char');
% Close Template file
fclose(fid);
% make sure it is a row vector
stringtemplate = funcTemplate(:)';

%%%%%%%%% MACRO DEFINITION %%%%%%%%%%
macros{1} = '$filename$';
tokens{1} = filename;

macros{2} = '$creationdate$';
tokens{2} = sprintf('Created on: %s', datestr(now, 0) );

macros{3} = '$author$';
tokens{3} = author_name;   

macros{4} = '$email$';
tokens{4} = author_email;   

macros{5} = '$year$';
tokens{5} = datestr(now, 10);

macros{6} = '$capsfilename$';
tokens{6} = upper(filename);

macros{7} = '$Version$';
tokens{7} = 'Version 1.0';

%%%%%%%%% MACRO SUBSTITUTIONS %%%%%%%%%%
% replace strings like macros{i} with the content of tokens{i}
for i=1:length(macros)
    stringtemplate= strrep(stringtemplate, macros{i},tokens{i});
end

%%%%%%%%% CREATION OF OUTPUT %%%%%%%%%%
fid = fopen(fullfile(pathname, strcat(filename,'.m')),'w');
if fid <0
    error(['Can''t create ''' filename '.m''']);
    return;
end
fwrite(fid, stringtemplate,'char');
fclose(fid);

% Open the new m-file
edit(fullfile(pathname, strcat(filename,'.m')));