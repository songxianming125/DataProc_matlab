function DataFlag=GetDataFlag(handles)
DataFlag=get(handles.AccessMode,'UserData');%
if isempty(DataFlag)
    DataFlag=SetDataFlag();
end
