function initialization(handles)
%%
%run before the DP operation, customize the personal function.
%%
tbh = findall(handles.DP,'Type','uitoolbar');
pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','showdb', 'ClickedCallback',{@showdb,handles});
tbh = findall(handles.DP,'Type','uitoolbar');
pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','comparedb', 'ClickedCallback',{@comparedb,handles});
% tbh = findall(handles.DP,'Type','uitoolbar');
% pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','SaveChannelsInHDF5', 'ClickedCallback',{@SaveChannelsInHDF5,handles});
% tbh = findall(handles.DP,'Type','uitoolbar');
% pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','changeDriver', 'ClickedCallback',{@changeDriver,handles});
% tbh = findall(handles.DP,'Type','uitoolbar');
% pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','SetDataFlag', 'ClickedCallback',{@SetDataFlag,handles});
% tbh = findall(handles.DP,'Type','uitoolbar');
% % pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','selectChannel', 'ClickedCallback',{@selectChannel,handles});
% % tbh = findall(handles.DP,'Type','uitoolbar');
% % pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','SaveInHDF5', 'ClickedCallback',{@SaveInHDF5,handles});
% % tbh = findall(handles.DP,'Type','uitoolbar');
% tbh = findall(handles.DP,'Type','uitoolbar');
% pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','addChnlFromStruct', 'ClickedCallback',{@addChnlFromStruct,handles});
pth=uipushtool(tbh,'CData',rand(20,20,3),'Separator','on','HandleVisibility','off','TooltipString','CopyVEC', 'ClickedCallback',{@CopyVEC,handles});
tbh = findall(handles.DP,'Type','uitoolbar');
