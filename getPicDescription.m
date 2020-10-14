function PicDescription=getPicDescription(hCurves)
global  MyPicStruct 
global ha

% keep the channel sequence the same.
%  get the shotnumber


% get the channel we have selected
hCheckBox=hCurves(:,2);
value=get(hCheckBox(:),'value');
if iscell(value)
    indexs=cellfun(@(x) logical(x),value);
else
    indexs=logical(value);
end
hChanName=hCurves(:,3);
CurrentChannels=get(hChanName,'String');
setappdata(0,'selectedIndexs',indexs)

%% get the information from the configuration panel

selectedIndexs = find(indexs);
PicDescription=[];
defaultRowNumber=5;
if length(selectedIndexs)>defaultRowNumber
    MyPicStruct.RowNumber=defaultRowNumber;
    MyPicStruct.ColumnNumber=ceil(length(selectedIndexs)/defaultRowNumber);
else
    MyPicStruct.RowNumber=length(selectedIndexs);
    MyPicStruct.ColumnNumber=1;
end



for i=1:length(selectedIndexs)
    %{'Num'} {'YN'}  {'ChName'} {'Loc'}  {'Right'} {'Color'} {'Mkr'}  {'LineSty'} {'IntNum'} {'FraNum'} {'XOffset'} {'YOffset'} {'Factor'} {'Unit'} {'YAuto'} {'Stairs'}  {'Min'} {'Max'}]
    j=selectedIndexs(i);
    index=3;
    PicDescription(i).ChnlName=get(hCurves(j,index),'String');
    index=index+1;
    PicDescription(i).Location=i; %%build up the initial PictureArrangement
    index=index+1;
    PicDescription(i).Right=0; %str2num(get(hCurves(j,index),'String'));
    index=index+1;
    myColor=get(hCurves(j,index),'String');
    [cm,cn]=size(myColor);
    if cn>1
        format='%e';
        [C(1:3),count,errs]=sscanf(myColor,format);
    else
        C=myColor;
    end
    PicDescription(i).Color=C;
    index=index+1;
    PicDescription(i).Marker=get(hCurves(j,index),'String');
    index=index+1;
    PicDescription(i).LineStyle=get(hCurves(j,index),'String');
    index=index+1;
    PicDescription(i).LeftDigit=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    PicDescription(i).RightDigit=str2num(get(hCurves(j,index),'String'));
    
    index=index+1;
    PicDescription(i).XOffset=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    PicDescription(i).YOffset=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    PicDescription(i).Factor=str2num(get(hCurves(j,index),'String'));
    
    index=index+1;
    PicDescription(i).Unit=get(hCurves(j,index),'String');
    index=index+1;
    %     PicDescription(i).YLimitAuto=get(hCurves(j,index),'Value');
    PicDescription(i).YLimitAuto=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    %     PicDescription(i).IsStairs=get(hCurves(j,index),'Value');
    PicDescription(i).IsStairs=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    PicDescription(i).yMin=str2num(get(hCurves(j,index),'String'));
    index=index+1;
    PicDescription(i).yMax=str2num(get(hCurves(j,index),'String'));
end


