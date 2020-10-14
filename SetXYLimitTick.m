function     SetXYLimitTick(xLeft,xRight,hfig)
%for browsering the curves
global  HeightNumber MyPicStruct PicDescription Axes2Lines Loc2Axes
ha=getappdata(hfig,'hAxis');
N=length(ha); %Axes number
RowNumber=MyPicStruct.RowNumber;
% ColumnNumber=MyPicStruct.ColumnNumber;

[L,S,R]=gettheXTick(xLeft,xRight); 
xLim=[L R];

% index1=find(HeightNumber,1,'last');
% haFirst=cell2mat(Loc2Axes(1:index1-1));
haFirst=cell2mat(Loc2Axes(1:end-1));



%% X tickLabel
% axes not in the bottom must be [] for XTickLabel
set(ha,{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabel'},{[]});



set(ha(haFirst(mod(haFirst,RowNumber)==0)),{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabelMode'},{'auto'});

haLast=cell2mat(Loc2Axes(end));

set(ha(haLast(1)),{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabelMode'},{'auto'});



for i=1:N
    index=Axes2Lines{i};
    if HeightNumber(mod(PicDescription(index(1)).Location-1,RowNumber)+1)==0
        CurrentHeightNumber=1;
    else
        CurrentHeightNumber=HeightNumber(mod(PicDescription(index(1)).Location-1,RowNumber)+1);
    end
    
    Yy=MyYTick(ha(i),MyPicStruct.YTickNum*CurrentHeightNumber,PicDescription(index(1)).RightDigit);%only  YTickMode of the first one curve is used for all curves within the same ha
end
