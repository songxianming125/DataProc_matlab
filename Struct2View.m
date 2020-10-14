function Struct2View(handles)
%%%********************************************************%%%
%%%           This program is to update DP figure  by      %%%
%%%                 the structure  value                   %%%
%%%      Developed by Song xianming 2008/08/15/            %%%
%%%********************************************************%%%
%%%********************************************************%%%
global MyPicStruct 
set(handles.xLeft,'string',num2str(MyPicStruct.xleft));
set(handles.xRight,'string',num2str(MyPicStruct.xright));
set(handles.LayoutMode,'value',MyPicStruct.LayoutMode+1);%defining the mode from 0 to 7

% totally 4 variables 