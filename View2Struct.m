function newMyPicStruct=View2Struct(handles)
%%%********************************************************%%%
%%%This program is to update the structure value from      %%%
%%%        DP figure                                       %%%
%%%      Developed by Song xianming 2008/08/15/            %%%
%%%********************************************************%%%
%% totally 3 variables from view
global  Tstart Tend InterpPeriodFreq
global MyPicStruct
if isempty(MyPicStruct)
    MyPicStruct=MyPicInit;%init by file data
end

if isempty(handles) %% && ~ishandle(handles)
    newMyPicStruct=MyPicStruct;
    return
end

if MyPicStruct.LayoutMode==get(handles.LayoutMode,'value')-1;
else
    MyPicStruct.LayoutMode=get(handles.LayoutMode,'value')-1;
    MyPicStruct.Modified=1;
end



MyPicStruct.xright=str2double(get(handles.xRight,'String'));
MyPicStruct.xleft=str2double(get(handles.xLeft,'String'));



InterpPeriodFreq=deblank(get(handles.InterpPeriod,'String'));
if strcmpi(InterpPeriodFreq,'nan')
    InterpPeriodFreq=[];
end

iInterpPeriodFreq = str2double(InterpPeriodFreq);
if ~isnan(iInterpPeriodFreq)
    InterpPeriodFreq=iInterpPeriodFreq;
end


%% time unit setting
if strcmp(MyPicStruct.timeUnit,'s')
    Tstart=MyPicStruct.xleft*1000;
    Tend=MyPicStruct.xright*1000;
elseif strcmp(MyPicStruct.timeUnit,'ms')
    Tstart=MyPicStruct.xleft;
    Tend=MyPicStruct.xright;
end



MyPicStruct.xTickright=MyPicStruct.xright;
MyPicStruct.xTickleft=MyPicStruct.xleft;
newMyPicStruct=MyPicStruct;
% totally 7 variables from view