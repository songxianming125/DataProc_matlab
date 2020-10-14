function UpdataY(hObject,xLeft,xRight);

global   Axes2Lines MyCurves PicDescription ha 
AxesPower=getappdata(hObject,'AxesPower');
ylimit=get(ha,{'YLim'});
for i=1:length(ha)
    LinesIndex=Axes2Lines(i);
    Index=LinesIndex{:};
    if isempty(Index)
        continue;
    end
    pr=realpow(10,AxesPower(i));

    t=MyCurves(Index(1)).x;
    y=PicDescription(Index(1)).Factor*MyCurves(Index(1)).y+PicDescription(Index(1)).YOffset;
    t0=find(t>=xLeft,1);
    t1=find(t<=xRight,1, 'last');
    if isempty(t0) || isempty(t1) || t0>=t1
        continue;
    else
        ymin=min(y(t0:t1));
        ymax=max(y(t0:t1));
    end
    if length(Index)>1
        for ii=2:length(Index)
            t=MyCurves(Index(ii)).x;
            y=PicDescription(Index(ii)).Factor*MyCurves(Index(ii)).y+PicDescription(Index(ii)).YOffset;
            t0=find(t>=xLeft,1);
            t1=find(t<=xRight,1, 'last');
            if isempty(t0) || isempty(t1) || t0>=t1
                continue;
            end
            ymin=min(ymin,min(y(t0:t1)));
            ymax=max(ymax,max(y(t0:t1)));
        end
    end
    if ymin>=ymax
        continue;
    else
        ylimit(i,1)={[ymin/pr ymax/pr]};
    end
end %for i
%set(ha,{'YLim'},[ymin/pr ymax/pr]);
set(ha,{'YLim'},ylimit);
SetXYTick(xLeft,xRight)
return




