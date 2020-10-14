function s=MarkLegend(hObject, eventdata,handles)
% Developed by Dr. X.M.Song. songxm@swip.ac.cn
s=0;
% global ha
% if length(ha)>=1
%         set(ha(1), 'yscale','log');
% else
%     
% end

% return
global  hLines
%%-------------------------------------------------------------------------------
for i=1:length(hLines)
    set(hLines(i),'Marker','none')
    x=get(hLines(i),'XData');            
    y=get(hLines(i),'YData');  
    hAxisLine=get(hLines(i),'Parent');  
    tTick=get(hAxisLine,'XTick');  
    index=interp1(x,[1:length(x)],tTick,'nearest');
    index(isnan(index))=length(x);
    hLinesMarkLegend(i)=line('Parent',hAxisLine,'XData',x(index),'YData',y(index),'Color',get(hLines(i),'Color'),'Marker','d','MarkerSize',20,'LineStyle','none');
%      delete(hLines(i))
end
s=1;
