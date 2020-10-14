function MyChanList=ChannelsConditionning(MyChanList)

% MyChanList=strrep(MyChanList,char(161),'d'); %./. divide mark
% MyChanList=strrep(MyChanList,char(247),'r'); % ?  question mark
MyChanList=strrep(MyChanList,'-','_'); % minus
% MyChanList=strrep(MyChanList,'+','p'); % plus

MyChanList = regexp(MyChanList, '^[^\s\o0]*','match','once');  %begin not space not null

%transfer other language to US English
%% no use

% hInformation=figure('MenuBar','none','Tag','Information','visible','off','HitTest','off');%,...
% hList = uicontrol('parent',                   hInformation,'Style', 'listbox');
% set(hList,'string',MyChanList)
% MyChanList=get(hList,'string');
% 
% delete(hList)
% delete(hInformation)

%%

MyChanList=deblank(MyChanList);
