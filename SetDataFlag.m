% --------------------------------------------------------------------
function DataFlag=SetDataFlag(varargin)
global  handles
handles=getappdata(0,'handles');
prompt = {strvcat('0=\\hl\2adas,1=Local short name,2=Tore Supra,', '3=Local long name,4=VEC,10=server long name')};
dlg_title = 'Change Data Access Mode,def=tog 0 and 10';
% num_lines= 1;
% def     = {'0'};
% y  = inputdlg(prompt,dlg_title,num_lines,def);
% DataFlag=str2num(y{1});%
% dlg_title = 'Change Data Access Mode';
num_lines= 1;
if get(handles.AccessMode,'UserData')==10
    DataFlag=0;
else
    DataFlag=10;
end

% def     = {num2str(DataFlag)};
def     = {num2str(0)};


y  = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(y)
    if get(handles.AccessMode,'UserData')==10
        DataFlag=0;
    else
        DataFlag=10;    
    end
else
    DataFlag=str2num(y{1});%
end
set(handles.AccessMode,'UserData',DataFlag);
