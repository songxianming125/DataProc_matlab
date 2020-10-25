function     SetXYTick(xLeft,xRight)
%for browsering the curves
global  ha HeightNumber MyPicStruct PicDescription Axes2Lines Loc2Axes Axes2Loc
N=length(ha); %Axes number
RowNumber=MyPicStruct.RowNumber;
ColumnNumber=MyPicStruct.ColumnNumber;
[L,S,R]=gettheXTick(xLeft,xRight); 
xLim=[L R];

%% X tickLabel
set(ha,{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabel'},{[]});


% axes in the bottom must not be [] for XTickLabel
indexLocBottom=RowNumber:RowNumber:RowNumber*ColumnNumber;  % bottom location
indexLoc=Axes2Loc(:);
indexLocXTick = intersect(indexLocBottom,indexLoc); 


indexAxes=cell2mat(Loc2Axes(indexLocXTick));
set(ha(indexAxes),{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabelMode'},{'auto'});
% axes in the end must not be [] for XTickLabel
lastAxes=cell2mat(Loc2Axes(end));
set(ha(lastAxes(1)),{'XLim'},{xLim},{'XTick'},{[L:S:R]},{'XTickLabelMode'},{'auto'});



for i=1:N
    index=Axes2Lines{i};
    if HeightNumber(mod(PicDescription(index(1)).Location-1,RowNumber)+1)==0
        CurrentHeightNumber=1;
    else
        CurrentHeightNumber=HeightNumber(mod(PicDescription(index(1)).Location-1,RowNumber)+1);
    end
    
    Yy=MyYTick(ha(i),MyPicStruct.YTickNum*CurrentHeightNumber,PicDescription(index(1)).RightDigit);%only  YTickMode of the first one curves is used
end